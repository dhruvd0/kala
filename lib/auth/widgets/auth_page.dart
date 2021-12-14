import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/utils/widgets/buttons/curved_mono_button.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Text(
            "K",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 30.h,
          ),
          CurvedMonoButton(
            height: 40.h,
            width: 1.sw / 3,
            text: "Log In With Google",
            onTap: () {
              BlocProvider.of<KalaUserBloc>(context).authenticateWithSocialAuth(
                AuthType.google,
              );
            },
          )
        ],
      ),
    );
  }
}
