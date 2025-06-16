import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String description;
  final String imageUrl;
  final String severity;

  const PostCard({
    super.key,
    required this.description,
    required this.imageUrl,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            SizedBox(height: 8),
            Image.network(imageUrl, height: 150, fit: BoxFit.cover),
            SizedBox(height: 8),
            Row(children: [Icon(Icons.location_on), Text("Ubicación")]),
            SizedBox(height: 8),
            Container(
              width: 30,
              height: 30,
              color: getColorFromSeverity(severity),
              alignment: Alignment.center,
              child: Text(
                severity[0].toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorFromSeverity(String severity) {
    switch (severity) {
      case 'red':
        return Colors.red;
      case 'yellow':
        return Colors.yellow;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
