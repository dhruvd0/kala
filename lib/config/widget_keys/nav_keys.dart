import 'package:kala/common/utils/widgets/offwhite_scaffold.dart';

class NavWidgetKeys {
  static String pageNavArrowKey(
    String scaffoldKey,
    NavArrowType navArrowType,
  ) {
    return '$scaffoldKey-${navArrowType.name}-arrow';
  }
}
