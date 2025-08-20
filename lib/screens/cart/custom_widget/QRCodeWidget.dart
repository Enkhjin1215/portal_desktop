import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeWidget extends StatelessWidget {
  final String qrData;

  QRCodeWidget({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 200.0,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
      errorStateBuilder: (context, error) {
        return const Center(
          child: Text(
            'Uh oh! Something went wrong...',
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
