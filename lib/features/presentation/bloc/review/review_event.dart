part of 'review_bloc.dart';


abstract class ReviewEvent {}

class AddReviewEvent extends ReviewEvent {
  final String bookId;
  final ReviewModel review;

  AddReviewEvent({required this.bookId, required this.review});
}
