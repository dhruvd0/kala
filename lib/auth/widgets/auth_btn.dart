import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/utils/widgets/buttons/curved_mono_button.dart';
class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton(
    this.authType, {
    Key? key,
  }) : super(key: key);

  final String authType;

  @override
  Widget build(BuildContext context) {
    return RectMonoButton(
      height: 50.h,
      width: 1.sw / 1.8,
      text: "Log In With $authType ",
      key: Key("${authType}AuthBtn"),
      margin: EdgeInsets.symmetric(vertical: 20.h),
      onTap: () {
        BlocProvider.of<KalaUserBloc>(context)
            .authenticateWithSocialAuth(
              authType,
            )
            .then(
              (value) => BlocProvider.of<KalaUserBloc>(context)
                  .updateKalaUserToFirestore(),
            );
      },
    );
  }
}
