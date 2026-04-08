import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/theme/appcolor.dart';
import 'package:rizqmartadmin/core/utils/extensions/sized_box_extension.dart';
import 'package:rizqmartadmin/features/presentation/cubit/user/user_search_cubit.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/users/users_bloc.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/users/users_event.dart';
import 'package:rizqmartadmin/features/presentation/bloc/main/users/users_state.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'widgets/user_search_bar.dart';
import 'widgets/user_stats_cards.dart';
import 'widgets/user_empty_state.dart';
import 'widgets/user_error_view.dart';
import 'widgets/users_desktop_view.dart';
import 'widgets/users_mobile_view.dart';

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

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UsersBloc>().add(const LoadUsersByRole('user'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        // ---------------- Users Page Header ----------------
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.people_rounded, color: AppColors.blue700, size: 24),
            ),
            12.w,
            Text(
              'Users Management',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.blue50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.blue100),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded, color: AppColors.blue700, size: 22),
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

// ---------------- User Search & Stats Section ----------------
class SearchAndStatsBar extends StatelessWidget {
  const SearchAndStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? const UserSearchBar()
          : (isTablet
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const UserSearchBar(),
                    16.h,
                    const UserStatsCards(),
                  ],
                )
              : Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: UserSearchBar(),
                    ),
                    16.w,
                    const Expanded(
                      flex: 2,
                      child: UserStatsCards(),
                    ),
                  ],
                )),
    );
  }
}

// ---------------- Users List Section ----------------
class UsersBody extends StatelessWidget {
  const UsersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return _buildLoadingState(context);
        }

        if (state is UsersError) {
          return UserErrorView(message: state.message);
        }

        if (state is UsersLoaded) {
          if (state.filteredUsers.isEmpty) {
            return const UserEmptyState();
          }

          final isMobile = ResponsiveBreakpoints.of(context).isMobile;
          return isMobile
              ? UsersMobileView(users: state.filteredUsers)
              : UsersDesktopView(users: state.filteredUsers);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
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
                  color: AppColors.blue.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue600),
              strokeWidth: 3,
            ),
          ),
          24.h,
          Text(
            'Loading users...',
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}