import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  final TextEditingController _pinController = TextEditingController();

  void _showSetPinDialog(BuildContext context) {
    _pinController.clear();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Set App Security PIN',
          style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
        content: AppTextField(
          controller: _pinController,
          label: '4-Digit Secret PIN',
          hint: 'e.g. 1234',
          keyboardType: TextInputType.number,
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final pin = _pinController.text.trim();
              if (pin.length >= 4) {
                Navigator.of(dialogCtx).pop();
                context.read<SettingsBloc>().add(
                      TogglePinLockEvent(enabled: true, pin: pin),
                    );
              }
            },
            child: const Text('Save PIN', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppAppBar(
        title: 'Security & App Lock',
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadedState) {
              final isPinEnabled = state.settings.isPinLockEnabled;
              final isBioEnabled = state.settings.isBiometricEnabled;
              final isBioSupported = state.isBiometricsSupported;

              return Padding(
                padding: AppSpacing.paddingMD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Authentication Controls',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,

                    // 1. PIN Lock Switch
                    AppCard(
                      variant: AppCardVariant.standard,
                      padding: AppSpacing.paddingMD,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.pin_rounded,
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
                                  'PIN Code Lock',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                AppSpacing.vGapXXS,
                                Text(
                                  isPinEnabled
                                      ? 'Secret PIN lock active on app launch'
                                      : 'Require PIN code to open Dhanra',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isPinEnabled,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              if (val) {
                                _showSetPinDialog(context);
                              } else {
                                context.read<SettingsBloc>().add(
                                      const TogglePinLockEvent(enabled: false),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vGapXS,

                    // 2. Biometric Lock Switch
                    AppCard(
                      variant: AppCardVariant.standard,
                      padding: AppSpacing.paddingMD,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.fingerprint_rounded,
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
                                  'Biometric Unlock',
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                AppSpacing.vGapXXS,
                                Text(
                                  isBioSupported
                                      ? 'Unlock using Fingerprint or FaceID'
                                      : 'Biometric hardware not available on device',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isBioEnabled,
                            activeColor: AppColors.secondary,
                            onChanged: isBioSupported
                                ? (val) {
                                    context
                                        .read<SettingsBloc>()
                                        .add(ToggleBiometricsEvent(val));
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const AppLoading(message: 'Loading security settings...');
          },
        ),
      ),
    );
  }
}
