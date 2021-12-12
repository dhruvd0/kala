import 'package:flutter/material.dart';
import 'package:kala/config/colors/basic_colors.dart';

class OffWhiteScaffold extends StatelessWidget {
  const OffWhiteScaffold({Key? key, required this.body}) : super(key: key);
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColors.backgroundOffWhite,
      body: body,
    );
  }
}
