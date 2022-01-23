import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/widgets/cover_widget.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({Key? key, this.userID}) : super(key: key);

  final String? userID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => KalaUserContentBloc(
        kalaUserBloc: context.read<KalaUserBloc>(),
        userID: userID,
      ),
      child: BlocBuilder<KalaUserBloc, KalaUserState>(
        key: UniqueKey(),
        builder: (context, state) {
          return OffWhiteScaffold(
            trailing: GestureDetector(
              onTap: () {
                BlocProvider.of<KalaUserBloc>(context, listen: false)
                    .toggleEditMode();
              },
              child: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
            scaffoldKey: const ValueKey(ScaffoldKeys.artistPageKey),
            enablePageNavigationArrows: true,
            centerTitle: state.kalaUser.name,
            body: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                const Flexible(child: CoverContent())
              ],
            ),
          );
        },
      ),
    );
  }
}
