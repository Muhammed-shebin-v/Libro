import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/large_book.dart';

class Boook extends StatefulWidget {
  const Boook({super.key});

  @override
  State<Boook> createState() => _BoookState();
}

class _BoookState extends State<Boook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Gap(20),

              SizedBox(
                height: 1060,
                child: Stack(
                  children: [
                    Positioned(
                      top: 150,
                      left: 0,
                      child: CustomContainer(
                        color: AppColors.color30,
                        radius: BorderRadius.only(
                          topRight: Radius.circular(25),
                        ),
                        shadow: 4,
                        height: 910,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.share),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.bookmark,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      136,
                                      0,
                                    ),
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                            Gap(60),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'The Way of the Nameless',
                                    style: AppFonts.body1,
                                  ),
                                  Text('Graham Douglass'),
                                  CustomContainer(
                                    color: AppColors.color60,
                                    radius: BorderRadius.circular(25),
                                    shadow: 3,
                                    height: 50,
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('4.6 *'),
                                        VerticalDivider(color: Colors.black),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Available  '),
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      7,
                                                      255,
                                                      36,
                                                    ),
                                                    border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          25,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text('196 pages • Fictional'),
                                          ],
                                        ),
                                        VerticalDivider(color: Colors.black),
                                        Text(
                                          '1k+\nreaders',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(20),
                                  Text(
                                    'Atomic Habits"by James Clear is a transformative guide on building good habits and breaking bad ones. It explores how small, consistent changes lead to remarkable results over time. Using science-backed strategies, Clear explains the power of habit formation.',
                                    style: GoogleFonts.k2d(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Gap(10),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_pin),
                                        Text('1st floor,1A shelf,4th row'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.05, -0.95),
                      child: BookLarge(
                        image: 'lib/assets/images.jpeg',
                        color: Colors.teal,
                      ),
                    ),
                    Positioned(
                      top: 580,
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
                                child: Text(
                                  'User reviews',
                                  style: AppFonts.heading3,
                                ),
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                ),
                                              ],
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'lib/assets/calcifer.jpg',
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Gap(5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Paul Walker',
                                                style: AppFonts.body1,
                                              ),
                                              Text(
                                                '1d ago',
                                                style: AppFonts.body2,
                                              ),
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
                              BooksList(
                                title: 'More Like This',
                                books: books,
                                images: images,
                                authors: authors,
                                gonores: gonores,
                                // colors: colors,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> books = [
    'The Design of Books',
    'My Book cover',
    'A Teaspoon Earth',
    'The Graphic Design Bible',
    'The Way of the Nameless',
  ];
  final List<String> images = [
    'lib/assets/images.png',
    'lib/assets/book-covers-big-2019101610.jpg',
    'lib/assets/images.jpeg',
    'lib/assets/71ng-giA8bL._AC_UF1000,1000_QL80_.jpg',
    'lib/assets/teal-and-orange-fantasy-book-cover-design-template-056106feb952bdfb7bfd16b4f9325c11.jpg',
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
