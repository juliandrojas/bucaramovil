import 'package:bucaramovil/screens/test/posts/edit.dart';
import 'package:flutter/material.dart';
import 'package:bucaramovil/screens/test/posts/home.dart';
import 'package:bucaramovil/screens/test/posts/add.dart';
// ...otros imports...

final Map<String, WidgetBuilder> appRoutes = {
  '/test/home': (context) => const HomeTestPage(),
  '/test/add': (context) => const AddNameTestPage(),
  '/test/edit': (context) => const EditTestPage(),
  // ...otras rutas de pruebas...
};
