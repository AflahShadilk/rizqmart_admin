// ignore_for_file: deprecated_member_use

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            16.h,
            const Divider(),
            8.h,
            _buildInfo(context),
            16.h,
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: user.profileImageUrl != null
              ? NetworkImage(user.profileImageUrl!)
              : null,
          child: user.profileImageUrl == null
              ? Text(
                  _getInitials(),
                  style: const TextStyle(fontSize: 24, fontFamily: 'Inter'),
                )
              : null,
        ),
        16.w,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name ?? 'No Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontFamily: 'Inter',
                ),
              ),
              4.h,
              Text(
                user.email,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: user.isActive
            ? AppColors.emerald.withValues(alpha: 0.1)
            : AppColors.chartRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        user.isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: user.isActive ? AppColors.emerald : AppColors.chartRed,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Column(
      children: [
        _buildInfoRow(context, Icons.phone, user.phoneNumber ?? 'No phone'),
        8.h,
        _buildInfoRow(context, Icons.badge, user.role.toUpperCase()),
        8.h,
        _buildInfoRow(
          context,
          Icons.calendar_today,
          'Joined: ${DateFormat('MMM dd, yyyy').format(user.createdAt)}',
        ),
        if (user.lastLoginAt != null) ...[
          8.h,
          _buildInfoRow(
            context,
            Icons.login,
            'Last login: ${DateFormat('MMM dd, yyyy').format(user.lastLoginAt!)}',
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).textTheme.bodySmall?.color),
        8.w,
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: (user.isActive ? AppColors.chartRed : AppColors.emerald).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: Icon(
              user.isActive ? Icons.block : Icons.check_circle,
              color: user.isActive ? AppColors.chartRed : AppColors.emerald,
              size: 16,
            ),
            onPressed: () => _showStatusDialog(context),
            tooltip: user.isActive ? 'Deactivate' : 'Activate',
          ),
        ),
        8.w,
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.chartRed.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.chartRed, size: 16),
            onPressed: () => _showDeleteDialog(context),
            tooltip: 'Delete User',
          ),
        ),
      ],
    );
  }

  String _getInitials() {
    return user.name?.substring(0, 1).toUpperCase() ??
        user.email.substring(0, 1).toUpperCase();
  }

  void _showStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(user.isActive ? 'Deactivate User' : 'Activate User'),
        content: Text(
          user.isActive
              ? 'Are you sure you want to deactivate ${user.name ?? user.email}?'
              : 'Are you sure you want to activate ${user.name ?? user.email}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UsersBloc>().add(UpdateUserStatus(user.id, !user.isActive));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive ? AppColors.red : AppColors.green,
            ),
            child: Text(user.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete ${user.name ?? user.email}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UsersBloc>().add(DeleteUser(user.id));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}