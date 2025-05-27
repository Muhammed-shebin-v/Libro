import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/domain/repository/borrow.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';

class BookBorrowedInfo extends StatefulWidget {
  final BookModel book;
  final String userid;
  const BookBorrowedInfo({super.key, required this.book, required this.userid});

  @override
  State<BookBorrowedInfo> createState() => _BoookState();
}

class _BoookState extends State<BookBorrowedInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        actions: [
          IconButton(
            onPressed: () {
              BorrowService().borrowBook(
                userId: widget.userid,
                bookId: widget.book.uid!,
                context: context,
              );
            },
            icon: Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [

              Gap(20),

              SizedBox(
                height: 980,
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
                        height: 850,
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
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.book.bookName,
                                    style: AppFonts.body1,
                                  ),
                                  Text(widget.book.authorName),
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
                                            Text(
                                              '${widget.book.pages} • ${widget.book.category}',
                                            ),
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
                                    widget.book.description,
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
                                        Text(widget.book.location),
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
                    SizedBox(
                      height: 220,
                      child: PageView.builder(
                        itemCount: widget.book.imageUrls.length,
                        controller: PageController(viewportFraction: 0.8),
                        itemBuilder: (context, index) {
                          final selectedImage = widget.book.imageUrls[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100.0,
                            ),
                            child: Container(
                              width: 10,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  selectedImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
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
