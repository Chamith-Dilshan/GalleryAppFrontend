import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String lable;
  final double buttonWidth;
  final double buttonHeight;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontweight;
  final double fontsize;

  const Button({super.key,
    required this.buttonWidth,
    required this.buttonHeight,
    required this.onPressed,
    required this.lable,
    required this.backgroundColor,
    required this.textColor,
    required this.fontsize,
    required this.fontweight,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(buttonWidth,buttonHeight),
      ), 
      child: Text(lable,style: TextStyle(color: textColor, fontSize: fontsize,fontWeight: fontweight),),
    );
  }
}

