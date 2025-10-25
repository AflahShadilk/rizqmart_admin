import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

PreferredSizeWidget appBarRizq(BuildContext context) {
  return AppBar(
    backgroundColor: AppColors.darkBlue,
    title: Text(
      'Rizq Mart',
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      SizedBox(width: 16),
      // SizedBox(
      //   width: 200,
      //   child: TextField(
      //     decoration: InputDecoration(
      //       hintText: 'Quick Search',
      //       hintStyle: GoogleFonts.inter(color: AppColors.lightGray),
      //       border: InputBorder.none,
      //       prefixIcon: Icon(Icons.search, color: Colors.white),
      //     ),
      //   ),
      // ),
      SizedBox(width: 16),
      IconButton(
        icon: Icon(Icons.notifications, color: Colors.white),
        onPressed: () {},
      ),
      SizedBox(width: 16),
      IconButton(
        icon: Icon(Icons.logout, color: Colors.white),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          final pref = await SharedPreferences.getInstance();
          await pref.setBool('isLoggedIn', false); 
          // ignore: use_build_context_synchronously
          context.goNamed('loginPage'); 
        },
      ),
    ],
  );
}
