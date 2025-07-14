// lib/features/presentation/bloc/reviews/review_event.dart
abstract class LatestReviewEvent {}

class FetchReview extends LatestReviewEvent {
  final String bookId;
  FetchReview(this.bookId);
}
