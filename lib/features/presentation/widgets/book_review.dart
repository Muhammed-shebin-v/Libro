import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/bloc/latest_review/latest_review_bloc.dart';
import 'package:libro/features/presentation/bloc/latest_review/latest_review_event.dart';
import 'package:libro/features/presentation/bloc/latest_review/latest_review_state.dart';
import 'package:libro/features/presentation/bloc/history_books/history_books_bloc.dart';
import 'package:libro/features/presentation/bloc/history_books/history_books_state.dart';
import 'package:libro/features/presentation/screens/home_screen.dart';
import 'package:libro/features/presentation/widgets/books_list.dart';
import 'package:libro/features/presentation/widgets/container.dart';
import 'package:libro/features/presentation/widgets/rating_stars.dart';
import 'package:libro/features/presentation/widgets/review_bottom.dart';

class BookReview extends StatelessWidget {
  final String bookId;
  const BookReview({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LatestReviewBloc()..add(FetchReview(bookId)),
      child: Positioned(
        top: 480,
        right: 0,
        child: CustomContainer(
          color: AppColors.color60,
          radius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          shadow: -4,
          width: MediaQuery.of(context).size.width * 0.95,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                BlocBuilder<HistoryBookBloc, HistoryBookState>(
                  builder: (context, state) {
                    if (state is HistoryBookLoaded) {
                      return BooksList(
                        title: 'like this',
                        books: state.books,
                        userId: bookId,
                      );
                    }
                    return Text('error');
                  },
                ),
                BlocBuilder<LatestReviewBloc, LatestReviewState>(
                  builder: (context, state) {
                    if (state is LatestReviewLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is LatestReviewLoaded) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'User reviews',
                              style: AppFonts.heading3,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0,
                                  offset: Offset(3, 3),
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  child:
                                      state.latestReview.userImage.isNotEmpty
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                            child: Image.network(
                                              state.latestReview.userImage,
                                            ),
                                          )
                                          : Icon(Icons.person),
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.latestReview.userName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          
                                          StarRating(
                                            rating: state.latestReview.rating,
                                          ),
                                        ],
                                      ),
                                      Text(
                                            DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                state.latestReview.date,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                      const SizedBox(height: 4),
                                      Text(
                                        state.latestReview.reviewText,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Show more'),
                              IconButton(
                                onPressed: () {
                                  showReviewBottomSheet(context, bookId);
                                },
                                icon: Icon(Icons.arrow_downward),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (state is LatestReviewError) {
                      return Center(
                        child: TextButton.icon(
                          label: Text('No review yet'),
                          icon: Icon(Icons.info_outline_rounded),
                          onPressed: () {},
                        ),
                      );
                    } else {
                      return Center(child: Text('Something went wrong'));
                    }
                  },
                ),
                Gap(10),

                // BooksList(
                //   title: 'More Like This',
                //   books: books,
                //   images: images,
                //   authors: authors,
                //   gonores: gonores,
                //   // colors: colors,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
