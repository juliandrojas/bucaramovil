import 'package:bucaramovil/controllers/db_firebase_test.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class PruebaPage extends StatelessWidget {
  const PruebaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Crear"),
      body: FutureBuilder(
        future: getCollection(),
        builder: ((context, snapshot) {
          return const Text("Hola");
        }),
      ),
    );
  }
}
