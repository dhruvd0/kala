import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/dashboard/bloc/dash_controller.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashController, DashState>(
      key: const ValueKey(ScaffoldKeys.dashboard),
      builder: (context, state) {
        return PageView(
          physics: const BouncingScrollPhysics(),
          controller: DashController.pageController,
          children: state.pages,
        );
      },
    );
  }
}
