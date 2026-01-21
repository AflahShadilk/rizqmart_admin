import 'package:flutter/material.dart';

extension SizedBoxExtension on num {
  /// Returns a [SizedBox] with height set to this number.
  SizedBox get h => SizedBox(height: toDouble());

  /// Returns a [SizedBox] with width set to this number.
  SizedBox get w => SizedBox(width: toDouble());
}
