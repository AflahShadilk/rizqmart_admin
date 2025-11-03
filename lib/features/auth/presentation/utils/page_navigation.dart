import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class GlobalNavigator {
  static Future<void> saveAndNavigate({
    required BuildContext context,
    String? key,              
    dynamic value,             
    String? route,              
    bool replace = false,       
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (key != null && value != null) {
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    }

    if (route != null && context.mounted) {
      replace ? context.go(route) : context.push(route);
    }
  }
}
