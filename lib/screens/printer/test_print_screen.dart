// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/router/route_path.dart';

class UsbPrinterScreen extends StatefulWidget {
  const UsbPrinterScreen({super.key});

  @override
  State<UsbPrinterScreen> createState() => _UsbPrinterScreenState();
}

class _UsbPrinterScreenState extends State<UsbPrinterScreen> {
  final printerPlugin = FlutterThermalPrinter.instance;
  List<Printer> printers = [];
  Printer? selectedPrinter;
  StreamSubscription<List<Printer>>? _printerStreamSubscription;
  List<dynamic> seats = [];
  String eventName = '';
  String eventDate = '';
  String texs = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
      _scanPrinters();
      seats = args['seats'] is int ? [] : args['seats'];
      eventName = args['name'] ?? 'null';
      eventDate = args['date'] ?? DateTime.now().toString();

      setState(() {});
      // init();
    }));
  }

  Future<void> _scanPrinters() async {
    // Cancel previous listener if any
    await _printerStreamSubscription?.cancel();

    // Start scanning for USB printers
    await printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);

    // Listen to printer updates
    _printerStreamSubscription = printerPlugin.devicesStream.listen((List<Printer> devices) {
      print('devices:${devices}');
      setState(() {
        printers = devices;
      });
    });
  }

  Future<void> _connectAndPrint() async {
    // if (selectedPrinter == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Please select a printer first.")),
    //   );
    //   return;
    // }

    try {
      await printerPlugin.connect(selectedPrinter!);

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      List<int> bytes = [];
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

      // Event name
      bytes += generator.text(
        eventName,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.feed(1);
      bytes += generator.text(
        eventDate,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.feed(1);

      for (int i = 0; i < seats.length; i++) {
        final seat = seats[i];

        // Split by '-'
        final parts = seat.split('-');
        Map<String, String> data = {};

        for (var part in parts) {
          // Match pattern like F1, S2, R3, s5, SG, etc.
          final match = RegExp(r'([A-Za-z]+)([0-9]*)').firstMatch(part);
          if (match != null) {
            final letter = match.group(1) ?? '';
            final number = match.group(2) ?? '';

            // Save parsed parts by their type
            data[letter] = number;
          }
        }

        // Detect whether it’s the full format or short format
        bool hasFloor = data.keys.any((key) => key.toUpperCase().startsWith('F'));
        bool hasSmallS = data.keys.any((key) => key == 's');
        bool hasSector = data.keys.any((key) => key.toUpperCase().startsWith('S') && key != 's');

        // Print Seat number
        bytes += generator.text(
          'Seat ${i + 1}:',
          styles: const PosStyles(align: PosAlign.left, bold: true),
        );

        if (hasFloor && hasSmallS && hasSector) {
          // Format: F*-S*-R*-s*
          // Example: F1-SA-R1-s6
          final floorNum = data.entries.firstWhere((e) => e.key.toUpperCase().startsWith('F'), orElse: () => const MapEntry('', '')).value;
          final sectorLetter =
              data.entries.firstWhere((e) => e.key.toUpperCase().startsWith('S') && e.key != 's', orElse: () => const MapEntry('', '')).key;
          final sectorValue =
              data.entries.firstWhere((e) => e.key.toUpperCase().startsWith('S') && e.key != 's', orElse: () => const MapEntry('', '')).value;
          final rowNum = data['R'] ?? '';
          final seatNum = data['s'] ?? '';

          final sectorLabel = sectorValue.isNotEmpty ? '$sectorLetter$sectorValue' : sectorLetter!.substring(1);

          bytes += generator.text('   Davhar - $floorNum');
          bytes += generator.text('   Sector - ${sectorLabel.substring(sectorLabel.length - 1)}');
          bytes += generator.text('   Egnee - $rowNum');
          bytes += generator.text('   Suudal - $seatNum');
        } else {
          // Short format like V1-R2-S14 or SG-R3-S15
          final keys = data.keys.toList();

          for (var key in keys) {
            if (key.toUpperCase().startsWith('V')) {
              bytes += generator.text('   VIP - ${data[key]}');
            } else if (key.toUpperCase().startsWith('SG') || (key.toUpperCase().startsWith('S') && !key.contains(RegExp(r'[0-9]')))) {
              bytes += generator.text('   Sector - ${key.replaceAll("S", "")}');
            } else if (key.toUpperCase().startsWith('R')) {
              bytes += generator.text('   Egnee - ${data[key]}');
            } else if (key.toUpperCase().startsWith('s')) {
              bytes += generator.text('   Suudal - ${data[key]}');
            }
          }
        }

        bytes += generator.text(''); // Add spacing
      }

      bytes += generator.feed(2);
      bytes += generator.text('Thank You', styles: const PosStyles(align: PosAlign.center));
      bytes += generator.hr();
      bytes += generator.cut();
      print('bytes:${bytes.toString()}');


      await printerPlugin.printData(selectedPrinter!, bytes);
      await printerPlugin.disconnect(selectedPrinter!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Printed successfully!")),
        );
        NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    // Stop scanning and cancel stream
    printerPlugin.stopScan();
    _printerStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal USB printer v1.0'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Available USB Printers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: printers.isEmpty
                  ? const Center(child: Text("No printers found."))
                  : ListView.builder(
                      itemCount: printers.length,
                      itemBuilder: (context, index) {
                        final p = printers[index];
                        return ListTile(
                          title: Text(p.name ?? "Unknown"),
                          subtitle: Text("Connected: ${p.isConnected ?? false}"),
                          leading: Radio<Printer>(
                            value: p,
                            groupValue: selectedPrinter,
                            onChanged: (val) {
                              setState(() {
                                selectedPrinter = val;
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Rescan"),
              onPressed: _scanPrinters,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text("Print"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _connectAndPrint,
            ),
          ],
        ),
      ),
    );
  }
}
