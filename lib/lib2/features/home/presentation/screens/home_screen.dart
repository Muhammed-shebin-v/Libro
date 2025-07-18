import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_model.dart';
import '../bloc/novels/novel_books_bloc.dart';
import '../bloc/novels/novel_books_state.dart';
import '../bloc/history_books/history_books_bloc.dart';
import '../bloc/history_books/history_books_state.dart';
import '../bloc/latest_books/books_bloc.dart';
import '../bloc/latest_books/books_state.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/custom_ad.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'score_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    getUserFromPrefs();
    _greeting = _getGreeting();
  }

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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      appBar: _buildAppBar(),
      body: FutureBuilder<UserModel?>(
        future: getUserFromPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No user found"));
          }
          final userData = snapshot.data!;
          log('${userData.imgUrl} image url');

          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildGreetingRow(userData),
                        const Gap(20),
                         CustomAd(),
                        const Gap(30),
                      ],
                    ),
                  ),
                  _buildBookSections(context, userData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.color60,
      automaticallyImplyLeading: false,
      title: Text(
        'Libro',
        style: GoogleFonts.k2d(fontSize: 30, letterSpacing: 5),
      ),
      leadingWidth: 40,
      actions:  [
        PushIconButton(nextScreen: ScoreScreen(), icon: Icon(Icons.score)),
        Gap(10),
      ],
    );
  }

  Widget _buildGreetingRow(UserModel userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Text(
            '$_greeting\n${userData.username}',
            style: AppFonts.mainHeading 
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
    );
  }

  Widget _buildBookSections(BuildContext context, UserModel userData) {
    return SizedBox(
      height: 850,
      child: Stack(
        children: [
          _buildHistoryBooks(context, userData),
          _buildTopAndNovelBooks(context, userData),
        ],
      ),
    );
  }

  Widget _buildHistoryBooks(BuildContext context, UserModel userData) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        height: 850,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: AppColors.color30,
          border: Border.all(),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(offset: const Offset(4, 4), color: AppColors.grey),
          ],
        ),
        child: BlocBuilder<HistoryBookBloc, HistoryBookState>(
          builder: (context, state) {
            if (state is HistoryBookLoading) {
              return const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
            } else if (state is HistoryBookError) {
              return const Center(child: Text('Error loading history books'));
            } else if (state is HistoryBookLoaded) {
              return BooksList(userId: userData.uid!, title: 'Best History Books', books: state.books);
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildTopAndNovelBooks(BuildContext context, UserModel userData) {
    return Positioned(
      top: 300,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 30),
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: AppColors.color60,
          border: Border.all(),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(offset: const Offset(-4, 4), color: AppColors.grey),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoading) {
                  return const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
                } else if (state is BookError) {
                  return const Center(child: Text('Error loading books'));
                } else if (state is BookLoaded) {
                  return BooksList(userId: userData.uid!, title: 'Top Books', books: state.books);
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
            BlocBuilder<NovelsBloc, NovelsState>(
              builder: (context, state) {
                if (state is NovelsLoading) {
                  return const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
                } else if (state is NovelsError) {
                  return const Center(child: Text('Error loading novels'));
                } else if (state is NovelsLoaded) {
                  return BooksList(userId: userData.uid!, title: 'Best Novels', books: state.books);
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PushIconButton extends StatelessWidget {
  final dynamic nextScreen;
  final Icon icon;
  const PushIconButton({super.key, required this.nextScreen, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen)),
      icon: icon,
    );
  }
}
