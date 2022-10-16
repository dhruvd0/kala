import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';
import 'package:kala/common/utils/widgets/routines.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/features/auth/bloc/auth_bloc.dart';
import 'package:kala/features/auth/bloc/auth_state.dart';
import 'package:kala/features/auth/repositories/social_integration/social_integration.dart';
import 'package:kala/features/auth/widgets/auth_btn.dart';

class AuthPage extends RoutinesWidget {
  const AuthPage({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.authPageKey),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthenticatedState) {
            postAuthenticationRoutine(context);
          }
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
      ...AuthTypes.values
          .map(
            SocialAuthButton.new,
          )
          .toList(),
    ];
    return columnChildren;
  }
}
