import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/book/books_bloc.dart';
import 'package:libro/features/presentation/bloc/book/books_state.dart';
import 'package:libro/features/presentation/screens/book_info.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/screens/score_screen.dart';
import 'package:libro/features/presentation/widgets/book.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/custom_ad.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

// UserModel? userGlobal;

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<UserModel?> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid == null) return null;
    return UserModel(
      uid: uid,
      username: prefs.getString('username') ?? '',
      imgUrl: prefs.getString('imgUrl') ?? '',
      score: prefs.getInt('score') ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserFromPrefs();
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        // leading: Image(image: AssetImage('lib/assets/IMG_0899 3.JPG')),
        automaticallyImplyLeading: false,
        title: Text(
          'Libro',
          style: GoogleFonts.k2d(fontSize: 30, letterSpacing: 5),
        ),
        leadingWidth: 40,
        actions: [
          PushIconButton(nextScreen: QrScanner(), icon: Icon(Icons.qr_code)),
          PushIconButton(nextScreen: ScoreScreen(), icon: Icon(Icons.score)),
          Gap(10),
        ],
      ),

      body: FutureBuilder<UserModel?>(
        future: getUserFromPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("No user found"));
          }
          final userData = snapshot.data!;
          log(userData.imgUrl.toString());
          return SingleChildScrollView(
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
                                'Good Morning\n${userData.username}',
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

                        // Gap(40),
                        // SizedBox(
                        //   height: 100,
                        //   child: ListView.builder(
                        //     scrollDirection: Axis.horizontal,
                        //     itemCount: books.length,
                        //     itemBuilder: (context, index) {
                        //       return Column(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //               horizontal: 15.0,
                        //             ),
                        //             child: Image(
                        //               fit: BoxFit.fill,
                        //               image: AssetImage(imagescat[index]),
                        //               width: 50,
                        //               height: 70,
                        //             ),
                        //           ),
                        //           Gap(10),
                        //           Text(gonores[index]),
                        //         ],
                        //       );
                        //     },
                        //   ),
                        // ),
                        // Gap(10),
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
                            padding: EdgeInsets.only(top: 30),
                            height: 850,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              color: AppColors.color30,
                              border: Border.all(),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(4, 4),
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                            //dfddfdfdfdfdfddfdfdf
                            child: BooksList(
                              title: '  Books of The Week',
                              books: dummybooks,
                              // colors: colors,
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
                              color: AppColors.color60,
                              border: Border.all(),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(-4, 4),
                                  color: AppColors.grey,
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
                                      return Center(
                                        child: Text('error ygyggy'),
                                      );
                                    } else if (state is BookLoaded) {
                                      final books = state.books;

                                      return BooksList(
                                        title: 'Latest Books',
                                        books: books,
                                      );
                                    } else {
                                      return Center(child: Text('not known'));
                                    }
                                  },
                                ),

                                BooksList(
                                  title: '  Most Read',
                                  books: dummybooks,
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
          );
        },
      ),
    );
  }
}

final List<BookModel> dummybooks = [
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: [''],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: [''],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: [''],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
  BookModel(
    bookName: 'new',
    bookId: 'bookId',
    authorName: 'authorName',
    description: 'description',
    category: 'category',
    pages: 200,
    stocks: 2,
    location: 'location',
    imageUrls: [''],
    uid: 'uid',
    currentStock: 2,
    color: Color(0x0fffffff),
    readers: 7,
  ),
];

class PushIconButton extends StatelessWidget {
  final nextScreen;
  final Icon icon;
  const PushIconButton({
    super.key,
    required this.nextScreen,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      icon: icon,
    );
  }
}
