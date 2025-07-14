import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'package:libro/features/presentation/bloc/latest_review/latest_review_event.dart';
import 'package:libro/features/presentation/bloc/latest_review/latest_review_state.dart';

class LatestReviewBloc extends Bloc<LatestReviewEvent, LatestReviewState> {
  final BooksService _service = BooksService();
  LatestReviewBloc() : super(LatestReviewInitial()) {
    on<FetchReview>(_onFetchReviews);
  }

  Future<void> _onFetchReviews(FetchReview event, Emitter<LatestReviewState> emit) async {
    emit(LatestReviewLoading());
    try {
      final reviews = await _service.fetchLatestReview(event.bookId);
      emit(LatestReviewLoaded(reviews!));
    } catch (e) {
      emit(LatestReviewError("Failed to load reviews :$e"));
    }
  }
}

