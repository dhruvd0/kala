import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';
import 'package:kala/gallery/widgets/gallery_view/gallery_scroll.dart';

class GalleryGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 26.w),
      width: 1.sw,
      child: BlocBuilder<KalaUserContentBloc, KalaUserContentState>(
        builder: (context, state) {
          if (state.userContent == null) {
            return Container();
          }
          if (state.userContent?.isEmpty ?? false) {
            return Container();
          }

          const cellCount = 3;
          return GridView.count(
            crossAxisCount: cellCount,
            shrinkWrap: true,
            crossAxisSpacing: 30.w,
            children: state.userContent!
                .map(
                  (content) => ContentBlocProvider(content: content),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
