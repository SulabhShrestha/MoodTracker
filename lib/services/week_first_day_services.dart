import 'package:shared_preferences/shared_preferences.dart';

class WeekFirstDayServices {
  Future<void> saveFirstDayOfWeek(String value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString("FirstDayOfWeek", value);
  }

  Future<String> getFirstDayOfWeek() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("FirstDayOfWeek") ?? "Monday";
  }
}
