import 'package:flutter/material.dart';

class TermsAndConditios extends StatelessWidget {
  const TermsAndConditios({super.key,});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Text(
        'you agree to our terms and conditions',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color.fromARGB(255, 159, 163, 174),
          fontSize: 12,
        ),
      ),
    );
  }
}
