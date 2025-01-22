import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moovio/src/app/home/presentation/movie_list_screen.dart';

import 'app_route_name.dart';

class AppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: "/",
        path: AppRouterName.root,
        builder: (context, state) => MovieListScreen(),
      ),
    ],
  );
}
