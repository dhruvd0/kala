import 'package:flutter/material.dart';

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
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ),
    );
  }
}
