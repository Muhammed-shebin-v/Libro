import 'package:flutter/material.dart';
import 'package:libro/core/themes/fonts.dart';

class OnboardingHeading extends StatelessWidget {
  final String title;
  final String subTitle;
  const OnboardingHeading({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text(title, style: AppFonts.heading1), Text(subTitle)],
    );
  }
}
