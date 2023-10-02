import 'dart:developer';

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

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      log('Error launching email client: $e');
    }
  }
}
