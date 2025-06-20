import 'package:flutter/material.dart';

class SeverityDot extends StatelessWidget {
  final String severity;

  const SeverityDot({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    Color dotColor;

    switch (severity.toLowerCase()) {
      case 'red':
        dotColor = Colors.red;
      case 'yellow':
        dotColor = Colors.yellow;
      case 'green':
        dotColor = Colors.green;
      default:
        dotColor = Colors.grey; // Por defecto
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
    );
  }
}
