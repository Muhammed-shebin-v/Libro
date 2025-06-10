import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/screens/home_screen.dart';
import 'package:libro/features/presentation/widgets/book.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';

class Bookshelf extends StatelessWidget {
  Bookshelf({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(offset: Offset(2, 2))],
                        image: DecorationImage(
                          image: AssetImage('lib/assets/calcifer.jpg'),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text('Hello Sarah', style: TextStyle(fontSize: 30)),
                        Text('Today 5 March'),
                      ],
                    ),
                    Gap(60),
                  ],
                ),
                Gap(30),
                BooksList(
                  title: 'My Books',
                  books:dummybooks
                  // colors: colors,
                ),
                Gap(20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.color10,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        offset: Offset(3, 3),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                Gap(20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.color30,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0,
                        offset: Offset(3, 3),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
                Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContainer(
                      color: AppColors.color30,
                      radius: BorderRadius.circular(25),
                      shadow: 3,
                      height: MediaQuery.of(context).size.width * 0.43,
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: 0.3,
                                  ),
                                ),
                                Text('March 5 books'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    CustomContainer(
                      color: AppColors.color30,
                      radius: BorderRadius.circular(25),
                      shadow: 3,
                      height: MediaQuery.of(context).size.width * 0.43,
                      width: MediaQuery.of(context).size.width * 0.43,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                    value: 0.3,
                                  ),
                                ),
                                Text('March 5 books'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Wishlisted Books', style: TextStyle(fontSize: 25)),
                    Row(
                      children: [Text('View all'), Icon(Icons.arrow_forward)],
                    ),
                  ],
                ),
                Gap(20),
                SizedBox(
                  height: 1000,
                  child: ListView.separated(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 20),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        height: 160,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 35,
                              left: 0,
                              right: 0,
                              child: CustomContainer(
                                color: AppColors.color30,
                                radius: BorderRadius.circular(15),
                                shadow: 3,
                                height: 100,
                                width: MediaQuery.of(context).size.width * 0.95,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.28,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'The way of Nameless',
                                          style: AppFonts.body1,
                                        ),
                                        Text(
                                          'Author name',
                                          style: AppFonts.body1,
                                        ),
                                        Text(
                                          '196 pages•1000readers•4.3+rating',
                                        ),
                                        Text(categories[index]),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 30,
                              child: Book(
                                color: AppColors.color30,
                                image:
                                    'https://marketplace.canva.com/EAGEuNwgF3k/1/0/1003w/canva-modern-and-simple-prayer-journal-book-cover-UL8kCB4ONE8.jpg',

                                // color: const Color.fromARGB(255, 231, 52, 52),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final List<String> categories = [
    'All',
    'History',
    'Science',
    'Politics',
    'Sports',
  ];

  final List<String> books = [
    'The Design of Books',
    'My Book cover',
    'A Teaspoon Earth',
    'The Graphic Design Bible',
    'The Way of the Nameless',
  ];

  final List<String> images = [
    'https://marketplace.canva.com/EAGEuNwgF3k/1/0/1003w/canva-modern-and-simple-prayer-journal-book-cover-UL8kCB4ONE8.jpg',
    'https://marketplace.canva.com/EAGEuNwgF3k/1/0/1003w/canva-modern-and-simple-prayer-journal-book-cover-UL8kCB4ONE8.jpg',
    'https://marketplace.canva.com/EAGEuNwgF3k/1/0/1003w/canva-modern-and-simple-prayer-journal-book-cover-UL8kCB4ONE8.jpg',
    'https://marketplace.canva.com/EAGEuNwgF3k/1/0/1003w/canva-modern-and-simple-prayer-journal-book-cover-UL8kCB4ONE8.jpg',
    'https://marketplace.canva.com/EAGEuNwgF3k/1/0/1003w/canva-modern-and-simple-prayer-journal-book-cover-UL8kCB4ONE8.jpg',
  ];
  final List<String> authors = [
    'Bebble Benze',
    'My name',
    'Dina Nayeri',
    'Theio Iglis',
    'Graham Douglass ',
  ];
  final List<String> gonores = [
    'Architecture',
    'History',
    'Biodata',
    'Novel',
    'Fictional',
  ];
  final colors = [
    Colors.red,
    const Color.fromARGB(255, 238, 70, 41),
    const Color.fromARGB(255, 10, 167, 195),
    const Color.fromARGB(255, 248, 108, 53),
    const Color.fromARGB(255, 216, 112, 181),
  ];
}
