import 'package:share_plus/share_plus.dart';

class ShareViewModel {
  void shareApp() {
    String text = 'Check out this cool mood tracking app!';
    String url = 'https://later.com';
    Share.share('$text $url');
  }
}
