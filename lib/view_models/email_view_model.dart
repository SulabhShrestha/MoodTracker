import 'package:url_launcher/url_launcher.dart';

/// Handles related to email

class EmailViewModel {
  Future<void> openEmailClient(String subject) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'mailme@sulabhstha.com.np',
      queryParameters: {
        'subject': subject,
      },
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch email client';
    }
  }
}
