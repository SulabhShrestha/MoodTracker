import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  Future<bool> isAppLaunchedFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool status = prefs.getBool('isAppLaunchedFirstTime') ?? true;
    return status;
  }

  Future<void> setIsAppLaunchedFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAppLaunchedFirstTime', false);
  }
}
