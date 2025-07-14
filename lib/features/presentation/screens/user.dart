import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/fetch_borrows/borrowed_dart_bloc.dart';
import 'package:libro/features/presentation/bloc/fetch_borrows/borrowed_dart_event.dart';
import 'package:libro/features/presentation/bloc/fetch_borrows/borrowed_dart_state.dart';
import 'package:libro/features/presentation/screens/settings.dart';
import 'package:libro/features/presentation/widgets/book.dart';
import 'package:libro/features/presentation/widgets/books_borrowed.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/library_timing.dart';
import 'package:libro/features/presentation/widgets/view_all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
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
      backgroundColor: const Color(0xFFFDF4DC),
      appBar: AppBar(
        backgroundColor: AppColors.color60,
        title: Text('Libro', style: GoogleFonts.k2d(fontSize: 30, letterSpacing: 5)),
        actions: [
          Gap(20),
          FutureBuilder<UserModel?>(
            future: getUserFromPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final user = snapshot.data!;
                return IconButton(
                  icon: const Icon(Icons.more_vert_outlined),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settings(
                          imgUrl: user.imgUrl!,
                          userName: user.username!,
                          uid: user.uid!,
                        ),
                      ),
                    );
                    if (result == true) setState(() {});
                  },
                );
              }
              return SizedBox();
            },
          ),
          Gap(20),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: getUserFromPrefs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Unable to load user data"));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  BoxShadow(color: AppColors.grey, offset: Offset(4, 4)),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(user.imgUrl!, fit: BoxFit.fill),
                              ),
                            ),
                            Gap(10),
                            Text(user.username!, style: AppFonts.heading1),
                          ],
                        ),
                        Gap(30),
                        viewAll(context),
                        Gap(10),
                        _buildBadges(),
                      ],
                    ),
                  ),
                  Gap(40),
                  _buildBorrowedBooksSection(user),
                  const LibraryTimingCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadges() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 30),
      decoration: BoxDecoration(
        color: AppColors.color10,
        border: Border.all(),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(offset: Offset(4, 4))],
      ),
      child: Align(
        alignment: Alignment.center,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => Gap(20),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset('lib/assets/badge.png', width: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildBorrowedBooksSection(UserModel user) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CustomContainer(
              color: AppColors.color30,
              radius: const BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              shadow: 4,
              width: MediaQuery.of(context).size.width * 0.95,
              child: BlocProvider(
                create: (_) => UserBorrowBloc()..add(LoadUserBorrowedBooks(user.uid!)),
                child: BlocBuilder<UserBorrowBloc, UserBorrowState>(
                  builder: (context, state) {
                    if (state is UserBorrowLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(100),
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is UserBorrowError) {
                      return Center(child: Text(state.message));
                    } else if (state is UserBorrowLoaded) {
                      final books = state.books;
                      if (books.isEmpty) {
                        return const Center(child: Text("No borrowed books found."));
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('  Borrowed Books', style: AppFonts.heading3),
                          Gap(10),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                final book = books[index];
                                final daysLeft = book.returnDate!.difference(DateTime.now()).inDays;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookBorrowedInfo(
                                          userData: user,
                                          bookData: book,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Book(color: book.color, image: book.imageUrls.first),
                                        Gap(5),
                                        SizedBox(
                                          width: 80,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(book.bookName, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                                              Text('₹${book.fine}', style: AppFonts.body2),
                                              Text('$daysLeft days left', style: AppFonts.body2),
                                              Container(
                                                height: 18,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFE8E8E8),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  book.status!,
                                                  textAlign: TextAlign.center,
                                                  style: AppFonts.body2,
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
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
