import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/data/models/review_model.dart';
import 'package:libro/features/domain/services/books_service.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final _reviewService = BooksService();
  ReviewBloc() : super(ReviewInitial()) {
    on<AddReviewEvent>(_onAddReview);
  }


Future<void> _onAddReview(
  AddReviewEvent event,
  Emitter<ReviewState> emit,
) async {
  emit(ReviewLoading());

  try {
    await _reviewService.addReview(
      bookId: event.bookId,
      reviewData: event.review.toMap(),
    );

    emit(ReviewSuccess());
  } catch (e) {
    emit(ReviewError(e.toString()));
  }
}

}
