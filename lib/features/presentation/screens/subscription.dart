import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/features/presentation/widgets/bottom_navigation.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:libro/features/presentation/widgets/onboarding_heading.dart';
import 'package:lottie/lottie.dart';

class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5),
              OnboardingHeading(
                title: 'Get Started Today!',
                subTitle:
                    'For borrowing books you need to purchase our membership...',
              ),
              Gap(20),
              CustomContainer(
                color: AppColors.color30,
                radius: BorderRadius.circular(18),
                shadow: 4,
                height: 250,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Gap(10),
                      Text(
                        'Why you buy one book when you can borrow unlimited?',
                        style: GoogleFonts.kalnia(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'For the price of just one book, unlock unlimited access to a world of physical books! No limits, no extra cost—just endless reading adventures. Read more, spend less! 🚀📖',
                              style: GoogleFonts.k2d(fontSize: 14),
                            ),
                          ),
                          Lottie.asset(
                            'lib/assets/Animation - 1742030119292.json',
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Gap(20),
              Text(
                'Membership Pricing',
                style: GoogleFonts.kalnia(fontSize: 22),
              ),
              Gap(10),

              _priceWidget(
                title: 'Basic Plan',
                price: '250',
                count: '2',
                image: 'lib/assets/Animation - 1742030119292.json',
              ),
              Gap(10),
              CustomContainer(
                height: 100,
                width: double.infinity,
                color: AppColors.color30,
                radius: BorderRadius.circular(18),
                shadow: 4,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advanced Plan',
                            style: GoogleFonts.kalnia(fontSize: 20),
                          ),
                          Text('- cost : 400rs'),
                          Text('- count of book : 4pcs'),
                        ],
                      ),
                      Lottie.asset(
                        'lib/assets/Animation - 1742030119292.json',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10),
              CustomContainer(
                height: 100,
                width: double.infinity,
                color: AppColors.color30,
                radius: BorderRadius.circular(18),
                shadow: 4,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pro Plan',
                            style: GoogleFonts.kalnia(fontSize: 20),
                          ),
                          Text('- cost : 600rs'),
                          Text('- count of book :6pcs'),
                        ],
                      ),
                      Lottie.asset(
                        'lib/assets/Animation - 1742030119292.json',
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              Gap(20),
              CustomLongButton(
                widget: Text('Confirm', style: TextStyle(fontSize: 20)),
                ontap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavigation()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceWidget({
    required String title,
    required String price,
    required String count,
    required String image,
  }) {
    return CustomContainer(
      height: 100,
      width: double.infinity,
      color: AppColors.color30,
      radius: BorderRadius.circular(18),
      shadow: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.kalnia(fontSize: 20)),
                Text('- cost : $price rs'),
                Text('- count of book :$count ps'),
              ],
            ),
            Lottie.asset(image, height: 150, fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}
