import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomAd extends StatefulWidget {
  const CustomAd({super.key});

  @override
  State<CustomAd> createState() => _CustomAdState();
}

class _CustomAdState extends State<CustomAd> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 205, 95, 21),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                blurRadius: 0,
                offset: Offset(3, 3),
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: PageView(
              controller: _pageController,
              children: [
                _buildPage(
                  image: 'lib/assets/IMG_0899 3.JPG',
                  title: 'Latest Books',
                  subtitle: '',
                ),
                _buildPage(
                  image: 'lib/assets/IMG_0899 3.JPG',
                  title: 'Harry potter',
                  subtitle: 'harry potter books sets are now availabl',
                ),
                _buildPage(
                  image: 'lib/assets/IMG_0899 3.JPG',
                  title: 'Title 3',
                  subtitle: 'Subtitle 3',
                ),
                _buildPage(
                  image: 'lib/assets/IMG_0899 3.JPG',
                  title: 'Title 4',
                  subtitle: 'Subtitle 4',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: 4,
          effect: ExpandingDotsEffect(
            activeDotColor: Colors.blue,
            dotColor: Colors.grey,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPage({required String image, required String title, required String subtitle}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          image,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.2),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}