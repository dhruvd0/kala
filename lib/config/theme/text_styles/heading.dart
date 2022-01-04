import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadingStyles {
  static final TextStyle heading1 =
      GoogleFonts.greatVibes(fontSize: 38.sp, color: Colors.black);
  static final TextStyle heading2 =
      GoogleFonts.roboto(fontSize: 32.sp, color: Colors.black);

  static final TextStyle heading3=heading1.copyWith(fontSize: 24.sp);
}
