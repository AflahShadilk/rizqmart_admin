// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';

class UsersDataTable extends StatelessWidget {
  final List<UserEntity> users;

  const UsersDataTable({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Avatar')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Joined')),
            DataColumn(label: Text('Last Login')),
            DataColumn(label: Text('Actions')),
          ],
          rows: users.map((user) => _buildDataRow(context, user)).toList(),
        ),
      ),
    );
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
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.toUpperCase(),
        style: const TextStyle(
          color: Colors.blue,
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
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? '● Active' : '● Inactive',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
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
            color: user.isActive ? Colors.orange : Colors.green,
            size: 20,
          ),
          onPressed: () => _showStatusDialog(context, user),
          tooltip: user.isActive ? 'Deactivate' : 'Activate',
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
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
              backgroundColor: user.isActive ? Colors.orange : Colors.green,
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}