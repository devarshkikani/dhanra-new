import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
  });
}

class CurrencySettingsPage extends StatelessWidget {
  const CurrencySettingsPage({super.key});

  static const List<CurrencyInfo> currencies = [
    CurrencyInfo(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    CurrencyInfo(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyInfo(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyInfo(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyInfo(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyInfo(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar'),
    CurrencyInfo(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
  ];

  @override
  Widget build(BuildContext context) {
    return AppBackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const AppAppBar(
        title: 'Primary Currency',
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadedState) {
              final selectedCode = state.settings.currencyCode;

              return SingleChildScrollView(
                padding: AppSpacing.paddingMD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Display Currency',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,
                    ...currencies.map((c) {
                      final isSelected = c.code == selectedCode;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: AppCard(
                          variant: isSelected
                              ? AppCardVariant.hero
                              : AppCardVariant.standard,
                          padding: AppSpacing.paddingMD,
                          onTap: () {
                            context.read<SettingsBloc>().add(
                                  UpdateCurrencyEvent(
                                    code: c.code,
                                    symbol: c.symbol,
                                  ),
                                );
                          },
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.2)
                                      : AppColors.darkSurface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    c.symbol,
                                    style: AppTypography.headlineSmall.copyWith(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              AppSpacing.hGapMD,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${c.name} (${c.code})',
                                      style: AppTypography.titleMedium.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    AppSpacing.vGapXXS,
                                    Text(
                                      'Symbol: ${c.symbol}',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.primary,
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            }

            return const AppLoading(message: 'Loading currency settings...');
          },
        ),
      ),
    ));
  }
}
