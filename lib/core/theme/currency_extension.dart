import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension CurrencyContextX on BuildContext {
  /// Returns the current active currency symbol (e.g. ₹, $, €, £, ¥) from SettingsBloc.
  String get currencySymbol {
    try {
      final state = watch<SettingsBloc>().state;
      if (state is SettingsLoadedState) {
        return state.settings.currencySymbol;
      }
    } catch (_) {}
    return '₹';
  }
}
