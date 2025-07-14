import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';

class LibraryTimingCard extends StatelessWidget {
  const LibraryTimingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.color10, 
            AppColors.color30, 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_filled,
              size: 40, color: AppColors.black),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                'Library Timings',
                style: AppFonts.heading2
                ),
              Gap(4),
              Text(
                'Monday – Saturday',
                style: AppFonts.body1
              ),
              Text(
                '9:00 AM – 8:00 PM',
                style: AppFonts.body2
              ),
            ],
          )
        ],
      ),
    );
  }
}
