import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';

class UserErrorView extends StatelessWidget {
  final String message;

  const UserErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(40),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.red50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: AppColors.red400,
              ),
            ),
            24.h,
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                letterSpacing: 0.3,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
            12.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            32.h,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.read<UsersBloc>().add(const LoadUsersByRole('user')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue600,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: AppColors.blue.withValues(alpha: 0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh_rounded, size: 20),
                    8.w,
                    const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
