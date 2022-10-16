import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/config/dependencies.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/features/acquires_page/acquires_page.dart';
import 'package:kala/features/artist_profile/widgets/artist_page.dart';
import 'package:kala/features/dashboard/bloc/dashboard_page_bloc.dart';
import 'package:kala/features/gallery/widgets/page/gallery_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => DashboardPageBloc(),
      child: BlocListener<DashboardPageBloc, DashboardPageState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case NextPageState:
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );

              break;
            case PreviousPageState:
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );

              break;

            default:
          }
        },
        child: PageView(
          key: const ValueKey(ScaffoldKeys.dashboard),
          physics: const BouncingScrollPhysics(),
          controller: pageController,
          children: [
            const GalleryPage(),
            ArtistPage(
              artistID: firebaseConfig.auth.currentUser!.uid,
            ),
            const AcquiresPage()
          ],
        ),
      ),
    );
  }
}
