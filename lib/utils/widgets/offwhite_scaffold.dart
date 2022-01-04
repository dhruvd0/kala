import 'package:flutter/material.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/config/theme/theme.dart';

class OffWhiteScaffold extends StatelessWidget {
  OffWhiteScaffold(
      {Key? key,
      required this.body,
      this.centerTitle,
      this.enableBackArrow,
      this.onBack})
      : super(key: key) {
    if (enableBackArrow == true) {
      assert(onBack != null);
    }
    if (onBack != null) {
      assert(enableBackArrow == true);
    }
  }
  final Widget body;
  final String? centerTitle;
  final bool? enableBackArrow;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColors.backgroundOffWhite,
      body: body,
      appBar: AppBar(
        elevation: 0,
        shadowColor: null,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: enableBackArrow == null
            ? null
            : enableBackArrow ?? false
                ? GestureDetector(
                    onTap: onBack,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )
                : null,
        centerTitle: true,
        title: centerTitle == null
            ? null
            : Title(
                color: Colors.black,
                child: Text(
                  centerTitle.toString(),
                  style: TextThemeContext(context).headline1,
                ),
              ),
      ),
    );
  }
}
