import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/common/utils/widgets/buttons/curved_mono_button.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton(
    this.authType, {
    Key? key,
  }) : super(key: key);

  final AuthTypes authType;

  @override
  Widget build(BuildContext context) {
    return RectMonoButton(
      height: 50.h,
      width: 1.sw / 1.8,
      text: 'Log In With ${authType.name} ',
      key: ValueKey('${authType}AuthBtn'),
      margin: EdgeInsets.symmetric(vertical: 20.h),
      onTap: () {
        BlocProvider.of<ProfileBloc>(context)
            .authenticateWithSocialAuth(authType);
      },
    );
  }
}
