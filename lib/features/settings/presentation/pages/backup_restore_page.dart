import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackupRestorePage extends StatelessWidget {
  const BackupRestorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const AppAppBar(
        title: 'Backup & Restore',
      ),
      body: SafeArea(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoadedState && state.successMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successMessage!),
                  backgroundColor: AppColors.primary,
                ),
              );
            }
          },
          builder: (context, state) {
            final isExporting =
                (state is SettingsLoadedState) ? state.isExporting : false;

            return SingleChildScrollView(
              padding: AppSpacing.paddingMD,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data Portability & Storage',
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppSpacing.vGapSM,

                  // 1. Export JSON Backup
                  AppCard(
                    variant: AppCardVariant.standard,
                    padding: AppSpacing.paddingMD,
                    onTap: isExporting
                        ? null
                        : () => context
                            .read<SettingsBloc>()
                            .add(const ExportBackupJsonEvent()),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.upload_file_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        AppSpacing.hGapMD,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Export Full Database Backup',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.vGapXXS,
                              Text(
                                'Save encrypted JSON backup file of all accounts, transactions, caps & goals',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.vGapXS,

                  // 2. Restore JSON Backup
                  AppCard(
                    variant: AppCardVariant.standard,
                    padding: AppSpacing.paddingMD,
                    onTap: isExporting
                        ? null
                        : () => context
                            .read<SettingsBloc>()
                            .add(const RestoreBackupJsonEvent()),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.restore_page_rounded,
                            color: AppColors.secondary,
                            size: 22,
                          ),
                        ),
                        AppSpacing.hGapMD,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Restore Database Backup',
                                style: AppTypography.titleMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              AppSpacing.vGapXXS,
                              Text(
                                'Select a previously saved JSON backup file to restore application data',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),

                  if (isExporting) ...[
                    AppSpacing.vGapLG,
                    const AppLoading(message: 'Processing backup operation...'),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}
