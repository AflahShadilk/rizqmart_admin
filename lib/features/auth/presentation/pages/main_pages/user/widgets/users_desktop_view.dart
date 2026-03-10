import 'package:flutter/material.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/user/widgets/user_data_table.dart';

class UsersDesktopView extends StatelessWidget {
  final List<UserEntity> users;

  const UsersDesktopView({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: UsersDataTable(users: users),
        ),
      ),
    );
  }
}
