import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/common/models/art.dart';
import 'package:kala/common/utils/helper_bloc/content_pagination/pagination_state.dart';
import 'package:kala/common/utils/widgets/buttons/curved_mono_button.dart';
import 'package:kala/common/utils/widgets/decors/text_input_decoration.dart';
import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/features/artist_page/add_new_art/bloc/new_art_bloc.dart';
import 'package:kala/features/artist_page/add_new_art/widgets/keys/add_new_content_widget_keys.dart';
import 'package:kala/features/artist_page/cubit/artist_page_cubit.dart';
import 'package:kala/features/auth/bloc/kala_user_bloc.dart';
import 'package:kala/features/gallery/art/widgets/art_image.dart';
import 'package:kala/features/gallery/bloc/gallery_slide_bloc.dart';

class AddNewArtSheet extends StatefulWidget {
  const AddNewArtSheet({Key? key}) : super(key: key);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<AddNewArtSheet> createState() => _AddNewArtSheetState();
}

class _AddNewArtSheetState extends State<AddNewArtSheet> {
  bool uploadingArt = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewArtCubit, Art>(
      builder: (context, state) {
        return OffWhiteScaffold(
          hideAppBar: true,
          scaffoldKey: const ValueKey(AddNewArtWidgetKeys.scaffoldKey),
          body: Form(
            key: AddNewArtSheet.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  firebaseConfig.remoteConfig.getString(
                    RemoteConfigKeys.clickPhotoToChangeArt,
                  ),
                  textAlign: TextAlign.center,
                  style: TextThemeContext(context).bodyText1,
                ),
                Expanded(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: (1.sh - 100) / 2),
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    child: ArtImage(
                      image: state.imageFile,
                      overrideFit: BoxFit.cover,
                    ),
                  ),
                ),
                TextFormField(
                  validator: (str) {
                    if (str == null) {
                      return 'Enter a Title';
                    }
                    if (str.isEmpty) {
                      return 'Enter a Title';
                    }
                    if (str.length > 10) {
                      return 'Title description is too long';
                    }
                    return null;
                  },
                  textAlign: TextAlign.center,
                  style: TextThemeContext(context).headline1,
                  onChanged: (str) {
                    BlocProvider.of<NewArtCubit>(context)
                        .editNewArt(ArtProps.title, str);
                  },
                  decoration: TextInputDecorations.defaultTextInputDecoration(
                    TextThemeContext(context)
                        .headline2!
                        .copyWith(fontSize: 25.sp),
                    'Add a Title',
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  padding: EdgeInsets.only(right: 20.w),
                  child: TextFormField(
                    style: TextThemeContext(context).caption,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (str) {
                      BlocProvider.of<NewArtCubit>(
                        context,
                      ).editNewArt(ArtProps.price, int.parse(str));
                    },
                    decoration: TextInputDecorations.defaultTextInputDecoration(
                      TextThemeContext(context).caption!,
                      '₹0.0',
                      prefixText: '₹',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextFormField(
                  style: TextThemeContext(context).subtitle2,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  onChanged: (str) {
                    BlocProvider.of<NewArtCubit>(context)
                        .editNewArt(ArtProps.description, str);
                  },
                  decoration: TextInputDecorations.defaultTextInputDecoration(
                    TextThemeContext(context).subtitle2!,
                    'Add a Description',
                  ),
                ),
                if (uploadingArt)
                  const CircularProgressIndicator(
                    color: Colors.black,
                  )
                else
                  RectMonoButton(
                    text: 'LETS GO',
                    onTap: () {
                      if (AddNewArtSheet.formKey.currentState?.validate() ??
                          false) {
                        setState(() {
                          uploadingArt = true;
                        });
                        BlocProvider.of<NewArtCubit>(
                          context,
                        ).addNewArt().then((value) async {
                          unawaited(
                            BlocProvider.of<GalleryBloc>(
                              context,
                            ).getArtList(),
                          );
                          await BlocProvider.of<ArtistContentCubit>(
                            context,
                          ).getUserArt(
                            100,
                            collectionSegment: CollectionSegment.previous,
                          );
                          if (mounted) {
                            BlocProvider.of<ProfileBloc>(
                              context,
                            ).toggleEditMode();
                          }

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
