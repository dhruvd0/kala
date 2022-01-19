import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/config/widget_keys/nav_keys.dart';
import 'package:kala/dashboard/bloc/dash_controller.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';

class OffWhiteScaffold extends StatelessWidget {
  OffWhiteScaffold({
    required this.scaffoldKey,
    required this.body,
    this.centerTitle,
    this.enableBackArrow,
    this.onBack,
    this.enablePageNavigationArrows,
    this.trailing,
  }) : super(key: scaffoldKey) {
    if (enableBackArrow == true) {
      assert(onBack != null);
    }
    if (onBack != null) {
      assert(enableBackArrow == true);
    }
  }

  final ValueKey<String> scaffoldKey;
  final Widget body;
  final String? centerTitle;
  final bool? enableBackArrow;
  final VoidCallback? onBack;
  final bool? enablePageNavigationArrows;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColors.backgroundOffWhite,
      body: body,
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          elevation: 0,
          shadowColor: null,
          backgroundColor: BasicColors.backgroundOffWhite,
          actions: trailing == null
              ? null
              : [
                  trailing!,
                  SizedBox(
                    width: 10.w,
                  )
                ],
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
              : Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      enablePageNavigationArrows ?? false
                          ? _PageNavArrow(
                              navArrowType: NavArrowType.left,
                              pageKey: scaffoldKey,
                            )
                          : Container(),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Title(
                          color: Colors.black,
                          child: Text(
                            centerTitle.toString(),
                            style: TextThemeContext(context).headline1,
                          ),
                        ),
                      ),
                      enablePageNavigationArrows ?? false
                          ? _PageNavArrow(
                              navArrowType: NavArrowType.right,
                              pageKey: scaffoldKey,
                            )
                          : Container(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

enum NavArrowType { left, right }

class _PageNavArrow extends StatelessWidget {
  const _PageNavArrow({
    Key? key,
    required this.navArrowType,
    required this.pageKey,
  }) : super(key: key);
  final NavArrowType navArrowType;
  final ValueKey pageKey;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        DashController dashController =
            BlocProvider.of<DashController>(context, listen: false);
        void Function() onTap;
        IconData icon;
        switch (navArrowType) {
          case NavArrowType.left:
            onTap = () {
              dashController.previousPage();
            };
            icon = Icons.arrow_back_ios_new;
            break;
          case NavArrowType.right:
            onTap = () {
              dashController.nextPage();
            };
            icon = Icons.arrow_forward_ios;
            break;
        }
        return BlocBuilder<DashController, DashState>(
          builder: (context, state) {
            return isPageEndOfPages(state)
                ? Container()
                : GestureDetector(
                    onTap: onTap,
                    key: ValueKey(NavWidgetKeys.pageNavArrowKey(
                      pageKey.value,
                      navArrowType,
                    )),
                    child: Icon(
                      icon,
                      size: 14,
                      color: Colors.black,
                    ),
                  );
          },
        );
      },
    );
  }

  bool isPageEndOfPages(DashState state) {
    return state.pageIndex == 0 && navArrowType == NavArrowType.left ||
        state.pageIndex == state.pages.length - 1 &&
            navArrowType == NavArrowType.right;
  }
}
