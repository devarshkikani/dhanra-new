// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/accounts/data/datasources/account_local_data_source.dart'
    as _i688;
import '../../features/accounts/data/repositories/account_repository_impl.dart'
    as _i126;
import '../../features/accounts/domain/repositories/account_repository.dart'
    as _i706;
import '../../features/accounts/domain/usecases/create_account_usecase.dart'
    as _i126;
import '../../features/accounts/domain/usecases/delete_account_usecase.dart'
    as _i1063;
import '../../features/accounts/domain/usecases/get_accounts_usecase.dart'
    as _i297;
import '../../features/accounts/domain/usecases/transfer_funds_usecase.dart'
    as _i248;
import '../../features/accounts/domain/usecases/update_account_usecase.dart'
    as _i927;
import '../../features/accounts/presentation/bloc/accounts_bloc.dart' as _i103;
import '../../features/analytics/data/datasources/analytics_local_data_source.dart'
    as _i292;
import '../../features/analytics/data/repositories/analytics_repository_impl.dart'
    as _i425;
import '../../features/analytics/domain/repositories/analytics_repository.dart'
    as _i1044;
import '../../features/analytics/domain/usecases/get_analytics_data_usecase.dart'
    as _i405;
import '../../features/analytics/presentation/bloc/analytics_bloc.dart' as _i70;
import '../../features/auth/data/datasources/auth_local_data_source.dart'
    as _i852;
import '../../features/auth/data/datasources/auth_remote_data_source.dart'
    as _i107;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/i_auth_repository.dart'
    as _i589;
import '../../features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i17;
import '../../features/auth/domain/usecases/reset_password_usecase.dart'
    as _i474;
import '../../features/auth/domain/usecases/send_phone_otp_usecase.dart'
    as _i713;
import '../../features/auth/domain/usecases/sign_in_with_email_usecase.dart'
    as _i744;
import '../../features/auth/domain/usecases/sign_out_usecase.dart' as _i915;
import '../../features/auth/domain/usecases/sign_up_with_email_usecase.dart'
    as _i254;
import '../../features/auth/domain/usecases/verify_phone_otp_usecase.dart'
    as _i1042;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/budgets/data/datasources/budget_local_data_source.dart'
    as _i155;
import '../../features/budgets/data/repositories/budget_repository_impl.dart'
    as _i654;
import '../../features/budgets/domain/repositories/budget_repository.dart'
    as _i1021;
import '../../features/budgets/domain/usecases/delete_category_budget_usecase.dart'
    as _i279;
import '../../features/budgets/domain/usecases/get_monthly_budget_summary_usecase.dart'
    as _i1001;
import '../../features/budgets/domain/usecases/save_category_budget_usecase.dart'
    as _i258;
import '../../features/budgets/domain/usecases/set_monthly_budget_limit_usecase.dart'
    as _i502;
import '../../features/budgets/presentation/bloc/budgets_bloc.dart' as _i120;
import '../../features/categories/data/datasources/category_local_data_source.dart'
    as _i390;
import '../../features/categories/data/repositories/category_repository_impl.dart'
    as _i894;
import '../../features/categories/domain/repositories/category_repository.dart'
    as _i266;
import '../../features/categories/domain/usecases/create_category_usecase.dart'
    as _i431;
import '../../features/categories/domain/usecases/delete_category_usecase.dart'
    as _i1007;
import '../../features/categories/domain/usecases/get_categories_usecase.dart'
    as _i76;
import '../../features/categories/domain/usecases/update_category_usecase.dart'
    as _i656;
import '../../features/categories/presentation/bloc/categories_bloc.dart'
    as _i78;
import '../../features/dashboard/data/datasources/dashboard_local_data_source.dart'
    as _i838;
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i509;
import '../../features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i665;
import '../../features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart'
    as _i1062;
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart'
    as _i652;
import '../../features/goals/data/datasources/goal_local_data_source.dart'
    as _i692;
import '../../features/goals/data/repositories/goal_repository_impl.dart'
    as _i942;
import '../../features/goals/domain/repositories/goal_repository.dart' as _i112;
import '../../features/goals/domain/usecases/add_goal_contribution_usecase.dart'
    as _i521;
