import 'package:flutter/material.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class NavWidgetKeys {
  static String pageNavArrowKey(
    String scaffoldKey,
    NavArrowType navArrowType,
  ) {
    return ("${scaffoldKey.toString()}-${navArrowType.name}-arrow");
  }
}
