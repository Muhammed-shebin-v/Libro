import 'package:libro/features/data/models/review_model.dart';

abstract class LatestReviewState {}

class LatestReviewInitial extends LatestReviewState {}

class LatestReviewLoading extends LatestReviewState  {}

class LatestReviewLoaded extends LatestReviewState  {
  final ReviewModel latestReview;
  LatestReviewLoaded(this.latestReview);
}

class LatestReviewError extends LatestReviewState  {
  final String message;
  LatestReviewError(this.message);
}
