import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/domain/repository/borrow.dart';
import 'package:libro/features/presentation/widgets/book_carousal.dart';
import 'package:libro/features/presentation/widgets/book_details.dart';
import 'package:libro/features/presentation/widgets/book_review.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';

class BookInfo extends StatefulWidget {
  final BookModel book;
  final String userid;
  const BookInfo({super.key, required this.book, required this.userid});

  @override
  State<BookInfo> createState() => _BoookState();
}

class _BoookState extends State<BookInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        shadowColor: AppColors.color60,
        actions: [
          IconButton(
            onPressed: () {
              BorrowService().borrowBook(
                userId: widget.userid,
                bookId: widget.book.uid,
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
                            CustomBookDetails(book: widget.book),

                            BookCarousal(book: widget.book),

                            BookReview(),
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
