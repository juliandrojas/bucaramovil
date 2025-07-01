import 'app_routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'environment.dart';

void main() async {
  // Cargamos las variables de entorno desde el archivo .env
  // await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Selecciona rutas y pantallas según el entorno
    final isDev = currentEnvironment == AppEnvironment.dev;
    final initialRoute = isDev ? '/login' : '/test/login';

    return MaterialApp(
      title: 'BucaraMóvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      routes: appRoutes,
    );
  }
}
