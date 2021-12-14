import 'package:flutter/material.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/utils/widgets/app_bar/back_app_bar.dart';

class OffWhiteScaffold extends StatelessWidget {
  const OffWhiteScaffold({
    Key? key,
    required this.body,
    this.centerTitle,
  }) : super(key: key);
  final Widget body;
  final String? centerTitle;
  PreferredSizeWidget? defaultAppBar() {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColors.backgroundOffWhite,
      body: body,
    
      appBar: defaultAppBar(),
    );
  }
}

class OffWhiteScaffoldWithBackAppBar extends OffWhiteScaffold
    with BackAppBarMixin {
  OffWhiteScaffoldWithBackAppBar({
    Key? key,
    required Widget body,
    title,
  }) : super(key: key, body: body, centerTitle: title);
}
