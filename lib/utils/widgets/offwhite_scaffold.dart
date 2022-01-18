import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/config/theme/theme.dart';

class OffWhiteScaffold extends StatelessWidget {
  OffWhiteScaffold({
    Key? key,
    required this.body,
    this.centerTitle,
    this.enableBackArrow,
    this.onBack,
    this.trailing,
  }) : super(key: key) {
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
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:BasicColors.backgroundOffWhite,
      body: body,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          elevation: 0,
          shadowColor: null,
          
          backgroundColor:BasicColors.backgroundOffWhite,
          actions: trailing==null?null:[trailing!,SizedBox(width: 10.w,)],
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
      ),
    );
  }
}
