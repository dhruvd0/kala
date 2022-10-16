import 'package:flutter/material.dart';
import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';

class AcquiresPage extends StatelessWidget {
  const AcquiresPage({Key? key}) : super(key: key);

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
