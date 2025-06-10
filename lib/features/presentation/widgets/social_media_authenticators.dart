import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SocialMediaAuthenticators extends StatelessWidget {
  final bool signin;
  const SocialMediaAuthenticators({super.key,this.signin=false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: const Color.fromARGB(255, 0, 0, 0),
                thickness: 1,
                endIndent: 10,
              ),
            ),
            Text('or Sign ${signin?'In':'Up'} with'),
            Expanded(
              child: Divider(
                color: const Color.fromARGB(255, 0, 0, 0),
                thickness: 1,
                indent: 10,
              ),
            ),
          ],
        ),
        Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.g_mobiledata)),
              IconButton(onPressed: () {}, icon: Icon(Icons.apple)),
              IconButton(onPressed: () {}, icon: Icon(Icons.facebook)),
            ],
          ),
        ),
      ],
    );
  }
}
