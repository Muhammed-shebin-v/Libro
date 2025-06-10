import 'package:flutter/material.dart';

class SwitchingButtom extends StatelessWidget {
  final dynamic onpressed;
  final String text;
  const SwitchingButtom({
    super.key,
    required this.onpressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onpressed,
        child: Text(
          text,
          style: TextStyle(color: const Color.fromARGB(255, 159, 163, 174)),
        ),
      ),
    );
  }
}
