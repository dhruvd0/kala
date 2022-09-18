import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/acquires_page/widgets/acquires_page.dart';
import 'package:kala/artist_page/bloc/kala_user_content_bloc.dart';
import 'package:kala/artist_page/widgets/artist_page.dart';
import 'package:kala/auth/widgets/auth_page.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/gallery/bloc/gallery_slide_bloc.dart';

import 'package:kala/gallery/widgets/page/gallery_page.dart';
import 'package:kala/main.dart';
import 'package:kala/startup/splash.dart';
import 'package:preload_page_view/preload_page_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  StreamSubscription? streamSubscription;

  @override
  void dispose() {
    streamSubscription?.cancel();
    super.dispose();
  }

  PreloadPageController pageController = PreloadPageController();
  List<Widget> pages = [const Splash()];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      streamSubscription =
          firebaseConfig?.auth.userChanges().listen(handleUseAuthState);
      pageController.addListener(() {
        if (pageController.hasClients) {
          if (pages[0] is AuthPage && pageController.page! <= 1) {
            setState(() {
              pages.removeAt(0);
            });
          }
        }
      });
    });
  }

  Future<void> handleUseAuthState(
    User? user,
  ) async {
    if (user == null) {
      setState(() {
        pages.add(
          AuthPage(
            pageController: pageController,
          ),
        );
      });
      setState(() {
        pages.removeAt(
          0,
        );
      });

      await pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      await authenticatePageRoutine();
    }
  }

  Future<void> authenticatePageRoutine() async {
    final galleryBloc = BlocProvider.of<GalleryBloc>(context);
    await Future.doWhile(() {
      final isDataLoaded = galleryBloc.state.contentSlideList.isNotEmpty &&
          BlocProvider.of<KalaUserContentBloc>(context).state.userContent !=
              null;
      return isDataLoaded;
    });
    if (mounted) {
      await galleryBloc.cacheContentImages(context);
    }
    setState(() {
      pages.addAll(dashboardPages);
    });
    await Future.doWhile(() {
      if (pageController.hasClients) {
        return pageController.position.maxScrollExtent > 1000;
      } else {
        return false;
      }
    });

    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() {
      pages.removeWhere((page) => page is Splash || page is AuthPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      child: PreloadPageView(
        key: const ValueKey(ScaffoldKeys.dashboard),
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        preloadPagesCount: pages.length,
        children: pages,
      ),
    );
  }

  List<Widget> get dashboardPages {
    return [
      GalleryPage(pageController),
      ArtistPage(
        controller: pageController,
      ),
      AcquiresPage(
        pageController: pageController,
      )
    ];
  }
}
