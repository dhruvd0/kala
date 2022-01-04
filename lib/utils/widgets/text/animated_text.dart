import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:kala/config/theme/text_styles/body.dart';

class RotatingText extends StatefulWidget {
  const RotatingText({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);
  final String text;
  final TextStyle? style;

  @override
  State<RotatingText> createState() => _RotatingTextState();
}

class _RotatingTextState extends State<RotatingText> {
  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? BodyTextStyle.bodyText1;
    return SizedBox(
      height:style.fontSize!,
      key: UniqueKey(),
      child: DefaultTextStyle(
        style: style,
        child: AnimatedTextKit(
            isRepeatingAnimation: false,
            repeatForever: false,
            animatedTexts: [
              RotateAnimatedText(
                widget.text,
                rotateOut: false,
                duration: const Duration(milliseconds: 200),
                transitionHeight: style.fontSize! * (6/ 3),
              ),
            ]),
      ),
    );
  }
}
