import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhanra_new/core/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@module
abstract class ExternalModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}

@InjectableInit(
  preferRelativeImports: true,
)
Future<void> configureDependencies() async => getIt.init();