import '../../features/goals/domain/usecases/create_goal_usecase.dart' as _i353;
import '../../features/goals/domain/usecases/delete_goal_usecase.dart' as _i70;
import '../../features/goals/domain/usecases/get_goals_summary_usecase.dart'
    as _i1027;
import '../../features/goals/domain/usecases/update_goal_usecase.dart' as _i929;
import '../../features/goals/presentation/bloc/goals_bloc.dart' as _i157;
import '../../features/notifications/data/datasources/notification_settings_local_data_source.dart'
    as _i156;
import '../../features/notifications/presentation/bloc/notifications_bloc.dart'
    as _i1041;
import '../../features/sample_feature/data/datasources/post_local_datasource.dart'
    as _i468;
import '../../features/sample_feature/data/datasources/post_remote_datasource.dart'
    as _i887;
import '../../features/sample_feature/data/repositories/post_repository_impl.dart'
    as _i328;
import '../../features/sample_feature/domain/repositories/post_repository.dart'
    as _i721;
import '../../features/sample_feature/domain/usecases/get_posts_usecase.dart'
    as _i803;
import '../../features/sample_feature/presentation/bloc/post_bloc.dart'
    as _i601;
import '../../features/settings/data/datasources/app_settings_local_data_source.dart'
    as _i917;
import '../../features/settings/presentation/bloc/settings_bloc.dart' as _i585;
import '../../features/transactions/data/datasources/transaction_local_data_source.dart'
    as _i371;
import '../../features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i443;
import '../../features/transactions/domain/repositories/transaction_repository.dart'
    as _i421;
import '../../features/transactions/domain/usecases/create_transaction_usecase.dart'
    as _i860;
import '../../features/transactions/domain/usecases/delete_transaction_usecase.dart'
    as _i623;
import '../../features/transactions/domain/usecases/get_transactions_usecase.dart'
    as _i974;
import '../../features/transactions/domain/usecases/update_transaction_usecase.dart'
    as _i39;
import '../../features/transactions/presentation/bloc/transactions_bloc.dart'
    as _i439;
