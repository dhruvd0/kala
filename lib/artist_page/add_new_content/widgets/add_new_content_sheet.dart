import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/add_new_content/bloc/add_new_content_bloc.dart';
import 'package:kala/artist_page/add_new_content/widgets/keys/add_new_content_widget_keys.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/widgets/buttons/curved_mono_button.dart';
import 'package:kala/utils/widgets/decors/text_input_decoration.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class AddNewContentSheet extends StatelessWidget {
  const AddNewContentSheet({Key? key}) : super(key: key);

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewContentCubit, Content>(
      builder: (context, state) {
        return OffWhiteScaffold(
          hideAppBar: true,
          scaffoldKey: const ValueKey(AddNewContentWidgetKeys.scaffoldKey),
          body: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  firebaseConfig?.remoteConfig.getString(
                        RemoteConfigKeys.clickPhotoToChangeContent,
                      ) ??
                      '',
                  textAlign: TextAlign.center,
                  style: TextThemeContext(context).bodyText1,
                ),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: (1.sh - 200) / 2),
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
                    child: ContentImage(image: state.imageFile),
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
                  },
                  textAlign: TextAlign.center,
                  style: TextThemeContext(context).headline1,
                  onChanged: (str) {
                    BlocProvider.of<AddNewContentCubit>(context, listen: false)
                        .editNewContent(ContentProps.title, str);
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
                      BlocProvider.of<AddNewContentCubit>(
                        context,
                        listen: false,
                      ).editNewContent(ContentProps.price, int.parse(str));
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
                    BlocProvider.of<AddNewContentCubit>(context, listen: false)
                        .editNewContent(ContentProps.description, str);
                  },
                  decoration: TextInputDecorations.defaultTextInputDecoration(
                    TextThemeContext(context).subtitle2!,
                    'Add a Description',
                  ),
                ),
                RectMonoButton(
                  text: 'LETS GO',
                  key: const ValueKey(
                    AddNewContentWidgetKeys.submitContentButton,
                  ),
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      BlocProvider.of<AddNewContentCubit>(
                        context,
                        listen: false,
                      ).addNewContent().then((value) => Navigator.pop(context));
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
