import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class RectMonoButton extends StatelessWidget {
  RectMonoButton({
    required this.text,
    required this.onTap,
    Key? key,
    this.height,
    this.width,
    this.margin,
  }) : super(key: key);

  double? height;
  final EdgeInsets? margin;
  final VoidCallback onTap;
  final String text;
  double? width;

  @override
  Widget build(BuildContext context) {
    height = height ?? 50.h;
    width = width ?? 1.sw / 1.8;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          border: Border.all(
            
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }
}
