// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:kala/config/theme/text_styles/body.dart';
import 'package:kala/config/theme/text_styles/button.dart';
import 'package:kala/config/theme/text_styles/heading.dart';

final ThemeData lightTheme = ThemeData(
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: TextTheme(
    headline1: HeadingStyles.heading1,
    button: ButtonTextStyle.button1,
    headline2: HeadingStyles.heading2,
    headline3: HeadingStyles.heading3,
    bodyText1: BodyTextStyle.bodyText1,
    bodyText2: BodyTextStyle.bodyText2,
    caption: BodyTextStyle.caption,
    subtitle1: BodyTextStyle.subtitle1,
    subtitle2: BodyTextStyle.subtitle2,
  ),
);
final ThemeData darkTheme = lightTheme.copyWith();
TextTheme TextThemeContext(BuildContext context) => Theme.of(context).textTheme;
