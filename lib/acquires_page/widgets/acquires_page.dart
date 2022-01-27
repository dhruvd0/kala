import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kala/auth/bloc/kala_user_bloc.dart';
import 'package:kala/auth/models/kala_user.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/dashboard/widgets/dashboard_child_page.dart';

import 'package:kala/utils/widgets/offwhite_scaffold.dart';
import 'package:preload_page_view/preload_page_view.dart';

class AcquiresPage extends DashBoardPage {
  const AcquiresPage({required PreloadPageController pageController})
      : super(controller: pageController);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KalaUserBloc, KalaUser>(
      builder: (context, state) {
        return OffWhiteScaffold(
          scaffoldKey: const ValueKey(ScaffoldKeys.acquiresPageKey),
          enablePageNavigationArrows: true,
          controller: controller,
          centerTitle: 'Acquires',
          body: const Center(),
        );
      },
    );
  }
}
