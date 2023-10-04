import 'package:mood_tracker/services/local_storage_service.dart';

class LocalStorageViewModel {
  final LocalStorageServices _localStorageServices = LocalStorageServices();

  Future<bool> isAppLaunchedFirstTime() async {
    return await _localStorageServices.isAppLaunchedFirstTime();
  }

  /// Will automatically set the app launched first time to true
  Future<void> setIsAppLaunchedFirstTime() async {
    await _localStorageServices.setIsAppLaunchedFirstTime();
  }
}
