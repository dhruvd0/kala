import 'package:flutter/material.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';

import 'package:kala/utils/widgets/offwhite_scaffold.dart';

class AcquiresPage extends StatelessWidget {
  const AcquiresPage();

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.acquiresPageKey),
      enablePageNavigationArrows: true,
      centerTitle: 'Acquires',
      body: const Center(),
    );
  }
}
