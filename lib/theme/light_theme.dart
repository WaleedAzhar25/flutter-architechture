import 'package:flutter/material.dart';
import 'package:sixam_mart/util/colors.dart';

ThemeData light({Color color = const Color(0xFFDadada)}) => ThemeData(
// ThemeData light({Color color = const Color(0xFF809690)}) => ThemeData(
// ThemeData light({Color color = const Color(0xFF039D55)}) => ThemeData(
      fontFamily: 'Roboto',
      primaryColor: color,
      secondaryHeaderColor: Color(0xFF1ED7AA),
      disabledColor: Color(0xFFBABFC4),

      backgroundColor: ColorResources.white12,
      // backgroundColor: Color(0xFFF3F3F3),
      errorColor: Color(0xFFE84D4F),
      brightness: Brightness.light,
      hintColor: Color(0xFF9F9F9F),
      // cardColor: Colors.white,
      cardColor: ColorResources.white12,
      colorScheme: ColorScheme.light(primary: color, secondary: color),
      textButtonTheme:
          TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
    );
