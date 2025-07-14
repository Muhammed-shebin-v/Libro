import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/my_books/my_books_bloc.dart';
import 'package:libro/features/presentation/bloc/my_books/my_books_event.dart';
import 'package:libro/features/presentation/bloc/my_books/my_books_state.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_event.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_state.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/wishlist_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bookshelf extends StatelessWidget {
  Bookshelf({super.key});

  final String _formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

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
    return Scaffold(
      backgroundColor: AppColors.color60,
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
          log(userData.imgUrl.toString());

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(userData),
                  const Gap(30),
                  _buildCompletedBooks(userData),
                  const Gap(30),
                  _buildEmptyPlaceholder(),
                  const Gap(40),
                  _buildWishlist(userData, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(UserModel userData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(offset: Offset(2, 2))],
              image: const DecorationImage(
                image: AssetImage('lib/assets/calcifer.jpg'),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello ${userData.username}', style: AppFonts.heading2),
              Text(_formattedDate, style: AppFonts.body1),
            ],
          ),
          const Gap(60),
        ],
      ),
    );
  }

  Widget _buildCompletedBooks(UserModel userData) {
    return BlocProvider(
      create: (_) => MyBooksBloc()..add(LoadMyBooks(userData.uid!)),
      child: BlocBuilder<MyBooksBloc, MyBooksState>(
        builder: (context, state) {
          if (state is MyBooksLoading) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            );
          } else if (state is MyBooksError) {
            return Center(child: Text(state.message));
          } else if (state is MyBooksLoaded) {
            if (state.books.isEmpty) {
              return const Center(child: Text("No borrowed books found."));
            }
            return BooksList(title: 'Completed Books', books: state.books, userId: userData.uid!);
          }
          return const Center(child: Text("No completed books found."));
        },
      ),
    );
  }

  Widget _buildEmptyPlaceholder() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.color10,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [BoxShadow(offset: Offset(3, 3))],
      ),
    );
  }

  Widget _buildWishlist(UserModel userData, BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: CustomContainer(
        width: MediaQuery.of(context).size.width * 0.95,
        color: AppColors.color30,
        radius: const BorderRadius.only(
          topRight: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        shadow: 3,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocProvider(
            create: (_) => WishlistBloc()..add(FetchWishlist(userData.uid!)),
            child: BlocBuilder<WishlistBloc, WishlistState>(
              builder: (context, state) {
                if (state is WishlistLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WishlistError) {
                  return const Center(child: Text('Error loading wishlist'));
                } else if (state is WishlistLoaded) {
                  return WishlistList(
                    title: 'Wishlist Books',
                    books: state.wishlist,
                    userId: userData.uid!,
                  );
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
