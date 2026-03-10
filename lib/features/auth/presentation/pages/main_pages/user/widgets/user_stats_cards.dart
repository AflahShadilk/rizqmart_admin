import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_state.dart';
import 'package:rizqmartadmin/widgets/animated_hover_card.dart';

class UserStatsCards extends StatelessWidget {
  const UserStatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoaded) {
          final totalUsers = state.users.length;
          final filteredUsers = state.filteredUsers.length;
          final activeUsers = state.users.where((user) => user.isActive).length;

          return Row(
            children: [
              Expanded(
                child: StatsCard(
                  icon: Icons.people_rounded,
                  label: 'Total Users',
                  value: totalUsers.toString(),
                  color: AppColors.blue,
                ),
              ),
              12.w,
              Expanded(
                child: StatsCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Active Users',
                  value: activeUsers.toString(),
                  color: AppColors.green,
                ),
              ),
              12.w,
              Expanded(
                child: StatsCard(
                  icon: Icons.filter_list_rounded,
                  label: 'Filtered',
                  value: filteredUsers.toString(),
                  color: AppColors.orange,
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedHoverCard(
      color: color.withValues(alpha: 0.05),
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                      height: 1,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                4.h,
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
