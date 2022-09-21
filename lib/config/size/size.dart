import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/size/constants.dart';

class SizeUtils {
  static bool isMobileSize() {
    if (!kIsWeb) {
      return true;
    }
    return 1.sw <= SizeConstants.maxMobileWidth;
  }
}
