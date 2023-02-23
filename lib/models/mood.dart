import 'time_stamp.dart';

class Mood {
  final int rating;
  final String date;
  final TimeStamp timestamp;
  final String? why;
  final String? feedback;
  final List<dynamic> imagesPath;

  Mood({
    required this.rating,
    required this.date,
    required this.timestamp,
    required this.imagesPath,
    this.why,
    this.feedback,
  });

  factory Mood.fromJSON(Map<String, dynamic> json) {
    return Mood(
      rating: json["rating"],
      date: json["date"],
      why: json["why"],
      feedback: json["feedback"],
      timestamp: TimeStamp(json["timestamp"]),
      imagesPath: json["imagesPath"],
    );
  }
}
