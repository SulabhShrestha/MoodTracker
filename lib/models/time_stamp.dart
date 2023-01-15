/// This is helper class that makes
/// converted millisecondsSinceEpoch to "XX:XX PM" format easier
///
import 'package:intl/intl.dart';

class TimeStamp {
  final int timestamp;

  TimeStamp(this.timestamp);

  String get toHumanFormat {
    var datetime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final format = DateFormat("h:mm a");
    var formatted = format.format(datetime);

    return formatted;
  }
}
