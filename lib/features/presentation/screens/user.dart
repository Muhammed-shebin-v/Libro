import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/bloc/borrowed_dart_bloc.dart';
import 'package:libro/features/presentation/screens/book_info.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/screens/settings.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/book.dart';
import 'package:libro/features/presentation/widgets/books_borrowed.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/view_all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatelessWidget {
  User({super.key});

  @override
  Widget build(BuildContext context) {
    Future<UserModel?> getUserFromPrefs() async {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');
      if (uid == null) return null;
      return UserModel(
        uid: uid,
        username: prefs.getString('username') ?? '',
        fullName: prefs.getString('fullName') ?? '',
        email: prefs.getString('email') ?? '',
        phoneNumber: prefs.getString('phone') ?? '',
        address: prefs.getString('address') ?? '',
        imgUrl: prefs.getString('imgUrl') ?? '',
        createdAt: prefs.getString('createdAt') ?? '',
        score: prefs.getInt('score') ?? 0,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDF4DC),
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        leading: Image(image: AssetImage('lib/assets/IMG_0899 2.JPG')),
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
          Gap(20),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
            icon: Icon(Icons.more_vert_outlined),
          ),
          Gap(20),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: getUserFromPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No user found"));
          }
          final userData = snapshot.data!;
          log(userData.imgUrl.toString());
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.grey,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  userData.imgUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    userData.username,
                                    style: AppFonts.heading1,
                                  ),
                                  Text(
                                    '12 Books Borrowed',
                                    style: AppFonts.body2,
                                  ),
                                  Gap(5),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.color10,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(offset: Offset(1, 1)),
                                      ],
                                    ),
                                    width: 90,
                                    child: Text(
                                      userData.score.toString(),
                                      textAlign: TextAlign.center,
                                      style: AppFonts.body2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(30),
                        viewAll(context),
                        Gap(5),
                        Container(
                          height: 100,
                          padding: EdgeInsets.only(left: 30),
                          decoration: BoxDecoration(
                            color: AppColors.color10,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [BoxShadow(offset: Offset(4, 4))],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Gap(20);
                              },
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 5,
                                  ),
                                  child: Image(
                                    image: AssetImage('lib/assets/badge.png'),
                                    width: 50,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(40),
                  SizedBox(
                    height: 800,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: CustomContainer(
                            color: AppColors.color30,
                            radius: BorderRadius.only(
                              topRight: Radius.circular(25),
                            ),
                            shadow: 4,
                            height: 800,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Column(
                              children: [
                                BlocProvider(
                                  create:
                                      (_) =>
                                          UserBorrowBloc()..add(
                                            LoadUserBorrowedBooks(userData.uid),
                                          ),
                                  child: BlocBuilder<
                                    UserBorrowBloc,
                                    UserBorrowState
                                  >(
                                    builder: (context, state) {
                                      if (state is UserBorrowLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state is UserBorrowError) {
                                        return Center(
                                          child: Text(state.message),
                                        );
                                      } else if (state is UserBorrowLoaded) {
                                        final books = state.books;
                                        if (books.isEmpty) {
                                          return const Center(
                                            child: Text(
                                              "No borrowed books found.",
                                            ),
                                          );
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '  Borrowed Books',
                                              style: AppFonts.heading3,
                                            ),
                                            Gap(10),
                                            SizedBox(
                                              height: 220,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: books.length,
                                                itemBuilder: (context, index) {
                                                  final borrowedbook =
                                                      books[index];
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
                                                                (
                                                                  context,
                                                                ) => BookBorrowedInfo(
                                                                  userid:
                                                                      userData
                                                                          .uid,
                                                                  book: borrowedbook,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Book(
                                                            color: Color(
                                                              0xFFE8E8E8,
                                                            ),
                                                            image:borrowedbook.imageUrls[0]

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
                                                                  borrowedbook
                                                                      .bookName,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                ),
                                                                Text(
                                                                  borrowedbook
                                                                      .authorName,
                                                                  style:
                                                                      AppFonts
                                                                          .body2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Container(
                                                                  height: 18,
                                                                  width: 80,
                                                                  decoration: BoxDecoration(
                                                                    color: Color(
                                                                      0xFFE8E8E8,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                  ),
                                                                  child: Text(
                                                                    borrowedbook
                                                                        .category,
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
                                      }
                                      return const Center(
                                        child: Text("No borrowed books found."),
                                      );
                                    },
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 30,
                                    left: 20,
                                  ),
                                  child: BooksList(
                                    title: 'Borrowed Books',
                                    books: books,
                                    images: images,
                                    authors: authors,
                                    gonores: gonores,
                                    // colors: colors,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 580,
                          right: 0,
                          child: CustomContainer(
                            color: AppColors.color60,
                            radius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                            ),
                            shadow: -4,
                            height: 220,
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Center(child: Text('Graph')),
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
    );
  }

  final List<String> categories = [
    'Politics',
    'Sports',
    'Technology',
    'Science',
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
