import 'package:flutter/material.dart';

class SeverityLabel extends StatelessWidget {
  final String severity;

  const SeverityLabel({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    String label;
    Color dotColor;

    switch (severity.toLowerCase()) {
      case 'high':
        label = 'Alto';
        dotColor = Colors.red;
      case 'medium':
        label = 'Medio';
        dotColor = Colors.yellow;
      case 'low':
        label = 'Bajo';
        dotColor = Colors.green;
      default:
        label = 'Desconocido';
        dotColor = Colors.grey;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: dotColor,
          ),
        ),
      ],
    );
  }
}
