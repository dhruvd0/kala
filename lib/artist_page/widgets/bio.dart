import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_state.dart';

class BioWidget extends StatelessWidget {
  const BioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserContentBloc, KalaUserContentState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(left: 22, right: 22),
        );
      },
    );
  }
}
