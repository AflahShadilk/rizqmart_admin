import 'package:flutter/material.dart';
import 'package:rizqmartadmin/features/auth/domain/entities/main/user_entity.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/user/widgets/user_card.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/user/widgets/user_stats_cards.dart';

class UsersMobileView extends StatelessWidget {
  final List<UserEntity> users;

  const UsersMobileView({super.key, required this.users});

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
            itemBuilder: (context, index) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserCard(user: users[index]),
                ),
              ),
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
    return const UserStatsCards(); 
  }
}
