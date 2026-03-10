import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/core/constants/appcolor.dart';
import 'package:rizqmartadmin/features/auth/presentation/cubit/user/user_search_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/users/users_event.dart';
import 'package:responsive_framework/responsive_framework.dart';

class UserSearchBar extends StatelessWidget {
  const UserSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    
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
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              hintText: 'Search users...',
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.search_rounded,
                  color: AppColors.grey600,
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
                            color: AppColors.grey300,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.grey700,
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
