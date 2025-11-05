// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:flutter_thermal_printer/utils/printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';



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
  @override
  void initState() {
    super.initState();
       Future.delayed(Duration.zero, (() {
      dynamic args = ModalRoute.of(context)?.settings.arguments;
          _scanPrinters();
          seats = args['seats'];
          eventName = args['name'];
          eventDate = args['date'];


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
    _printerStreamSubscription =
        printerPlugin.devicesStream.listen((List<Printer> devices) {
      setState(() {
        printers = devices;
      });
    });
  }

  Future<void> _connectAndPrint() async {
    if (selectedPrinter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a printer first.")),
      );
      return;
    }

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

    // Split by "-" first
    final parts = seat.split('-'); // e.g., ["F1", "SG1", "R2", "S7"]

    List<String> formattedParts = [];

    for (var part in parts) {
      // Separate letters from numbers
      final match = RegExp(r'([A-Za-z]+)([0-9]+)').firstMatch(part);
      if (match != null) {
        final letter = match.group(1);
        final number = match.group(2);
        formattedParts.add('$letter - $number');
      } else {
        // If no match, just add part as-is
        formattedParts.add(part);
      }
    }

    // Join parts with comma
    final seatLine = 'Seat ${i + 1}: ${formattedParts.join(', ')}';

    bytes += generator.text(
      seatLine,
      styles: const PosStyles(align: PosAlign.left),
    );
  }
  bytes += generator.feed(2);
  bytes += generator.text('Thank You', styles: const PosStyles(align: PosAlign.center));
  bytes += generator.hr();
  bytes += generator.cut();

      await printerPlugin.printData(selectedPrinter!, bytes);
      await printerPlugin.disconnect(selectedPrinter!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Printed successfully!")),
        );
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
                          subtitle:
                              Text("Connected: ${p.isConnected ?? false}"),
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
