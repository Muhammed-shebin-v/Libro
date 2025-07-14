import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewsBloc extends Bloc<ReviewsEvent, ReviewsState> {
  final BooksService _service = BooksService();
  ReviewsBloc() : super(ReviewsInitial()) {
    on<FetchReviews>(_onFetchReviews);
  }

  Future<void> _onFetchReviews(FetchReviews event, Emitter<ReviewsState> emit) async {
    emit(ReviewsLoading());
    try {
      final reviews = await _service.fetchReviews(event.bookId);
      emit(ReviewsLoaded(reviews));
    } catch (e) {
      emit(ReviewsError("Failed to load reviews"));
    }
  }
}
