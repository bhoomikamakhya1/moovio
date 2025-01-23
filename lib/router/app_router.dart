import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moovio/src/app/home/presentation/movie_list_screen.dart';
import 'package:moovio/src/app/splash/presentation/splash_screen.dart';

import 'app_route_name.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: "/",
        path: AppRouterName.root,
        builder: (context, state) => SplashScreen(),
        // Navigate to MovieListScreen after the splash screen animation
        routes: [
          GoRoute(
            name: "/main",
            path: AppRouterName.main,
            builder: (context, state) => MovieListScreen(),
          ),
        ],
      ),
    ],
  );
}
