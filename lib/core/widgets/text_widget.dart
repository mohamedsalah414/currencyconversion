import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String txt;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  const TextWidget(
      {Key? key,
      required this.txt,
      this.color,
      this.fontWeight,
      this.fontSize,
      this.textAlign,
      this.overflow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      textAlign: textAlign,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
