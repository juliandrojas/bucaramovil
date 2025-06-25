import 'package:bucaramovil/screens/posts/location_post.dart';
import 'package:bucaramovil/screens/posts/post_details.dart';
import 'package:bucaramovil/screens/posts/user/user_posts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'environment.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// Importa los archivos de rutas de ambos entornos
// Importa los logins y homes de ambos entornos
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/posts/comments/comments.dart';
import 'screens/posts/create_posts.dart';
import 'screens/posts/comments/create_comments.dart'; // Importa CreateCommentPage
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
        '/login': (context) => const LoginPageDev(),
        '/home': (context) => const HomeLayout(),
        '/create_post': (context) => const CreatePostPage(),
        '/user_posts': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as Map<String, String>;
          return UserPostsPage(
            userId: args['userId']!,
            userName: args['userName']!,
          );
        },
        '/comments': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          final postID = args['postId'] as String;
          return CommentsPage(postId: postID);
        },
        '/create_comment': (context) {
          // Extraer el postId del mapa de argumentos
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          final postID = args['postId'] as String;

          return CreateCommentPage(postId: postID);
        },
        '/post_details': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          return PostDetailsPage(post: args);
        },
        '/location_posts': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>;
          return LocationPostsPage(
            latitude: args['latitude'],
            longitude: args['longitude'],
            posts: args['posts'],
          );
        },
      },
    );
  }
}
