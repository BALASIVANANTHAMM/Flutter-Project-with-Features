import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme{
  static const Color colorPrimary=Color(0xff5669FF);
  static const Color colorSecondary=Color(0xff00F8FF);
  static const Color transparent=Colors.transparent;
  static  Color lightGrad1=const Color(0xff5BCAE6).withOpacity(0.5);
  static  Color lightGrad2=const Color(0xffEDEAE3).withOpacity(0.7);
  static  Color light=const Color(0xffEDEAE3);
  static Color secondaryWO=colorSecondary.withOpacity(0.3);
  static const Color white=Color(0xffffffff);
  static const Color cancelAlert=Color(0xffEEE5FF);
  static const Color darkPrimary=Color(0xff3D56F0);
  static const Color black=Color(0xff000000);
  static const Color grey=Color(0xff747688);
  static const Color cancel=Color(0xffEEE5FF);
  static const Color blue=Color(0xff3655ff);
  static Color blueLight=const Color(0xff8a9ef6).withOpacity(0.5);
  static const Color green=Color(0xff00A86B);
  static const Color greenLight=Color(0xff8fefc9);
  static const Color red=Color(0xffF40101);
  static const Color redLight=Color(0xffefa2a2);
  static const Color yellow=Color(0xffecb40c);
  static const Color enterLight=Color(0xffE7FFB7);
  static const Color billsLight=Color(0xffFDD5F5);
  static const Color othersLight=Color(0xffB6E9FB);
  static const Color yellowLight=Color(0xffefdba6);
  static const Color violet=Color(0xff780cec);
  static  Color violetLight=Color(0xffc8adef).withOpacity(0.7);
  static  Color red20=red.withOpacity(0.2);
  static const LinearGradient topTobottom=LinearGradient(
      colors: [
        colorPrimary,colorSecondary
      ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter
  );
  static  LinearGradient RightToLeft=LinearGradient(
      colors: [
        colorPrimary.withOpacity(0.3),colorSecondary.withOpacity(0.3)
      ],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft
  );

  static LinearGradient lightTopToBottom=LinearGradient(
      colors: [
        lightGrad1,lightGrad2
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter
  );

  //font sizes
  static double nine = 9;
  static double tiny = 10;
  static double eleven = 11;
  static double small = 12;
  static double thirteen = 13;
  static double medium = 14;
  static double medium_15 = 15;
  static double large = 16;
  static double big = 18;
  static double big_20 = 20;
  static double big_22 = 22;
  static double ultraBig = 30;
  static double ultraBig_40 = 40;
}