import '../network/dio_client.dart' as _i667;
import '../network/network_info.dart' as _i932;
import '../services/backup_export_service.dart' as _i425;
import '../services/notification_service.dart' as _i941;
import '../services/security_service.dart' as _i337;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final externalModule = _$ExternalModule();
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i895.Connectivity>(() => externalModule.connectivity);
    gh.lazySingleton<_i59.FirebaseAuth>(() => externalModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => externalModule.firestore);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i941.NotificationService>(
        () => _i941.NotificationService());
    gh.lazySingleton<_i337.SecurityService>(() => _i337.SecurityService());
    gh.lazySingleton<_i838.DashboardLocalDataSource>(
        () => _i838.DashboardLocalDataSourceImpl());
    gh.lazySingleton<_i371.TransactionLocalDataSource>(
        () => _i371.TransactionLocalDataSourceImpl());
    gh.lazySingleton<_i688.AccountLocalDataSource>(
        () => _i688.AccountLocalDataSourceImpl());
    gh.lazySingleton<_i887.PostRemoteDataSource>(
        () => _i887.PostRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i421.TransactionRepository>(
        () => _i443.TransactionRepositoryImpl(
              gh<_i371.TransactionLocalDataSource>(),
              gh<_i688.AccountLocalDataSource>(),
              gh<_i838.DashboardLocalDataSource>(),
              gh<_i155.BudgetLocalDataSource>(),
            ));
    gh.lazySingleton<_i292.AnalyticsLocalDataSource>(
        () => _i292.AnalyticsLocalDataSourceImpl());
    gh.lazySingleton<_i390.CategoryLocalDataSource>(
        () => _i390.CategoryLocalDataSourceImpl());
    gh.lazySingleton<_i155.BudgetLocalDataSource>(
        () => _i155.BudgetLocalDataSourceImpl());
    gh.lazySingleton<_i107.AuthRemoteDataSource>(
        () => _i107.AuthRemoteDataSourceImpl(
              gh<_i59.FirebaseAuth>(),
              gh<_i974.FirebaseFirestore>(),
            ));
    gh.lazySingleton<_i692.GoalLocalDataSource>(
        () => _i692.GoalLocalDataSourceImpl());
    gh.lazySingleton<_i860.CreateTransactionUseCase>(() =>
        _i860.CreateTransactionUseCase(gh<_i421.TransactionRepository>()));
    gh.lazySingleton<_i623.DeleteTransactionUseCase>(() =>
        _i623.DeleteTransactionUseCase(gh<_i421.TransactionRepository>()));
    gh.lazySingleton<_i974.GetTransactionsUseCase>(
        () => _i974.GetTransactionsUseCase(gh<_i421.TransactionRepository>()));
    gh.lazySingleton<_i39.UpdateTransactionUseCase>(
        () => _i39.UpdateTransactionUseCase(gh<_i421.TransactionRepository>()));
    gh.lazySingleton<_i112.GoalRepository>(() => _i942.GoalRepositoryImpl(
          gh<_i692.GoalLocalDataSource>(),
          gh<_i688.AccountLocalDataSource>(),
          gh<_i838.DashboardLocalDataSource>(),
        ));
    gh.lazySingleton<_i665.DashboardRepository>(() =>
        _i509.DashboardRepositoryImpl(gh<_i838.DashboardLocalDataSource>()));
    gh.lazySingleton<_i266.CategoryRepository>(() =>
        _i894.CategoryRepositoryImpl(gh<_i390.CategoryLocalDataSource>()));
    gh.lazySingleton<_i1021.BudgetRepository>(() => _i654.BudgetRepositoryImpl(
          gh<_i155.BudgetLocalDataSource>(),
          gh<_i371.TransactionLocalDataSource>(),
          gh<_i838.DashboardLocalDataSource>(),
        ));
    gh.lazySingleton<_i156.NotificationSettingsLocalDataSource>(() =>
        _i156.NotificationSettingsLocalDataSource(
            gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i917.AppSettingsLocalDataSource>(
        () => _i917.AppSettingsLocalDataSource(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i1062.GetDashboardSummaryUseCase>(() =>
        _i1062.GetDashboardSummaryUseCase(gh<_i665.DashboardRepository>()));
    gh.lazySingleton<_i521.AddGoalContributionUseCase>(
        () => _i521.AddGoalContributionUseCase(gh<_i112.GoalRepository>()));
    gh.lazySingleton<_i353.CreateGoalUseCase>(
        () => _i353.CreateGoalUseCase(gh<_i112.GoalRepository>()));
    gh.lazySingleton<_i70.DeleteGoalUseCase>(
        () => _i70.DeleteGoalUseCase(gh<_i112.GoalRepository>()));
    gh.lazySingleton<_i1027.GetGoalsSummaryUseCase>(
        () => _i1027.GetGoalsSummaryUseCase(gh<_i112.GoalRepository>()));
    gh.lazySingleton<_i929.UpdateGoalUseCase>(
        () => _i929.UpdateGoalUseCase(gh<_i112.GoalRepository>()));
    gh.lazySingleton<_i279.DeleteCategoryBudgetUseCase>(
        () => _i279.DeleteCategoryBudgetUseCase(gh<_i1021.BudgetRepository>()));
    gh.lazySingleton<_i1001.GetMonthlyBudgetSummaryUseCase>(() =>
        _i1001.GetMonthlyBudgetSummaryUseCase(gh<_i1021.BudgetRepository>()));
    gh.lazySingleton<_i258.SaveCategoryBudgetUseCase>(
        () => _i258.SaveCategoryBudgetUseCase(gh<_i1021.BudgetRepository>()));
    gh.lazySingleton<_i502.SetMonthlyBudgetLimitUseCase>(() =>
        _i502.SetMonthlyBudgetLimitUseCase(gh<_i1021.BudgetRepository>()));
    gh.lazySingleton<_i852.AuthLocalDataSource>(
        () => _i852.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i425.BackupExportService>(() => _i425.BackupExportService(
          transactionDataSource: gh<_i371.TransactionLocalDataSource>(),
          accountDataSource: gh<_i688.AccountLocalDataSource>(),
          categoryDataSource: gh<_i390.CategoryLocalDataSource>(),
          budgetDataSource: gh<_i155.BudgetLocalDataSource>(),
          goalDataSource: gh<_i692.GoalLocalDataSource>(),
        ));
    gh.lazySingleton<_i585.SettingsBloc>(() => _i585.SettingsBloc(
          dataSource: gh<_i917.AppSettingsLocalDataSource>(),
          securityService: gh<_i337.SecurityService>(),
          backupExportService: gh<_i425.BackupExportService>(),
        ));
    gh.lazySingleton<_i468.PostLocalDataSource>(
        () => _i468.PostLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i706.AccountRepository>(() => _i126.AccountRepositoryImpl(
          gh<_i688.AccountLocalDataSource>(),
          gh<_i838.DashboardLocalDataSource>(),
        ));
    gh.factory<_i120.BudgetsBloc>(() => _i120.BudgetsBloc(
          getMonthlyBudgetSummaryUseCase:
              gh<_i1001.GetMonthlyBudgetSummaryUseCase>(),
          setMonthlyBudgetLimitUseCase:
              gh<_i502.SetMonthlyBudgetLimitUseCase>(),
          saveCategoryBudgetUseCase: gh<_i258.SaveCategoryBudgetUseCase>(),
          deleteCategoryBudgetUseCase: gh<_i279.DeleteCategoryBudgetUseCase>(),
        ));
    gh.factory<_i652.DashboardBloc>(
        () => _i652.DashboardBloc(gh<_i1062.GetDashboardSummaryUseCase>()));
    gh.factory<_i439.TransactionsBloc>(() => _i439.TransactionsBloc(
          getTransactionsUseCase: gh<_i974.GetTransactionsUseCase>(),
          createTransactionUseCase: gh<_i860.CreateTransactionUseCase>(),
          updateTransactionUseCase: gh<_i39.UpdateTransactionUseCase>(),
          deleteTransactionUseCase: gh<_i623.DeleteTransactionUseCase>(),
        ));
    gh.lazySingleton<_i589.IAuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i107.AuthRemoteDataSource>(),
          gh<_i852.AuthLocalDataSource>(),
        ));
    gh.lazySingleton<_i1044.AnalyticsRepository>(
        () => _i425.AnalyticsRepositoryImpl(
              gh<_i292.AnalyticsLocalDataSource>(),
              gh<_i371.TransactionLocalDataSource>(),
            ));
    gh.lazySingleton<_i126.CreateAccountUseCase>(
        () => _i126.CreateAccountUseCase(gh<_i706.AccountRepository>()));
    gh.lazySingleton<_i1063.DeleteAccountUseCase>(
        () => _i1063.DeleteAccountUseCase(gh<_i706.AccountRepository>()));
    gh.lazySingleton<_i297.GetAccountsUseCase>(
        () => _i297.GetAccountsUseCase(gh<_i706.AccountRepository>()));
    gh.lazySingleton<_i248.TransferFundsUseCase>(
        () => _i248.TransferFundsUseCase(gh<_i706.AccountRepository>()));
    gh.lazySingleton<_i927.UpdateAccountUseCase>(
        () => _i927.UpdateAccountUseCase(gh<_i706.AccountRepository>()));
    gh.lazySingleton<_i721.PostRepository>(() => _i328.PostRepositoryImpl(
          remoteDataSource: gh<_i887.PostRemoteDataSource>(),
          localDataSource: gh<_i468.PostLocalDataSource>(),
          networkInfo: gh<_i932.NetworkInfo>(),
        ));
    gh.factory<_i1041.NotificationsBloc>(() => _i1041.NotificationsBloc(
          dataSource: gh<_i156.NotificationSettingsLocalDataSource>(),
          notificationService: gh<_i941.NotificationService>(),
        ));
    gh.factory<_i103.AccountsBloc>(() => _i103.AccountsBloc(
          getAccountsUseCase: gh<_i297.GetAccountsUseCase>(),
          createAccountUseCase: gh<_i126.CreateAccountUseCase>(),
          updateAccountUseCase: gh<_i927.UpdateAccountUseCase>(),
          deleteAccountUseCase: gh<_i1063.DeleteAccountUseCase>(),
          transferFundsUseCase: gh<_i248.TransferFundsUseCase>(),
        ));
    gh.factory<_i157.GoalsBloc>(() => _i157.GoalsBloc(
          getGoalsSummaryUseCase: gh<_i1027.GetGoalsSummaryUseCase>(),
          createGoalUseCase: gh<_i353.CreateGoalUseCase>(),
          updateGoalUseCase: gh<_i929.UpdateGoalUseCase>(),
          deleteGoalUseCase: gh<_i70.DeleteGoalUseCase>(),
          addGoalContributionUseCase: gh<_i521.AddGoalContributionUseCase>(),
        ));
    gh.lazySingleton<_i431.CreateCategoryUseCase>(
        () => _i431.CreateCategoryUseCase(gh<_i266.CategoryRepository>()));
    gh.lazySingleton<_i1007.DeleteCategoryUseCase>(
        () => _i1007.DeleteCategoryUseCase(gh<_i266.CategoryRepository>()));
    gh.lazySingleton<_i76.GetCategoriesUseCase>(
        () => _i76.GetCategoriesUseCase(gh<_i266.CategoryRepository>()));
    gh.lazySingleton<_i656.UpdateCategoryUseCase>(
        () => _i656.UpdateCategoryUseCase(gh<_i266.CategoryRepository>()));
    gh.lazySingleton<_i17.GetCurrentUserUseCase>(
        () => _i17.GetCurrentUserUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i474.ResetPasswordUseCase>(
        () => _i474.ResetPasswordUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i713.SendPhoneOtpUseCase>(
        () => _i713.SendPhoneOtpUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i744.SignInWithEmailUseCase>(
        () => _i744.SignInWithEmailUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i915.SignOutUseCase>(
        () => _i915.SignOutUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i254.SignUpWithEmailUseCase>(
        () => _i254.SignUpWithEmailUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i1042.VerifyPhoneOtpUseCase>(
        () => _i1042.VerifyPhoneOtpUseCase(gh<_i589.IAuthRepository>()));
    gh.lazySingleton<_i405.GetAnalyticsDataUseCase>(
        () => _i405.GetAnalyticsDataUseCase(gh<_i1044.AnalyticsRepository>()));
    gh.factory<_i70.AnalyticsBloc>(() => _i70.AnalyticsBloc(
        getAnalyticsDataUseCase: gh<_i405.GetAnalyticsDataUseCase>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          getCurrentUserUseCase: gh<_i17.GetCurrentUserUseCase>(),
          signInWithEmailUseCase: gh<_i744.SignInWithEmailUseCase>(),
          signUpWithEmailUseCase: gh<_i254.SignUpWithEmailUseCase>(),
          sendPhoneOtpUseCase: gh<_i713.SendPhoneOtpUseCase>(),
          verifyPhoneOtpUseCase: gh<_i1042.VerifyPhoneOtpUseCase>(),
          resetPasswordUseCase: gh<_i474.ResetPasswordUseCase>(),
          signOutUseCase: gh<_i915.SignOutUseCase>(),
        ));
    gh.lazySingleton<_i803.GetPostsUseCase>(
        () => _i803.GetPostsUseCase(gh<_i721.PostRepository>()));
    gh.factory<_i601.PostBloc>(
        () => _i601.PostBloc(gh<_i803.GetPostsUseCase>()));
    gh.factory<_i78.CategoriesBloc>(() => _i78.CategoriesBloc(
          getCategoriesUseCase: gh<_i76.GetCategoriesUseCase>(),
          createCategoryUseCase: gh<_i431.CreateCategoryUseCase>(),
          updateCategoryUseCase: gh<_i656.UpdateCategoryUseCase>(),
          deleteCategoryUseCase: gh<_i1007.DeleteCategoryUseCase>(),
        ));
    return this;
  }
}

class _$ExternalModule extends _i464.ExternalModule {}

class _$RegisterModule extends _i667.RegisterModule {}
