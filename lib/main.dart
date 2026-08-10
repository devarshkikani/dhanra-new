import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/services/notification_service.dart';
import 'package:dhanra_new/core/theme/app_theme.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppErrorBoundary.initializeGlobalErrorHandler();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  await getIt<NotificationService>().init();
  runApp(const DhanraApp());
}

class DhanraApp extends StatelessWidget {
  const DhanraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => getIt<SettingsBloc>()..add(const LoadSettingsEvent()),
      child: AppErrorBoundary(
        child: MaterialApp.router(
          title: 'Dhanra',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
