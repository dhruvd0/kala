import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/dashboard/bloc/dash_controller.dart';
import 'package:kala/dashboard/bloc/dash_state.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => KalaUserContentBloc(
        kalaUserBloc: context.read<KalaUserBloc>(),
      ),
      child: PageView.builder(
        key: const ValueKey(ScaffoldKeys.dashboard),
        physics: const BouncingScrollPhysics(),
      
        controller: DashController.pageController,
        itemBuilder: (_, index) {
          return DashState.pages[index];
        },
        itemCount: DashState.pages.length,
      ),
    );
  }
}
