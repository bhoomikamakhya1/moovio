// theme_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moovio/theme/theme_event.dart';
import 'package:moovio/theme/theme_state.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  // Initial state is light theme
  ThemeBloc() : super(ThemeState(ThemeModeState.light));


  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is ToggleThemeEvent) {
      // If current theme is light, switch to dark, otherwise switch to light
      if (state.themeMode == ThemeModeState.light) {
        yield ThemeState(ThemeModeState.dark);
      } else {
        yield ThemeState(ThemeModeState.light);
      }
    }
  }
}
