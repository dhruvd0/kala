import 'package:flutter/material.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/config/theme/text_styles/button.dart';
import 'package:kala/config/theme/text_styles/heading.dart';


final ThemeData lightTheme = ThemeData(
  backgroundColor: BasicColors.backgroundOffWhite,
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: TextTheme(
    headline1: HeadingStyles.heading1,
    button: ButtonTextStyle.button1
  ),
);
final ThemeData darkTheme = lightTheme.copyWith();
