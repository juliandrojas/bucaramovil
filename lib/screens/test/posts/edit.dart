import 'package:bucaramovil/controllers/db_firebase_test.dart';
import 'package:bucaramovil/screens/components/appbar_theme.dart';
import 'package:flutter/material.dart';

class EditTestPage extends StatefulWidget {
  const EditTestPage({super.key});

  @override
  State<EditTestPage> createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  TextEditingController nameController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    // Obtener el argumento pasado desde la pantalla anterior
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // Asignar el valor del argumento al controlador de texto
    nameController.text = arguments['name'];
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Name"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Ingrese la modificación de su nombre",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                //debugPrint(arguments['uid']);
                await updatePeople(arguments['uid'], nameController.text).then((
                  value,
                ) {
                  Navigator.pop(context);
                });
              },
              child: Text("Actualizar Nombre"),
            ),
          ],
        ),
      ),
    );
  }
}
