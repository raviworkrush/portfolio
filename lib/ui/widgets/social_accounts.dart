import 'package:flutter/material.dart';
import 'package:me/data/utils/contants.dart';
import 'package:me/data/utils/ui_helpers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialAccounts extends StatelessWidget {
  final MainAxisAlignment alignment;
  const SocialAccounts({Key? key, this.alignment = MainAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(mainAxisAlignment: alignment, children: [
        IconButton(
            onPressed: () {
              launchURL(context, "tel://$kPhone");
            },
            icon: const Icon(
              FontAwesomeIcons.phone,
            )),
        IconButton(
            onPressed: () {
              launchURL(context, kGithub);
            },
            icon: const Icon(
              FontAwesomeIcons.github,
            )),
        IconButton(
            onPressed: () {
              launchURL(context, kLinkedIn);
            },
            icon: const Icon(
              FontAwesomeIcons.linkedin,
            )),
        IconButton(
            onPressed: () {
              launchURL(context, kInstagram);
            },
            icon: const Icon(
              FontAwesomeIcons.instagram,
            )),
        // IconButton(
        //     onPressed: () {
        //       launchURL(context, kTwitter);
        //     },
        //     icon: const Icon(
        //       FontAwesomeIcons.twitter,
        //     )),
        // IconButton(
        //     onPressed: () {
        //       launchURL(context, kEmail);
        //     },
        //     icon: const Icon(
        //       FontAwesomeIcons.envelope,
        //     )),
      ]),
    );
  }
}
