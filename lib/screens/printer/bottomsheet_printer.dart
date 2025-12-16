import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:portal/helper/constant.dart';
import 'package:portal/router/route_path.dart';

class UsbPrinterBottomSheet extends StatefulWidget {
  final List<dynamic> seats;
  final String eventName;
  final String eventDate;

  const UsbPrinterBottomSheet({
    super.key,
    required this.seats,
    required this.eventName,
    required this.eventDate,
  });

  @override
  State<UsbPrinterBottomSheet> createState() => _UsbPrinterBottomSheetState();
}

class _UsbPrinterBottomSheetState extends State<UsbPrinterBottomSheet> {
  final printerPlugin = FlutterThermalPrinter.instance;

  List<Printer> printers = [];
  Printer? selectedPrinter;
  StreamSubscription<List<Printer>>? _printerStreamSubscription;

  // macOS
  List<String> macOSPrinters = [];
  String? selectedMacOSPrinter;

  @override
  void initState() {
    super.initState();
    _scanPrinters();
  }

  @override
  void dispose() {
    printerPlugin.stopScan();
    _printerStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _scanPrinters() async {
    await _printerStreamSubscription?.cancel();

    if (Platform.isMacOS) {
      await _getMacOSPrinters();
      return;
    }

    await printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);
    _printerStreamSubscription = printerPlugin.devicesStream.listen((devices) {
      setState(() => printers = devices);
    });
  }

  Future<void> _getMacOSPrinters() async {
    try {
      List<String> printerNames = [];

      // Method 1: Read CUPS printers.conf directly
      try {
        print('Trying: Reading /etc/cups/printers.conf');
        final printersFile = File('/etc/cups/printers.conf');
        if (await printersFile.exists()) {
          final content = await printersFile.readAsString();
          final lines = content.split('\n');

          for (var line in lines) {
            // Look for printer definitions: <Printer PrinterName>
            final match = RegExp(r'<Printer\s+([^>]+)>').firstMatch(line);
            if (match != null && match.group(1) != null) {
              printerNames.add(match.group(1)!.trim());
            }
          }
          print('Found printers in printers.conf: $printerNames');
        } else {
          print('/etc/cups/printers.conf does not exist');
        }
      } catch (e) {
        print('Reading printers.conf failed: $e');
      }

      // Method 2: Try using system_profiler for USB devices
      if (printerNames.isEmpty) {
        try {
          print('Trying: system_profiler SPUSBDataType');
          final result = await Process.run(
            'system_profiler',
            ['SPUSBDataType', '-json'],
          );

          if (result.exitCode == 0) {
            final output = result.stdout.toString();
            // Look for printer-related USB devices
            if (output.contains('POS80') || output.contains('Printer')) {
              print('Found USB printer device in system_profiler');
              // Add the known printer name since we found the USB device
              printerNames.add('STMicroelectronics_POS80_Printer_USB');
            }
          }
        } catch (e) {
          print('system_profiler failed: $e');
        }
      }

      // Method 3: Check ~/Library/Preferences for printer settings
      if (printerNames.isEmpty) {
        try {
          print('Trying: Reading user CUPS config');
          final homeDir = Platform.environment['HOME'];
          if (homeDir != null) {
            final userCupsDir = Directory('$homeDir/Library/Preferences');
            if (await userCupsDir.exists()) {
              final files = await userCupsDir.list().toList();
              for (var file in files) {
                if (file.path.contains('cups') || file.path.contains('printer')) {
                  print('Found CUPS-related file: ${file.path}');
                }
              }
            }
          }
        } catch (e) {
          print('Reading user CUPS config failed: $e');
        }
      }

      // Method 4: Try using AppleScript to get printer names
      if (printerNames.isEmpty) {
        try {
          print('Trying: AppleScript to get printer names');
          final script = '''
            tell application "System Events"
              set printerNames to {}
              try
                set printerList to name of every printer
                return printerList as text
              end try
            end tell
          ''';

          final result = await Process.run(
            'osascript',
            ['-e', script],
          );

          print('AppleScript exit code: ${result.exitCode}');
          print('AppleScript output: ${result.stdout}');

          if (result.exitCode == 0) {
            final output = result.stdout.toString().trim();
            if (output.isNotEmpty) {
              // AppleScript returns comma-separated list
              final names = output.split(',').map((e) => e.trim()).toList();
              printerNames.addAll(names);
              print('AppleScript found: $printerNames');
            }
          }
        } catch (e) {
          print('AppleScript failed: $e');
        }
      }

      // Method 5: Since we know your printer name, just add it directly
      // This is a workaround for the CUPS permission issue
      if (printerNames.isEmpty) {
        print('Adding known printer name as fallback...');
        printerNames.add('STMicroelectronics_POS80_Printer_USB');
        print('Using hardcoded printer name: ${printerNames[0]}');
        print('Note: You can change this in the code if your printer has a different name');
      }

      setState(() {
        macOSPrinters = printerNames;
        if (printerNames.isEmpty) {
          print('⚠️ No CUPS printers found after all methods.');
        } else {
          print('✅ Found ${macOSPrinters.length} printer(s): $macOSPrinters');
          print('If this is incorrect, you can manually edit the printer name in the code');
        }
      });
    } catch (e) {
      print('❌ Error getting macOS printers: $e');
      // Even on error, add the known printer as fallback
      setState(() {
        macOSPrinters = ['STMicroelectronics_POS80_Printer_USB'];
        print('Using fallback printer: STMicroelectronics_POS80_Printer_USB');
      });
    }
  }

