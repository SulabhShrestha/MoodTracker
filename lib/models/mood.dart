import 'time_stamp.dart';

class Mood {
  final int rating;
  final String date;
  final TimeStamp timestamp;
  final List<dynamic> imagesPath;
  final String? why;
  final String? feedback;
  final String?
      keywordIncludesIn; // Later used only in Result page for highlighting the text

  Mood(
      {required this.rating,
      required this.date,
      required this.timestamp,
      required this.imagesPath,
      this.why,
      this.feedback,
      this.keywordIncludesIn});

  factory Mood.fromJSON(Map<String, dynamic> json,
      {String? keywordIncludesIn}) {
    return Mood(
      rating: json["rating"],
      date: json["date"],
      why: json["why"],
      feedback: json["feedback"],
      timestamp: TimeStamp(json["timestamp"]),
      imagesPath: json["imagesPath"],
      keywordIncludesIn: keywordIncludesIn,
    );
  }
}
