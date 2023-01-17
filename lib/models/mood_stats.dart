class MoodStats {
  final int rating;
  int occurrence;
  double percentage; // % repeat out of 100

  MoodStats(
      {required this.occurrence,
      required this.rating,
      required this.percentage});
}
