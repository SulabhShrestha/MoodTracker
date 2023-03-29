import 'package:flutter/material.dart';

Widget doYouWantToExit(BuildContext context) {
  return AlertDialog(
    title: const Text('Confirm'),
    content: const Text('Are you sure you want to close this screen?'),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('No'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Yes'),
      ),
    ],
  );
}

Widget noInternetConnection(BuildContext context) {
  return AlertDialog(
    title: const Text('No Internet connection'),
    content: const Text('App might not work as intended. '),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('OK'),
      ),
    ],
  );
}
