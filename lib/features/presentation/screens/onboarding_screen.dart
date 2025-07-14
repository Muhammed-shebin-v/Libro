import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionPageView extends StatefulWidget {
  const IntroductionPageView({super.key});

  @override
  State<IntroductionPageView> createState() => _IntroductionPageViewState();
}

class _IntroductionPageViewState extends State<IntroductionPageView> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: pageController,
                itemCount: listOfItems.length,
                onPageChanged: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 40, 15, 10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.5,

                        child: CustomAnimatedWidget(
                          index: index,
                          delay: 100,
                          child: Image.asset(listOfItems[index].img),
                        ),
                      ),
                      const Spacer(),
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomAnimatedWidget(
                          index: index,
                          delay: 300,
                          child: Text(
                            listOfItems[index].title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.k2d(
                              color: Colors.black,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: CustomAnimatedWidget(
                          index: index,
                          delay: 500,
                          child: Text(
                            listOfItems[index].subTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.k2d(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            Gap(20),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: listOfItems.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 6.0,
                      radius: 10.0,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      expansionFactor: 3.8,
                      dotColor: AppColors.color30,
                      activeDotColor: AppColors.color10,
                    ),
                    onDotClicked: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                        pageController.animateToPage(
                          newIndex,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      });
                    },
                  ),
                  const Spacer(),
                  currentIndex == 2
                      ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomLongButton(
                          ontap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LibroSubscriptionScreen2(),
                              ),
                            );
                          },
                          widget: Text('Get Started') ,
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomLongButton(
                          ontap: 
                         () {
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LibroSubscriptionScreen2(),
                              ),
                            );
                           
                          },
                          widget:Text('skip'), 
                        ),
                      ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class CustomAnimatedWidget extends StatelessWidget {
  final int index;
  final int delay;
  final Widget child;
  const CustomAnimatedWidget({
    super.key,
    required this.index,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (index == 1) {
      return FadeInDown(delay: Duration(milliseconds: delay), child: child);
    }
    return FadeInUp(delay: Duration(milliseconds: delay), child: child);
  }
}

class Items {
  final String img;
  final String title;
  final String subTitle;

  Items({required this.img, required this.title, required this.subTitle});
}

List<Items> listOfItems = [
  Items(
    img: "lib/assets/book 2.png",
    title: "Discover the best books for you",
    subTitle:
        "There are 25.000+ best books in this library, choose your choice now",
  ),
  Items(
    img: "lib/assets/book.png",
    title: "Share your reviews and rating to everyone",
    subTitle:
        "There will be many people who want hear your stories and experiences",
  ),
  Items(
    img: "lib/assets/IMG_0899.JPG",
    title: "Find more books and discover the world of reading",
    subTitle: "Make your friendship with books and grow up",
  ),
];
