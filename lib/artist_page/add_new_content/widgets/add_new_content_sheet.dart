import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/config/remote_config_data.dart';
import 'package:kala/config/theme/theme.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/gallery/content/widgets/content_image.dart';
import 'package:kala/main.dart';
import 'package:kala/utils/widgets/buttons/curved_mono_button.dart';
import 'package:kala/utils/widgets/decors/text_input_decoration.dart';

class AddNewContentSheet extends StatelessWidget {
  AddNewContentSheet({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserContentBloc, KalaUserContentState>(
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                firebaseConfig?.remoteConfig.getString(
                      RemoteConfigKeys.clickPhotoToChangeContent,
                    ) ??
                    '',
                style: TextThemeContext(context).bodyText1,
              ),
              SizedBox(
                height: 40.h,
              ),
              ContentImage(image: state.newContent.imageFile),
              SizedBox(
                height: 40.h,
              ),
              TextFormField(
                key: formKey,
                validator: (str) {
                  if (str == null) {
                    return 'Enter a Title';
                  }
                  if (str.isEmpty) {
                    return 'Enter a Title';
                  }
                   if (str.length>10) {
                    return 'Title description is too long';
                  }
                },
                style: TextThemeContext(context).headline1,
                onChanged: (str) {
                  BlocProvider.of<KalaUserContentBloc>(context, listen: false)
                      .editNewContent(ContentProps.title, str);
                },
                decoration: TextInputDecorations.defaultTextInputDecoration(
                  TextThemeContext(context).headline2!,
                  'Add a Title',
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              TextFormField(
                key: formKey,
                style: TextThemeContext(context).caption,
                keyboardType: TextInputType.number,
                
                onChanged: (str) {
                  BlocProvider.of<KalaUserContentBloc>(context, listen: false)
                      .editNewContent(ContentProps.price, str);
                },
                decoration: TextInputDecorations.defaultTextInputDecoration(
                  TextThemeContext(context).caption!,
                  '0.0',
                  prefixText: '₹',
                ),
              ),
              SizedBox(
                height: 70.h,
              ),
              TextFormField(
                style: TextThemeContext(context).subtitle2,
                maxLines: 5,
                onChanged: (str) {
                  BlocProvider.of<KalaUserContentBloc>(context, listen: false)
                      .editNewContent(ContentProps.description, str);
                },
                decoration: TextInputDecorations.defaultTextInputDecoration(
                  TextThemeContext(context).subtitle2!,
                  'Add a Description',
                ),
              ),
              SizedBox(
                height: 90.h,
              ),
              RectMonoButton(
                text: 'LETS GO',
                onTap: () {
                  if (formKey.currentState?.validate() ?? false) {
                    BlocProvider.of<KalaUserContentBloc>(
                      context,
                      listen: false,
                    ).addNewContent().then((value) => Navigator.pop(context));
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }
}
