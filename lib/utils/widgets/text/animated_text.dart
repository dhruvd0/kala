import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:kala/config/theme/text_styles/body.dart';

class RotatingText extends StatefulWidget {
  const RotatingText({
    required this.text,
    required this.style,
    Key? key,
  }) : super(key: key);

  final TextStyle? style;
  final String text;

  @override
  State<RotatingText> createState() => _RotatingTextState();
}

class _RotatingTextState extends State<RotatingText> {
  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? BodyTextStyle.bodyText1;
    return SizedBox(
      height: style.fontSize,
     
      child: DefaultTextStyle(
        style: style,
        child: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            RotateAnimatedText(
              widget.text,
              rotateOut: false,
              duration: const Duration(milliseconds: 200),
              transitionHeight: style.fontSize! * (6 / 3),
            ),
          ],
        ),
      ),
    );
  }
}
