import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/theme/theme_cubit.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/bloc/cubit/theme/theme_state.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/settings/widgets/settings_info_row.dart';
import 'package:rizqmartadmin/features/auth/presentation/pages/main_pages/settings/widgets/settings_section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- Settings Page Header ----------------
                Text(
                  'Settings',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your app preferences',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 32),

                // ---------------- Appearance Section ----------------
                SettingsSectionCard(
                  title: 'Appearance',
                  icon: Icons.palette_outlined,
                  children: [
                    BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Theme Mode',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Choose your preferred appearance',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: SegmentedButton<ThemeMode>(
                                segments: const [
                                  ButtonSegment(
                                    value: ThemeMode.light,
                                    icon: Icon(Icons.light_mode_outlined),
                                    label: Text('Light'),
                                  ),
                                  ButtonSegment(
                                    value: ThemeMode.dark,
                                    icon: Icon(Icons.dark_mode_outlined),
                                    label: Text('Dark'),
                                  ),
                                  ButtonSegment(
                                    value: ThemeMode.system,
                                    icon: Icon(Icons.settings_suggest_outlined),
                                    label: Text('System'),
                                  ),
                                ],
                                selected: {state.themeMode},
                                onSelectionChanged: (selected) {
                                  context
                                      .read<ThemeCubit>()
                                      .setThemeMode(selected.first);
                                },
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---------------- About Section ----------------
                SettingsSectionCard(
                  title: 'About',
                  icon: Icons.info_outline,
                  children: const [
                    SettingsInfoRow(label: 'App Name', value: 'Rizq Mart Admin'),
                    Divider(height: 24),
                    SettingsInfoRow(label: 'Version', value: '1.0.0'),
                    Divider(height: 24),
                    SettingsInfoRow(label: 'Platform', value: 'Flutter Web'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
