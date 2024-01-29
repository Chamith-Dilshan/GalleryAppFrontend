import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/theme/app_theme.dart';
import 'package:flutter_gallery_ui/ui/home_page.dart';
import 'package:flutter_gallery_ui/ui/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeLight.theme,
      home: const HomePage(),
    );
  }
}
