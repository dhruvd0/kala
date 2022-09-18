import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';

import 'package:kala/auth/social_integration/auth_types.dart';
import 'package:kala/auth/widgets/auth_btn.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/dashboard/widgets/dashboard_child_page.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';
import 'package:preload_page_view/preload_page_view.dart';

class AuthPage extends DashBoardPage {
  const AuthPage({Key? key, required PreloadPageController pageController})
      : super(key: key, controller: pageController);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.authPageKey),
      body: BlocListener<KalaUserBloc, KalaUser>(
        listener: (_, state) {
          // if (state.kalaUserState == KalaUserState.authenticated) {
          //   controller.nextPage(
          //     duration: Duration(seconds: 200),
          //     curve: Curves.easeIn,
          //   );
          // }
        },
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Column(
            children: authPageColumChildren(context),
          ),
        ),
      ),
    );
  }

  List<Widget> authPageColumChildren(BuildContext context) {
    final columnChildren = [
      SizedBox(
        height: 100.h,
      ),
      Text(
        'K',
        style: Theme.of(context).textTheme.headline1,
      ),
      SizedBox(
        height: 100.h,
      ),
      ...AuthTypes.allAuthTypes()
          .map(
            SocialAuthButton.new,
          )
          .toList(),
    ];
    return columnChildren;
  }
}
