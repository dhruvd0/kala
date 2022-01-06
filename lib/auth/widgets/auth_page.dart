import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/auth/social_integration/auth_types.dart';
import 'package:kala/auth/widgets/auth_btn.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      body: BlocListener<KalaUserBloc, KalaUserState>(
        listener: (_, state) {
          if (state is AuthenticatedKalaUserState) {
            Navigator.of(context).pushReplacementNamed(Routes.gallery);
          }
        },
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: authPageColumChildren(context),
          ),
        ),
      ),
    );
  }

  List<Widget> authPageColumChildren(BuildContext context) {
    var columnChildren = [
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
    ];
    columnChildren.addAll(
      AuthTypes.allAuthTypes()
          .map(
            (e) => SocialAuthButton(e),
          )
          .toList(),
    );
    return columnChildren;
  }
}
