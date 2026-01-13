 import 'package:flutter/material.dart';

BoxDecoration firstcontainerdecoration() {
    return const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFDFDFD), Color(0xFFF5F5F5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      );
  }