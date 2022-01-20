import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUserState>(
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
          body: const Center(),
        );
      },
    );
  }
}
