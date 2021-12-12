import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class BackAppBar extends StatelessWidget with PreferredSizeWidget {
  BackAppBar({Key? key, this.centerTitle}) : super(key: key);
  final String? centerTitle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading:  Icon(
        Icons.arrow_back_ios_new,
        color: Theme.of(context).iconTheme.color,
      ),
      centerTitle: true,
      title: centerTitle == null
          ? null
          : Title(
              color: Colors.black,
              child: Text(
                centerTitle.toString(),
              ),
            ),
    );
  }

  @override
  Size get preferredSize => Size(1.sw, 40.h);
}

mixin BackAppBarMixin on OffWhiteScaffold {
  @override
  PreferredSizeWidget? defaultAppBar([String? title]) {
    return BackAppBar(
      centerTitle: title,
    );
  }
}
