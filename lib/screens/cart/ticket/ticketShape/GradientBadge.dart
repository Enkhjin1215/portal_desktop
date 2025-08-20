import 'package:flutter/material.dart';

class GradientBadge extends StatelessWidget {
  final String text;

  const GradientBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2AD0CA),
            Color(0xFFE1F664),
            Color(0xFFEFB0FE),
            Color(0xFFABB3FC),
            Color(0xFF5DF7A4),
            Color(0xFF58C4F6),
          ],
          stops: [0, 0.2, 0.5, 0.7, 0.9, 1],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}
