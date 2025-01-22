import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moovio/router/app_router.dart';
import 'package:moovio/theme/theme_state.dart';
import 'theme/theme_bloc.dart';  // Assuming you've created the ThemeCubit

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),  // Provide the ThemeCubit to the widget tree
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final isDarkMode = themeState == ThemeModeState.dark;
          final light = ThemeData.light();  // Default light theme
          final dark = ThemeData.dark();   // Default dark theme

          return MaterialApp.router(
            routerConfig: AppRouter().router,  // Assuming you have a router setup
            debugShowCheckedModeBanner: false,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Switch theme based on state
            theme: light.copyWith(
              scaffoldBackgroundColor: light.scaffoldBackgroundColor,
            ),
            darkTheme: dark.copyWith(
              scaffoldBackgroundColor: dark.scaffoldBackgroundColor,
            ),
          );
        },
      ),
    );
  }
}
