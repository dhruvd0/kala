import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class RectMonoButton extends StatelessWidget {
  double? height;
  double? width;
  final String text;
  final VoidCallback onTap;
  final EdgeInsets? margin;
  RectMonoButton({
    Key? key,
    this.height,
    this.width,
    required this.text,
    required this.onTap,
    this.margin,
  }) : super(key: key);
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
            color: Colors.black,
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
