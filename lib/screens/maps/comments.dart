import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Comentarios"),
      body: Center(
        child: Text(
          "Esta funcionalidad aún no está implementada.",
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      ),
    );
  }
}
