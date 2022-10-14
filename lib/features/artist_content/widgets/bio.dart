import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';

import 'package:kala/features/auth/bloc/kala_user_bloc.dart';

class BioWidget extends StatefulWidget {
  const BioWidget({Key? key}) : super(key: key);

  @override
  State<BioWidget> createState() => _BioWidgetState();
}

class _BioWidgetState extends State<BioWidget> {
  bool activeTextField = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, KalaUserState>(
      builder: (context, userState) {
        return userState.fetchedKalaUser.kalaUser.isEditMode
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
                    padding: activeTextField ? const EdgeInsets.all(5) : null,
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
                        hintText: firebaseConfig.remoteConfig
                            .getString(RemoteConfigKeys.addBioPlaceholder),
                        hintStyle:
                            TextThemeContext(context).bodyText1!.copyWith(
                                  fontSize: 11.sp,
                                ),
                        border: InputBorder.none,
                      ),
                      onChanged: (str) {
                        BlocProvider.of<ProfileBloc>(
                          context,
                        ).changeBio(str);
                      },
                    ),
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.only(left: 22, right: 22),
                child: AutoSizeText(
                  userState.fetchedKalaUser.kalaUser.bio,
                  style: TextThemeContext(context).bodyText1,
                ),
              );
      },
    );
  }
}
