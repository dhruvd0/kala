import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/dashboard/bloc/dash_controller.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashController, DashState>(
      builder: (context, state) {
        return PageView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: state.pages.length,
          onPageChanged: (index) {
          BlocProvider.of<DashController>(context, listen: false)
              .setPageIndex(index);
        }, itemBuilder: (_, index) {
          return index > state.pages.length - 1
              ? state.pages.last
              : state.pages[index];
        });
      },
    );
  }
}
