import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:flutter/material.dart';

class TextStylePaletter {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: ColorPaletter.textPrimary,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: ColorPaletter.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: ColorPaletter.textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyLarge = TextStyle(
      fontSize: 16,
      color: ColorPaletter.textPrimary,
      fontWeight: FontWeight.w500
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: ColorPaletter.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: ColorPaletter.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColorPaletter.white,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorPaletter.textGrey,
  );
}