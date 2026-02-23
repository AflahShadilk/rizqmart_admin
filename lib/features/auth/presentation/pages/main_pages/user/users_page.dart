

import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/users/user_search_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/user/user_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/user/user_data_table.dart';
import 'package:rizqmartadmin/features/auth/presentation/widgets/page_decoration/respnsive_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchCubit(),
      child: const UsersView(),
    );
  }
}

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<UsersBloc>().add(const LoadUsersByRole('user'));
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.people_rounded, color: Colors.blue.shade700, size: 24),
            ),
            12.w,
             Text(
              'Users Management',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: Colors.blue.shade700, size: 22),
              onPressed: () => context.read<UsersBloc>().add(const LoadUsersByRole('user')),
              tooltip: 'Refresh Users',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SearchAndStatsBar(),
          Expanded(child: UsersBody()),
        ],
      ),
    );
  }
}

class SearchAndStatsBar extends StatelessWidget {
  const SearchAndStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: Responsive.isMobile(context) ? 1 : 2,
            child: const SearchBar(),
          ),
          if (!Responsive.isMobile(context)) ...[
            16.w,
            const Expanded(child: UserStatsCards()),
          ],
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    
    return BlocBuilder<UserSearchCubit, String>(
      builder: (context, searchQuery) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 400,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: searchQuery.isNotEmpty 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).dividerColor.withValues(alpha: 0.2),
              width: searchQuery.isNotEmpty ? 2 : 1,
            ),
          ),
          child: TextField(
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Search users...',
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
              ),
              suffixIcon: searchQuery.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade700,
                            size: 14,
                          ),
                        ),
                        onPressed: () {
                          context.read<UserSearchCubit>().clearSearch();
                          context.read<UsersBloc>().add(const SearchUsers(''));
                        },
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              context.read<UserSearchCubit>().updateSearch(value);
              context.read<UsersBloc>().add(SearchUsers(value));
            },
          ),
        );
      },
    );
  }
}

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
                  color: Colors.blue,
                ),
              ),
              12.w,
              Expanded(
                child: StatsCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Active Users',
                  value: activeUsers.toString(),
                  color: Colors.green,
                ),
              ),
              12.w,
              Expanded(
                child: StatsCard(
                  icon: Icons.filter_list_rounded,
                  label: 'Filtered',
                  value: filteredUsers.toString(),
                  color: Colors.orange,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
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
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1,
                  ),
                ),
                4.h,
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontWeight: FontWeight.w500,
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

class UsersBody extends StatelessWidget {
  const UsersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    strokeWidth: 3,
                  ),
                ),
                24.h,
                Text(
                  'Loading users...',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UsersError) {
          return ErrorView(message: state.message);
        }

        if (state is UsersLoaded) {
          if (state.filteredUsers.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(48),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.people_outline_rounded,
                        size: 64,
                        color: Colors.blue.shade300,
                      ),
                    ),
                    24.h,
                    Text(
                      'No users found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        letterSpacing: 0.3,
                      ),
                    ),
                    8.h,
                    Text(
                      'Try adjusting your search filters',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Responsive.isMobile(context)
              ? MobileView(users: state.filteredUsers)
              : DesktopView(users: state.filteredUsers);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

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
              color: Colors.black.withValues(alpha: 0.08),
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
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 56,
                color: Colors.red.shade400,
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
              ),
              textAlign: TextAlign.center,
            ),
            12.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w400,
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
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  shadowColor: Colors.blue.withValues(alpha: 0.3),
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

class MobileView extends StatelessWidget {
  final List<UserEntity> users;

  const MobileView({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).cardTheme.color,
          child: const MobileStatsCards(),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: UserCard(user: users[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class MobileStatsCards extends StatelessWidget {
  const MobileStatsCards({super.key});

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
                  label: 'Total',
                  value: totalUsers.toString(),
                  color: Colors.blue,
                ),
              ),
              8.w,
              Expanded(
                child: StatsCard(
                  icon: Icons.check_circle_rounded,
                  label: 'Active',
                  value: activeUsers.toString(),
                  color: Colors.green,
                ),
              ),
              8.w,
              Expanded(
                child: StatsCard(
                  icon: Icons.filter_list_rounded,
                  label: 'Filtered',
                  value: filteredUsers.toString(),
                  color: Colors.orange,
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

class DesktopView extends StatelessWidget {
  final List<UserEntity> users;

  const DesktopView({super.key, required this.users});

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
              color: Colors.black.withValues(alpha: 0.04),
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