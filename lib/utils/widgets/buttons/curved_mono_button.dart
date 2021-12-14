import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurvedMonoButton extends StatelessWidget {
  double height;
  double width;
  String text;
  VoidCallback onTap;
  EdgeInsets? margin;
  CurvedMonoButton({
    Key? key,
    required this.height,
    required this.width,
    required this.text,
    required this.onTap,
    this.margin,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
