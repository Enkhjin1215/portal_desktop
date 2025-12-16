import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:path_provider/path_provider.dart';

PrinterService printerService = PrinterService();

class PrinterService {
  final printerPlugin = FlutterThermalPrinter.instance;

  StreamSubscription<List<Printer>>? _printerStream;
  List<Printer> usbPrinters = [];
  List<String> macPrinters = [];

  // ----------------------------------------------------------
  // PUBLIC API — Parent widget зөвхөн энэ function-ийг дуудахад болно
  // ----------------------------------------------------------
  Future<void> printTicket({
    required List<String> seats,
    required String eventName,
    required String eventDate,
  }) async {
    if (Platform.isMacOS) {
      return await _printMacOS(await _buildPrintBytes(seats, eventName, eventDate));
    } else {
      return await _printUSB(seats, eventName, eventDate);
    }
  }

  // ----------------------------------------------------------
  // 🔧 ESC/POS PRINT DATA GENERATOR
  // ----------------------------------------------------------
  Future<List<int>> _buildPrintBytes(List<String> seats, String eventName, String eventDate) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];

    // bytes += generator.feed();
    bytes += generator.hr();
    bytes += generator.feed(1);

    bytes += generator.text(
      'PORTAL.MN',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(1);
    bytes += generator.text(eventName, styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.feed(1);
    bytes += generator.text(eventDate, styles: const PosStyles(align: PosAlign.center));
    bytes += generator.feed(1);

    for (int i = 0; i < seats.length; i++) {
      final seat = seats[i];
      final parts = seat.split('-');
      Map<String, String> data = {};

      for (var part in parts) {
        final match = RegExp(r'([A-Za-z]+)([0-9]*)').firstMatch(part);
        if (match != null) {
          data[match.group(1)!] = match.group(2) ?? '';
        }
      }

      final floor = data['F'] ?? '';
      final sectorEntry = data.entries.firstWhere((e) => e.key.toUpperCase().startsWith('S') && e.key != 's', orElse: () => const MapEntry('', ''));
      final sectorLetter = sectorEntry.key.replaceFirst(RegExp(r'^S', caseSensitive: false), '');
      final sectorLabel = '$sectorLetter${sectorEntry.value}';

      final rowNum = data['R'] ?? '';
      final seatNum = data['s'] ?? '';

      bytes += generator.text('Seat ${i + 1}:', styles: const PosStyles(bold: true));
      bytes += generator.text('   Davhar - $floor');
      bytes += generator.text('   Sector - $sectorLabel');
      bytes += generator.text('   Egnee - $rowNum');
      bytes += generator.text('   Suudal - $seatNum');
      bytes += generator.text('');
    }

    bytes += generator.feed(2);
    bytes += generator.text('Thank you!', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();
    bytes += generator.cut();

    return bytes;
  }

  // ----------------------------------------------------------
  // 🖨 WINDOWS / ANDROID / LINUX PRINTING (USB)
  // ----------------------------------------------------------
  Future<void> _printUSB(List<String> seats, String eventName, String eventDate) async {
    try {
      await _printerStream?.cancel();
      // scan printers
      await printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);

      _printerStream = printerPlugin.devicesStream.listen((List<Printer> devices) {
        print("testtttt : ${devices.length}");
        usbPrinters = devices;
      });
      for (var printer in usbPrinters) {
        usbPrinters.firstWhere((e) => e.name!.contains('80'));
      }
      // wait a bit for scan to complete
      await Future.delayed(const Duration(seconds: 1));

      if (usbPrinters.isEmpty) {
        // throw Exception("USB printer not found");
        // _printUSB(seats, eventName, eventDate);
      }
   
      final Printer printer = usbPrinters.firstWhere((e)=>e.name!.contains('80'));
      final bytes = await _buildPrintBytes(seats, eventName, eventDate);

      await printerPlugin.connect(printer);
      await printerPlugin.printData(printer, bytes);
      await printerPlugin.disconnect(printer);
    } catch (e) {
      print("EXCEPTION PRINT:$e");
      rethrow;
    } finally {
          dispose();
    }
  }

  Future<void> _printMacOS(List<int> bytes) async {
    String printerName = 'STMicroelectronics_POS80_Printer_USB';
    try {
      // macOS sandbox-safe temp folder
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/portal_${DateTime.now().millisecondsSinceEpoch}.bin';

      final file = File(filePath);
      await file.writeAsBytes(bytes);
      print('Saved print file: $filePath');

      // lp command (Sandbox-д зөвшөөрөгдсөн)
      final result = await Process.run(
        'lp',
        ['-d', printerName, filePath],
      );

      print('lp exit code: ${result.exitCode}');
      print('stdout: ${result.stdout}');
      print('stderr: ${result.stderr}');
    } catch (e) {
      print('❌ macOS print error: $e');
      rethrow;
    }
  }

  // ----------------------------------------------------------
  // CLEANUP
  // ----------------------------------------------------------
  void dispose() {
    printerPlugin.stopScan();
    _printerStream?.cancel();
  }
}
//STMicroelectronics_POS80_Printer_USB
