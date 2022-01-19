import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/bloc/kala_user_state.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class AcquiresPage extends StatelessWidget {
  const AcquiresPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUserState>(
      builder: (context, state) {
        return OffWhiteScaffold(
          scaffoldKey: ValueKey("AcquiresPage"),
          enablePageNavigationArrows: true,
          centerTitle: "Acquires",
          body: const Center(),
        );
      },
    );
  }
}
