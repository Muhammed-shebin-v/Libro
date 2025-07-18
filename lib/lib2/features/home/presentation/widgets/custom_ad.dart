import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ad/ad_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomAd extends StatelessWidget {
   CustomAd({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdBloc, AdState>(
      builder: (context, state) {
        if (state is AdLoaded && state.list.isNotEmpty) {
          final ads = state.list;

          return Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: const Color.fromARGB(255, 205, 95, 21),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 0,
                      offset: Offset(3, 3),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];
                      return _buildPage(
                        image: ad.imgUrl,
                        title: ad.title,
                        subtitle: ad.content,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SmoothPageIndicator(
                controller: _pageController,
                count: ads.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                ),
              ),
            ],
          );
        } else if (state is AdLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const SizedBox(); // fallback UI if loading or error
        }
      },
    );
  }

  Widget _buildPage({required String image, required String title, required String subtitle}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          image,
          fit: BoxFit.fill,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
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
