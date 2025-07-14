import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/review_model.dart';
import 'package:libro/features/presentation/bloc/reviews/review_bloc.dart';
import 'package:libro/features/presentation/bloc/reviews/review_event.dart';
import 'package:libro/features/presentation/bloc/reviews/review_state.dart';
import 'package:libro/features/presentation/widgets/rating_stars.dart';

void showReviewBottomSheet(BuildContext context, String bookId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.color30,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder:
        (_) => BlocProvider(
          create: (_) => ReviewsBloc()..add(FetchReviews(bookId)),
          child: const ReviewBottomSheet(),
        ),
  );
}

class ReviewBottomSheet extends StatelessWidget {
  const ReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.color10,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ReviewsBloc, ReviewsState>(
                builder: (context, state) {
                  if (state is ReviewsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ReviewsLoaded &&
                      state.reviews.isNotEmpty) {
                    return ListView.builder(
                      controller: controller,
                      itemCount: state.reviews.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final review = state.reviews[index];
                        return buildReviewItem(review);
                      },
                    );
                  } else if (state is ReviewsError) {
                    return Center(child: Text(state.message));
                  } else if (state is ReviewsLoaded && state.reviews.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No reviews yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildReviewItem(ReviewModel review) {
    // final formattedDate =
    // DateFormat('MMM dd, yyyy – hh:mm a').format(review.date);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:  AppColors.color60,
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
                review.userImage.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(review.userImage),
                    )
                    : Icon(Icons.person),
          ),

          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    
                    StarRating(rating: review.rating)
                  ],
                ),
                Text(
                     DateFormat('dd-MM-yyyy').format(DateTime.parse(review.date)),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                const SizedBox(height: 4),
                Text(review.reviewText, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
