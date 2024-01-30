import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UIConstants  {
  static AppBar appBar({
    required String title,
    required double fontSize,
    required FontWeight fontWeight,
    required bool titleCenter,
    required String backIcon,
    required VoidCallback onBackIconButtonpressed,
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
      actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              backIcon,
              colorFilter:const ColorFilter.mode(
                PaletteLightMode.darkBlackColor, 
                BlendMode.srcIn,
              ),
              width:40,
              height:40,
            ),
            tooltip: 'Menu',
            onPressed:onBackIconButtonpressed,
          ),
        ],
    );
  }
}