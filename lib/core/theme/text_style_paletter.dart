import 'package:citizen_mobile_app/core/theme/color_paletter.dart';
import 'package:flutter/material.dart';

class TextStylePaletter {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: ColorPaletter.textColor,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: ColorPaletter.textSecondary,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColorPaletter.white,
  );
  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: ColorPaletter.textColor,
  );
}