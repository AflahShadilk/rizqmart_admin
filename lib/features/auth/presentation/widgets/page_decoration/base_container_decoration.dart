import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

BoxDecoration firstcontainerdecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [AppColors.surfaceLight, AppColors.backgroundColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}