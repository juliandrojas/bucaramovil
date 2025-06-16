import 'package:flutter/material.dart';
import 'package:bucaramovil/screens/dev/posts/home_posts.dart';
import 'package:bucaramovil/screens/dev/posts/create.dart';
import 'package:bucaramovil/screens/dev/posts/post_details.dart';
// ...otros imports de producción...

final Map<String, WidgetBuilder> appRoutes = {
  '/posts/home': (context) => HomePostPage(),
  '/posts/add': (context) => const CreatePostPage(),
  '/post/details': (context) {
    return Builder(
      builder: (context) {
        final arguments = ModalRoute.of(context)?.settings.arguments;
        return PostDetailsPage(post: arguments as Map<String, dynamic>);
      },
    );
  },

  // ...otras rutas de producción...
};
