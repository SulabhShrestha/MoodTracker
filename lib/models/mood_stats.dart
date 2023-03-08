class MoodStats {
  final int rating;
  int occurrence;
  double percentage; // % repeat out of 100

  MoodStats(
      {required this.occurrence,
      required this.rating,
      required this.percentage});

  String get feeling {
    if (rating == 1) {
      return "Terrible";
    } else if (rating == 2) {
      return "Upset";
    } else if (rating == 3) {
      return "Okay";
    } else if (rating == 4) {
      return "Good";
    } else {
      return "Excited";
    }
  }
}
