import 'package:kala/config/dependencies.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Env {
  static String getEnvironmentTag() => isProduction() ? '_prod' : '_dev';
  static bool isProduction() {
    return !getIt.get<PackageInfo>().version.contains('dev');
  }
}
