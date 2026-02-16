import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/notification/notification_bell.dart';

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
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      16.w,
      const NotificationBell(),
      16.w,
      IconButton(
        icon: const Icon(Icons.logout, color: Colors.white),
        onPressed: () => _showLogoutDialog(context),
      ),
      16.w,
    ],
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<LoginBloc>().add(LogoutEvent());
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );
    },
  );
}