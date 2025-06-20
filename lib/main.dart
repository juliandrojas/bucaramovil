import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'environment.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importa los archivos de rutas de ambos entornos
// Importa los logins y homes de ambos entornos
import 'screens/login.dart' as dev_login;
import 'screens/home.dart' as dev_home;
import 'screens/comments.dart' as dev_comments;
/*import 'screens/test/login.dart' as test_login;
import 'screens/test/home.dart' as test_home;*/

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
      routes: {
        '/login': (context) => const dev_login.LoginPageDev(),
        '/home': (context) => const dev_home.HomePageDev(),
        '/comments': (context) => const dev_comments.CommentsScreen(),
      },
    );
  }
}
