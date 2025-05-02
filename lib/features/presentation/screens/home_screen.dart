import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/presentation/bloc/book/books_bloc.dart';
import 'package:libro/features/presentation/bloc/book/books_state.dart';
import 'package:libro/features/presentation/screens/book_info.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/screens/score_screen.dart';
import 'package:libro/features/presentation/widgets/book.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/custom_ad.dart';
import 'package:libro/features/presentation/widgets/search_bar.dart';
import 'package:lottie/lottie.dart';

// pading fo rbooks
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF4DC),
      appBar: AppBar(
        backgroundColor: Color(0xFFFDF4DC),
        leading: Image(image: AssetImage('lib/assets/IMG_0899 3.JPG')),
        title: Text(
          'Libro',
          style: GoogleFonts.k2d(fontSize: 30, letterSpacing: 5),
        ),
        leadingWidth: 40,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QrScanner()),
              );
            },
            icon: Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScoreScreen()),
              );
            },
            icon: Icon(Icons.score),
          ),
          Gap(10),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                            'Good   Morning\nSarah John',
                            style: GoogleFonts.kalnia(fontSize: 30),
                          ),
                        ),
                        Expanded(
                          child: Lottie.asset(
                            'lib/assets/Animation - 1742030119292.json',
                            height: 160,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    CustomSearchBar(),
                    Gap(40),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: Image(
                                  fit: BoxFit.fill,
                                  image: AssetImage(images[index]),
                                  width: 50,
                                  height: 70,
                                ),
                              ),
                              Gap(10),
                              Text(gonores[index]),
                            ],
                          );
                        },
                      ),
                    ),
                    Gap(10),
                    CustomAd(),
                    Gap(30),
                  ],
                ),
              ),
              SizedBox(
                height: 850,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 30, left: 20),
                        height: 850,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEDAA1),
                          border: Border.all(),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(offset: Offset(4, 4), color: Colors.grey),
                          ],
                        ),
                        child: BooksList(
                          title: 'Books of The Week',
                          books: books,
                          authors: authors,
                          images: images,
                          gonores: gonores,
                          colors: colors,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 300,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 30),
                        height: 550,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF4DC),
                          border: Border.all(),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-4, 4),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Column(

//new htings

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<BookBloc, BookState>(
                              builder: (context, state) {
                                if (state is BookLoading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state is BookError) {
                                  return Center(child: Text('error'));
                                } else if (state is BookLoaded) {
                                  final book = state.books;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Latest Added',
                                        style: AppFonts.heading3,
                                      ),
                                      Gap(10),
                                      SizedBox(
                                        height: 220,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: book.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) => BookInfo(
                                                            book: book[index],
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Book(
                                                      image: images[index],
                                                      color: colors[index],
                                                    ),
                                                    Gap(5),
                                                    SizedBox(
                                                      width: 80,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        spacing: 5,
                                                        children: [
                                                          Text(
                                                            book[index]['bookname'],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                          Text(
                                                            book[index]['authername'],
                                                            style:
                                                                AppFonts.body2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Container(
                                                            height: 18,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0xFFE8E8E8,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Text(
                                                              book[index]['category'],
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style:
                                                                  AppFonts
                                                                      .body2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(child: Text('not known'));
                                }
                              },
                            ),
                            BooksList(
                              title: 'Most Read',
                              books: books,
                              authors: authors,
                              images: images,
                              gonores: gonores,
                              colors: colors,
                            ),
                          ],
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
