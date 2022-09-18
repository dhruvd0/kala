import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/add_new_content/bloc/add_new_content_bloc.dart';
import 'package:kala/artist_page/add_new_content/widgets/add_new_content_sheet.dart';
import 'package:kala/artist_page/add_new_content/widgets/keys/add_new_content_widget_keys.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/config/nav/route_names.dart';
import 'package:kala/gallery/content/models/content.dart';
import 'package:kala/utils/io/scan_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EmptyContentCard extends StatelessWidget {
  const EmptyContentCard({
    Key? key,
  }) : super(key: key);
  double gridElementSize() => (1.sw - 40.w) / 3;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      constraints: BoxConstraints(
        minHeight: gridElementSize(),
        maxHeight: gridElementSize(),
      ),
      decoration: BoxDecoration(border: Border.all(width: 0.5)),
      child: BlocBuilder<AddNewContentCubit, Content>(
        key: const ValueKey(AddNewContentWidgetKeys.emptyContent),
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              final bloc = BlocProvider.of<AddNewContentCubit>(
                context,
              );
              scanImage(context).then(
                (file) {
                  if (file != null) {
                    bloc.editNewContent(ContentProps.image, file).then(
                          (value) => showCupertinoModalBottomSheet(
                            context: context,
                            expand: true,
                            isDismissible: true,
                            builder: (context) => BlocProvider.value(
                              value: bloc,
                              child: const AddNewContentSheet(),
                            ),
                          ).then((value) {
                            final isInEditMode =
                                !BlocProvider.of<KalaUserContentBloc>(
                              context,
                            ).state.isEditMode;
                            if (!isInEditMode) {
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.dashboard,
                              );
                            }
                          }),
                        );
                  }
                },
              );
            },
            child: SizedBox(
              height: 70.h,
              child: const Center(
                child: Icon(FluentSystemIcons.ic_fluent_add_regular),
              ),
            ),
          );
        },
      ),
    );
  }
}
