import 'package:flutter/material.dart';

BoxDecoration firstcontainerdecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}