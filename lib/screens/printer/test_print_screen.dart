// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:path_provider/path_provider.dart';
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

  // macOS-specific
  List<String> macOSPrinters = [];
  String? selectedMacOSPrinter;

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
    }));
  }

  Future<void> _scanPrinters() async {
    // Cancel previous listener if any
    await _printerStreamSubscription?.cancel();

    if (Platform.isMacOS) {
      // macOS: Get printers from CUPS
      print('macOS detected – fetching CUPS printers...');
      await _getMacOSPrinters();
      return;
    }

    // Normal flow for Windows/Android/Linux
    await printerPlugin.getPrinters(connectionTypes: [ConnectionType.USB]);
    _printerStreamSubscription = printerPlugin.devicesStream.listen((List<Printer> devices) {
      setState(() {
        printers = devices;
      });
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
      bytes += generator.text(eventName, styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(1);
      bytes += generator.text(eventDate, styles: const PosStyles(align: PosAlign.center, bold: true));
      bytes += generator.feed(1);

      // Same seat-formatting loop
      for (int i = 0; i < seats.length; i++) {
        final seat = seats[i];
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

          print('Printing to CUPS printer: $selectedMacOSPrinter');
          print('Print file created: ${printFile.path}');
          print('File exists: ${await printFile.exists()}');
          print('File size: ${await printFile.length()} bytes');

          // Print using lp command
          final result = await Process.run(
            '/bin/bash',
            ['-c', '/usr/bin/lp -d "${selectedMacOSPrinter!}" -o raw "${printFile.path}"'],
          );

          print('lp exit code: ${result.exitCode}');
          if (result.stdout.toString().isNotEmpty) {
            print('lp stdout: ${result.stdout}');
          }
          if (result.stderr.toString().isNotEmpty) {
            print('lp stderr: ${result.stderr}');
          }

          // Clean up
          try {
            if (await printFile.exists()) {
              await printFile.delete();
              print('Print file cleaned up');
            }
          } catch (e) {
            print('Cleanup error: $e');
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
  void dispose() {
    printerPlugin.stopScan();
    _printerStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine which printer list to show
    final isEmptyList = Platform.isMacOS ? macOSPrinters.isEmpty : printers.isEmpty;

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
            Text(
              Platform.isMacOS ? 'Available CUPS Printers:' : 'Available USB Printers:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isEmptyList
                  ? const Center(child: Text("No printers found."))
                  : Platform.isMacOS
                      ? _buildMacOSPrinterList()
                      : _buildWindowsPrinterList(),
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

  Widget _buildMacOSPrinterList() {
    return ListView.builder(
      itemCount: macOSPrinters.length,
      itemBuilder: (context, index) {
        final printerName = macOSPrinters[index];
        return ListTile(
          title: Text(printerName),
          subtitle: const Text("CUPS Printer"),
          leading: Radio<String>(
            value: printerName,
            groupValue: selectedMacOSPrinter,
            onChanged: (val) {
              setState(() {
                selectedMacOSPrinter = val;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildWindowsPrinterList() {
    return ListView.builder(
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
    );
  }
}
