import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/colors/basic_colors.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/config/widget_keys/nav_keys.dart';
import 'package:preload_page_view/preload_page_view.dart';

class OffWhiteScaffold extends StatelessWidget {
  OffWhiteScaffold({
    required this.scaffoldKey,
    required this.body,
    this.centerTitle,
    this.hideAppBar,
    this.enableBackArrow,
    this.onBack,
    this.enablePageNavigationArrows,
    this.trailing,
    this.controller,
  }) : super(key: scaffoldKey) {
    if (enableBackArrow ?? false) {
      assert(onBack != null);
    }
    if (onBack != null) {
      assert(enableBackArrow ?? false);
    }
    if (enablePageNavigationArrows ?? false) {
      assert(controller != null);
    }
  }

  final Widget body;
  final String? centerTitle;
  final bool? enableBackArrow;
  final bool? enablePageNavigationArrows;
  final VoidCallback? onBack;
  final ValueKey<String> scaffoldKey;
  final Widget? trailing;
  final bool? hideAppBar;
  final PreloadPageController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BasicColors.backgroundOffWhite,
      body: SizedBox(height: 1.sh, child: body),
      key: scaffoldKey,
      appBar: hideAppBar ?? false
          ? null
          : PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                margin: EdgeInsets.only(top: 20.h),
                child: AppBar(
                  elevation: 0,
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
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (enablePageNavigationArrows ?? false)
                              _PageNavArrow(
                                navArrowType: NavArrowType.left,
                                pageKey: scaffoldKey,
                                controller: controller!,
                              )
                            else
                              Container(),
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
                            if (enablePageNavigationArrows ?? false)
                              _PageNavArrow(
                                navArrowType: NavArrowType.right,
                                pageKey: scaffoldKey,
                                controller: controller!,
                              )
                            else
                              Container(),
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
    required this.navArrowType,
    required this.pageKey,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final NavArrowType navArrowType;
  final ValueKey pageKey;
  final PreloadPageController controller;

  // bool isPageEndOfPages() {
  //   return state.pageIndex == 0 && navArrowType == NavArrowType.left ||
  //       state.pageIndex == 3 - 1 && navArrowType == NavArrowType.right;
  // }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        void Function() onTap;
        IconData icon;
        switch (navArrowType) {
          case NavArrowType.left:
            onTap = () {
              controller.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            };
            icon = Icons.arrow_back_ios_new;
            break;
          case NavArrowType.right:
            onTap = () {
              controller.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            };
            icon = Icons.arrow_forward_ios;
            break;
        }
        return GestureDetector(
          onTap: () {
            return onTap();
          },
          key: ValueKey(
            NavWidgetKeys.pageNavArrowKey(
              pageKey.value.toString(),
              navArrowType,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 14,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
