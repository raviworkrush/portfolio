import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension StringExtension on String {
  bool validateName() {
    return RegExp(r'^([a-z A-Z,.\-]).{2,24}$').hasMatch(this);
  }
}

void showMessage(BuildContext context, String title, String message,
    [void Function()? onPressed]) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.orange),
            ),
            backgroundColor: Colors.black,
            title: Text(title, textAlign: TextAlign.center),
            content: Text(message, textAlign: TextAlign.center),
            actions: <Widget>[
              ElevatedButton(
                onPressed: onPressed ??
                    () {
                      Navigator.of(context).pop();
                    },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56.0),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: Text(
                  'Okay!',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              )
            ],
          ));
}

void launchURL(BuildContext context, String url) async {
  await launchUrl(
    Uri.parse(url),
  );
}
