import 'package:shared_preferences/shared_preferences.dart';

class FirstDayOfWeekModel {
  String _firstDay = '';

  String get firstDayOfWeek => _firstDay;

  Future<void> saveFirstDayOfWeek(String value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("FirstDayOfWeek", value);
  }

  Future<String> getFirstDayOfWeek() async {
    var prefs = await SharedPreferences.getInstance();
    _firstDay = prefs.getString("FirstDayOfWeek") ?? "Monday";

    return _firstDay;
  }
}
