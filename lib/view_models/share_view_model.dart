import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

class ShareViewModel {
  void shareApp() {
    String text = 'Check out this cool mood tracking app!';
    String url =
        'https://play.google.com/store/apps/details?id=com.sulabhstha.mood_tracker';
    Share.share('$text $url');
  }

  Future<void> rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    inAppReview.openStoreListing(appStoreId: 'com.sulabhstha.mood_tracker');
  }
}
