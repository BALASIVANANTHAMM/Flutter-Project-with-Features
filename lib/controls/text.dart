import 'dart:core';
import 'package:flutter/material.dart';

class CText extends StatelessWidget{
  final String? text;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? textColor;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final TextBaseline? textBaseline;

  const CText({
    super.key,
    required this.text,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.maxLines,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.textBaseline,
});

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
        textAlign:  textAlign,
        textDirection:  textDirection,
        overflow: overflow,
        maxLines: maxLines,
      style: TextStyle(
        color: textColor,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
    ),);
  }
}