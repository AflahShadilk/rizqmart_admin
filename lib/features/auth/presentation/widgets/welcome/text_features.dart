  import 'package:flutter/material.dart';

Padding textPadding({
    required String text,
    required EdgeInsets padding,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required TextAlign align,
  }) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }