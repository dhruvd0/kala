import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kala/config/widget_keys/scaffold_keys.dart';
import 'package:kala/utils/widgets/offwhite_scaffold.dart';

/// The first widget to display for Kala App
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const LogoSplash();
  }
}

class LogoSplash extends StatelessWidget {
  const LogoSplash({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OffWhiteScaffold(
      scaffoldKey: const ValueKey(ScaffoldKeys.splashKey),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Positioned(
              top: 280.h,
              child: Text(
                'Kala',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(fontSize: 64.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
