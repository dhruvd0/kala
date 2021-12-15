import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/widgets/auth_btn.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100.h,
            ),
            Text(
              "K",
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(
              height: 100.h,
            ),
            const SocialAuthButton("Google"),
            const SocialAuthButton("Instagram"),
            const SocialAuthButton("Facebook"),
           
          ],
        ),
      ),
    );
  }
}
