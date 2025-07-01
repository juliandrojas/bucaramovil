import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/posts/user/user_posts.dart';
import 'screens/posts/comments/comments.dart';
import 'screens/posts/create_posts.dart';
import 'screens/posts/comments/create_comments.dart';
import 'screens/posts/post_details.dart';
import 'screens/posts/location_post.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/login': (context) => const LoginPageDev(),
  '/home': (context) => const HomeLayout(),
  '/user_posts': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    return UserPostsPage(userId: args['userId']!, userName: args['userName']!);
  },
  '/comments': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final postID = args['postId'] as String;
    return CommentsPage(postId: postID);
  },
  '/create_comment': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final postID = args['postId'] as String;
    return CreateCommentPage(postId: postID);
  },
  '/post_details': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return PostDetailsPage(post: args);
  },
  '/location_posts': (context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return LocationPostsPage(
      latitude: args['latitude'],
      longitude: args['longitude'],
    );
  },
  '/create_post': (context) => const CreatePostPage(),
};
