import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'environment.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importa los archivos de rutas de ambos entornos
import 'routes/routes_dev.dart' as dev_routes;
import 'routes/routes_test.dart' as test_routes;
// Importa los logins y homes de ambos entornos
import 'screens/dev/login.dart' as dev_login;
import 'screens/dev/home.dart' as dev_home;
import 'screens/test/login.dart' as test_login;
import 'screens/test/home.dart' as test_home;

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
    final routes = isDev ? dev_routes.appRoutes : test_routes.appRoutes;
    final initialRoute = isDev ? '/login' : '/test/login';

    return MaterialApp(
      title: 'BucaraMóvil',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: initialRoute,
      routes: {
        // Login y Home para cada entorno
        if (isDev) '/login': (context) => const dev_login.LoginPageDev(),
        if (!isDev)
          '/test/login': (context) => const test_login.LoginPageTest(),
        if (isDev) '/home': (context) => const dev_home.HomePageDev(),
        if (!isDev) '/test/home': (context) => const test_home.HomePageTest(),
        // Rutas adicionales del entorno seleccionado
        ...routes,
      },
    );
  }
}
