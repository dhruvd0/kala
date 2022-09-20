import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyTextStyle {
  static final TextStyle bodyText1 =
      GoogleFonts.raleway(fontSize: 16.sm, color: Colors.black);
  static final TextStyle bodyText2 =
      GoogleFonts.raleway(fontSize: 12.sm, color: Colors.black);
  static final TextStyle caption = GoogleFonts.raleway(
    fontSize: kIsWeb ? 16.sm : 18.sm,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle subtitle1 = GoogleFonts.greatVibes(
    fontSize: 14.sm,
    color: Colors.black,
  );
  static final TextStyle subtitle2 = GoogleFonts.raleway(
    fontSize: 14.sm,
    color: Colors.black,
  );
}
