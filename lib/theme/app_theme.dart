import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';

class AppThemeLight {
  static ThemeData theme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: PaletteLightMode.whiteColor,
    colorScheme: const ColorScheme.light(
      primary: PaletteLightMode.darkBlackColor,
      onPrimary: PaletteLightMode.whiteColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: PaletteLightMode.whiteColor,
      elevation: 0,
    ),
  );
}
