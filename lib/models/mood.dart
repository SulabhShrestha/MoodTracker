class Mood {
  final int rating;
  final String date;
  final String? why;
  final String? feedback;
  // TODO: image url later to be added

  Mood({
    required this.rating,
    required this.date,
    this.why,
    this.feedback,
  });

  factory Mood.fromJSON(Map<String, dynamic> json) {
    return Mood(
      rating: json["rating"],
      date: json["date"],
      why: json["why"],
      feedback: json["feedback"],
    );
  }
}
