import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/features/artist_profile/cubit/artist_profile/kala_user_bloc.dart';
import 'package:kala/features/auth/bloc/auth_bloc.dart';
import 'package:kala/features/auth/bloc/auth_state.dart';

class BioWidget extends StatefulWidget {
  const BioWidget({Key? key}) : super(key: key);

  @override
  State<BioWidget> createState() => _BioWidgetState();
}

class _BioWidgetState extends State<BioWidget> {
  bool activeTextField = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<ProfileBloc, KalaUserState>(
          builder: (context, userState) {
            return authState is AuthenticatedState &&
                    authState.user.uid != userState.fetchedKalaUser.kalaUser.uid
                ? _BioText(bio: userState.fetchedKalaUser.kalaUser.bio)
                : userState.fetchedKalaUser.kalaUser.isEditMode
                    ? AnimatedContainer(
                        duration: const Duration(seconds: 10),
                        curve: Curves.ease,
                        height: activeTextField ? null : 80.h,
                        margin: EdgeInsets.symmetric(horizontal: 40.w),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Center(
                          child: Container(
                            padding: activeTextField
                                ? const EdgeInsets.all(5)
                                : null,
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  activeTextField = true;
                                });
                              },
                              onEditingComplete: () {
                                setState(() {
                                  activeTextField = false;
                                });
                              },
                              textAlign: TextAlign.center,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: firebaseConfig.remoteConfig.getString(
                                  RemoteConfigKeys.addBioPlaceholder,
                                ),
                                hintStyle: TextThemeContext(context)
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 11.sp,
                                    ),
                                border: InputBorder.none,
                              ),
                              onChanged: (str) {
                                BlocProvider.of<AuthenticatedProfileBloc>(
                                  context,
                                ).changeBio(str);
                              },
                            ),
                          ),
                        ),
                      )
                    : _BioText(
                        bio: userState.fetchedKalaUser.kalaUser.bio,
                      );
          },
        );
      },
    );
  }
}

class _BioText extends StatelessWidget {
  const _BioText({
    Key? key,
    required this.bio,
  }) : super(key: key);
  final String bio;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.w),
      child: AutoSizeText(
        bio,
        style: TextThemeContext(context).bodyText1,
      ),
    );
  }
}
