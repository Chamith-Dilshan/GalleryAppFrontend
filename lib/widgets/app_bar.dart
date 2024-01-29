import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';

class UIConstants  {
  static AppBar appBar({
    required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required bool titleCenter,
    }){

    return AppBar(
      title: Text(title),
      titleTextStyle: TextStyle(
        color: PaletteLightMode.darkBlackColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      centerTitle: titleCenter,
      backgroundColor: PaletteLightMode.whiteColor,
    );
  }
}