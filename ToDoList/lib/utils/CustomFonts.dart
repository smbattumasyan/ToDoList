import 'package:flutter/material.dart';

// Custom Fonts

// /**
//     Thin = 100
//     extralight = 200
//     light = 300
//     regular = 400
//     medium  = 500
//     semibold = 600
//     bold = 700
//     extrabold = 800
//     black  = 900
//  */

class CustomFonts {
  static TextStyle openSans(OpenSansType type, {double fontSize = 14}) {
    return _customFont('OpenSans${type.value}', fontSize);
  }

  static TextStyle _customFont(String name, double fontSize) {
    return TextStyle(
      fontFamily: name,
      fontSize: fontSize,
    );
  }
}

enum OpenSansType {
  bold('-Bold'),
  boldItalic('-BoldItalic'),
  extraBold('-ExtraBold'),
  extraBoldItalic('-ExtraBoldItalic'),
  italic('-Italic'),
  light('-Light'),
  lightItalic('-LightItalic'),
  regular(''),
  semiBold('-Semibold'),
  semiBoldItalic('-SemiboldItalic');

  final String value;
  const OpenSansType(this.value);
}


