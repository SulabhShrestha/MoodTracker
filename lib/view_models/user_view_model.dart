import 'package:flutter/foundation.dart';
import 'package:mood_tracker/services/user_web_services.dart';

class UserViewModel extends ChangeNotifier {
  final _userWebServices = UserWebServices();
  Future<void> updateUserName(String name) async {
    await _userWebServices.updateUserName(name);
    notifyListeners();
  }

  String get getUserName {
    return _userWebServices.getUserName;
  }
}
