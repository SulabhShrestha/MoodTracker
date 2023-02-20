// ignore_for_file: unnecessary_this

extension StringExtension on String {
  String get capitalize {
    List<String> words = this.trim().split(' ');
    for (int i = 0; i < words.length; i++) {
      String word = words[i];
      words[i] =
          word.substring(0, 1).toUpperCase() + word.substring(1).toLowerCase();
    }

    return words.join(' ');
  }
}
