import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/auth/bloc/login%20bloc/auth_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/notification/notification_bell.dart';

PreferredSizeWidget appBarRizq(BuildContext context) {
  final theme = Theme.of(context);

  return AppBar(
    backgroundColor: theme.appBarTheme.backgroundColor,
    elevation: 0,
    title: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.storefront_outlined,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        8.w,
        Text(
          'Rizq Mart',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
      ],
    ),
    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu_rounded, color: theme.appBarTheme.foregroundColor),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      const NotificationBell(),
      30.w,
      Container(
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: AppColors.matRed.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(Icons.logout_rounded, color: AppColors.red, size: 20),
          onPressed: () => _showLogoutDialog(context),
          tooltip: 'Logout',
        ),
      ),
      8.w,
    ],
  );
}

void _showLogoutDialog(BuildContext context) {
  final theme = Theme.of(context);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Logout',
          style: theme.dialogTheme.titleTextStyle,
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: theme.dialogTheme.contentTextStyle,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.matRed,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              context.read<LoginBloc>().add(LogoutEvent());
            },
            child: Text(
              'Logout',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    },
  );
}