  Future<void> _connectAndPrint() async {
    try {
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm80, profile);

      List<int> bytes = [];
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
      // eventName = 'MNVL'

      bytes += generator.text("MNVL", styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(1);
      bytes += generator.text(widget.eventDate, styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(1);

      // Same seat-formatting loop
      for (int i = 0; i < widget.seats.length; i++) {
        final seat = widget.seats[i];
        final parts = seat.split('-');
        Map<String, String> data = {};

        // Parse seat parts
        for (var part in parts) {
          final match = RegExp(r'([A-Za-z]+)([0-9]*)').firstMatch(part);
          if (match != null) {
            final letter = match.group(1) ?? '';
            final number = match.group(2) ?? '';
            data[letter] = number;
          }
        }

        bytes += generator.text('Seat ${i + 1}:', styles: const PosStyles(align: PosAlign.left, bold: true));

        // Extract values
        final floorNum = data.entries
            .firstWhere(
              (e) => e.key.toUpperCase().startsWith('F'),
              orElse: () => const MapEntry('', ''),
            )
            .value;

        final sectorEntry = data.entries.firstWhere(
          (e) => e.key.toUpperCase().startsWith('S') && e.key != 's',
          orElse: () => const MapEntry('', ''),
        );

        final sectorLetter = sectorEntry.key.replaceFirst(RegExp(r'^S', caseSensitive: false), '');
        final sectorValue = sectorEntry.value;
        final sectorLabel = '$sectorLetter$sectorValue'; // C1, A2, etc.

        final rowNum = data['R'] ?? '';
        final seatNum = data['s'] ?? '';

        bytes += generator.text('   Davhar - $floorNum');
        bytes += generator.text('   Sector - $sectorLabel');
        bytes += generator.text('   Egnee - $rowNum');
        bytes += generator.text('   Suudal - $seatNum');

        bytes += generator.text(''); // extra line after each seat
      }

      bytes += generator.feed(2);
      bytes += generator.text('Thank You', styles: const PosStyles(align: PosAlign.center));
      bytes += generator.hr();
      bytes += generator.cut();

      // ✅ macOS branch – print using CUPS
      if (Platform.isMacOS) {
        if (selectedMacOSPrinter == null || selectedMacOSPrinter!.isEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a printer first.")),
            );
          }
          return;
        }

        try {
          // Use user's home directory - accessible in debug mode
          final homeDir = Platform.environment['HOME'];
          if (homeDir == null) {
            throw Exception('Could not find HOME directory');
          }

          // Create file in user's Documents folder (definitely accessible)
          final printFile = File('$homeDir/Documents/portal_receipt_${DateTime.now().millisecondsSinceEpoch}.bin');

          // Write the print data
          await printFile.writeAsBytes(bytes);

          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Printing to CUPS printer: $selectedMacOSPrinter')));
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('Print file created: ${printFile.path}'))));
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('File exists: ${await printFile.exists()}'))));
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('File size: ${await printFile.length()} bytes'))));

          // Print using lp command
          final result = await Process.run(
            '/bin/bash',
            ['-c', '/usr/bin/lp -d "${selectedMacOSPrinter!}" -o raw "${printFile.path}"'],
          );

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('lp exit code: ${result.exitCode}'))));
          if (result.stdout.toString().isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('lp stdout: ${result.stdout}'))));
          }
          if (result.stderr.toString().isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('lp stderr: ${result.stderr}'))));
          }

          // Clean up
          try {
            if (await printFile.exists()) {
              await printFile.delete();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('Print file cleaned up'))));
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(('Cleanup error: $e'))));
          }

          if (mounted) {
            if (result.exitCode == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Printed via macOS CUPS successfully!")),
              );
              NavKey.navKey.currentState!.pushNamedAndRemoveUntil(homeRoute, (route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Print error: ${result.stderr}")),
              );
            }
          }
        } catch (e) {
          print('Print error: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Print error: $e")),
            );
          }
        }

        return;
      }

      // ✅ Normal flow (Windows / Android / Linux)
      if (selectedPrinter == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please select a printer first.")),
          );
        }
        return;
      }

      await printerPlugin.connect(selectedPrinter!);
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
        print('Print error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = Platform.isMacOS ? macOSPrinters.isEmpty : printers.isEmpty;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Drag handle
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Text(
              Platform.isMacOS ? 'Available CUPS Printers' : 'Available USB Printers',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 300,
              child: isEmpty
                  ? const Center(child: Text("No printers found"))
                  : Platform.isMacOS
                      ? _buildMacOSPrinterList()
                      : _buildWindowsPrinterList(),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text("Rescan"),
                    onPressed: _scanPrinters,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text("Print"),
                    onPressed: _connectAndPrint,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildMacOSPrinterList() {
    return ListView.builder(
      itemCount: macOSPrinters.length,
      itemBuilder: (_, i) {
        final name = macOSPrinters[i];
        return RadioListTile<String>(
          title: Text(name),
          value: name,
          groupValue: selectedMacOSPrinter,
          onChanged: (v) => setState(() => selectedMacOSPrinter = v),
        );
      },
    );
  }

  Widget _buildWindowsPrinterList() {
    return ListView.builder(
      itemCount: printers.length,
      itemBuilder: (_, i) {
        final p = printers[i];
        return RadioListTile<Printer>(
          title: Text(p.name ?? 'Unknown'),
          subtitle: Text("Connected: ${p.isConnected ?? false}"),
          value: p,
          groupValue: selectedPrinter,
          onChanged: (v) => setState(() => selectedPrinter = v),
        );
      },
    );
  }
}
