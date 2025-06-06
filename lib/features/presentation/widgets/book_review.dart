import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/container.dart';

class BookReview extends StatelessWidget {
  const BookReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 480,
      right: 0,
      child: CustomContainer(
        color: AppColors.color60,
        radius: BorderRadius.only(topLeft: Radius.circular(20)),
        shadow: -4,
        width: MediaQuery.of(context).size.width * 0.95,

        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('User reviews', style: AppFonts.heading3),
              ),
              Gap(10),
              CustomContainer(
                color: AppColors.color10,
                radius: BorderRadius.circular(15),
                shadow: -3,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 4),
                              ],
                              image: DecorationImage(
                                image: AssetImage('lib/assets/calcifer.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Gap(5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Paul Walker', style: AppFonts.body1),
                              Text('1d ago', style: AppFonts.body2),
                            ],
                          ),
                        ],
                      ),
                      Gap(5),
                      Text(
                        'Atomic Habits"by James Clear is a transformative guide on building good habits and breaking bad ones.',
                        style: GoogleFonts.k2d(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show more'),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
              Gap(10),
              // BooksList(
              //   title: 'More Like This',
              //   books: books,
              //   images: images,
              //   authors: authors,
              //   gonores: gonores,
              //   // colors: colors,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
