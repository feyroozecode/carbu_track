import 'package:flutter/material.dart';

class AppSizes {
  const AppSizes._();
  static const double s0 = 0;
  static const double s1 = 1;
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s14 = 14;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s24 = 24;

  // gaps
  static const double gap4 = 4;
  static const double gap8 = 8;
  static const double gap12 = 12;
  static const double gap16 = 16;
  static const double gap24 = 24;
  static const double gap32 = 32;
  static const double gap48 = 48;
  static const double gap64 = 64;
  static const double gap96 = 96;

  // screen size
  static const double screenS = 375;
  static const double screenM = 414;
  static const double screenL = 768;
  static const double screenXL = 1024;

  // padding
  static const double p4 = 4;
  static const double p8 = 8;
  static const double p12 = 12;
  static const double p16 = 16;
  static const double p20 = 20;
  static const double p24 = 24;
  static const double p32 = 32;
  static const double p48 = 48;
  static const double p64 = 64;

  // screen
  static const screenPadding = EdgeInsets.all(p16);
}

/// Constant gap widths
const gapW4 = SizedBox(width: AppSizes.p4);
const gapW8 = SizedBox(width: AppSizes.p8);
const gapW12 = SizedBox(width: AppSizes.p12);
const gapW16 = SizedBox(width: AppSizes.p16);
const gapW20 = SizedBox(width: AppSizes.p20);
const gapW24 = SizedBox(width: AppSizes.p24);
const gapW32 = SizedBox(width: AppSizes.p32);
const gapW48 = SizedBox(width: AppSizes.p48);
const gapW64 = SizedBox(width: AppSizes.p64);

/// Constant gap heights
const gapH4 = SizedBox(height: AppSizes.p4);
const gapH8 = SizedBox(height: AppSizes.p8);
const gapH12 = SizedBox(height: AppSizes.p12);
const gapH16 = SizedBox(height: AppSizes.p16);
const gapH20 = SizedBox(height: AppSizes.p20);
const gapH24 = SizedBox(height: AppSizes.p24);
const gapH32 = SizedBox(height: AppSizes.p32);
const gapH48 = SizedBox(height: AppSizes.p48);
const gapH64 = SizedBox(height: AppSizes.p64);
