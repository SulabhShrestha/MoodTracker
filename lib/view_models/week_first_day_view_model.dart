import 'package:mood_tracker/services/week_first_day_services.dart';

class WeekFirstDayViewModel {
  final _weekFirstDayServices = WeekFirstDayServices();

  Future<void> saveFirstDayOfWeek(String value) async {
    await _weekFirstDayServices.saveFirstDayOfWeek(value);
  }

  Future<String> getFirstDayOfWeek() async {
    return await _weekFirstDayServices.getFirstDayOfWeek();
  }
}
