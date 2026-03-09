

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';

class UsersDataTable extends StatelessWidget {
  final List<UserEntity> users;

  const UsersDataTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return AnimatedHoverCard(
      padding: EdgeInsets.zero,
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.resolveWith((states) => AppColors.deepPurple.withValues(alpha: 0.05)),
            headingTextStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
          dataRowMaxHeight: 65,
          columnSpacing: 24,
          horizontalMargin: 24,
          columns: const [
            DataColumn(label: Text('Avatar')),
            DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Joined', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Last Login', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: users.map((user) => _buildDataRow(context, user)).toList(),
        ),
      ),
    ));
  }

  DataRow _buildDataRow(BuildContext context, UserEntity user) {
    return DataRow(
      cells: [
        DataCell(_buildAvatar(user)),
        DataCell(Text(user.name ?? 'No Name')),
        DataCell(Text(user.email)),
        DataCell(Text(user.phoneNumber ?? '-')),
        DataCell(_buildRoleBadge(user.role)),
        DataCell(_buildStatusBadge(user.isActive)),
        DataCell(Text(DateFormat('MMM dd, yyyy').format(user.createdAt))),
        DataCell(Text(
          user.lastLoginAt != null
              ? DateFormat('MMM dd, yyyy').format(user.lastLoginAt!)
              : 'Never',
        )),
        DataCell(_buildActions(context, user)),
      ],
    );
  }

  Widget _buildAvatar(UserEntity user) {
    return CircleAvatar(
      backgroundImage: user.profileImageUrl != null
          ? NetworkImage(user.profileImageUrl!)
          : null,
      child: user.profileImageUrl == null
          ? Text(
              user.name?.substring(0, 1).toUpperCase() ??
                  user.email.substring(0, 1).toUpperCase(),
            )
          : null,
    );
  }

  Widget _buildRoleBadge(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.toUpperCase(),
        style: const TextStyle(
          color: AppColors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.green.withValues(alpha: 0.1)
            : AppColors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? '● Active' : '● Inactive',
        style: TextStyle(
          color: isActive ? AppColors.green : AppColors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, UserEntity user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            user.isActive ? Icons.block : Icons.check_circle,
            color: user.isActive ? AppColors.orange : AppColors.green,
            size: 20,
          ),
          onPressed: () => _showStatusDialog(context, user),
          tooltip: user.isActive ? 'Deactivate' : 'Activate',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: AppColors.red, size: 20),
          onPressed: () => _showDeleteDialog(context, user),
          tooltip: 'Delete',
        ),
      ],
    );
  }

  void _showStatusDialog(BuildContext context, UserEntity user) {
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
              backgroundColor: user.isActive ? AppColors.orange : AppColors.green,
            ),
            child: Text(user.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, UserEntity user) {
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