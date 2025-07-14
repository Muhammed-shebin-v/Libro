import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'package:libro/features/presentation/bloc/novels/novel_books_event.dart';
import 'package:libro/features/presentation/bloc/novels/novel_books_state.dart';

class NovelsBloc extends Bloc<NovelsEvent, NovelsState> {
  final BooksService _bookService = BooksService();

  NovelsBloc() : super(NovelsInitial()) {
    on<NovelsFetchBooks>(_onNovelsFetchBooks);
  }

  Future<void> _onNovelsFetchBooks(
    NovelsFetchBooks event,
    Emitter<NovelsState> emit,
  ) async {
    emit(NovelsLoading());

    try {
      final bookList = await _bookService.fetchNovelBooks();
      emit(NovelsLoaded(bookList));
    } catch (e) {
      emit(NovelsError("Failed to fetch novels: $e"));
      log(e.toString());
    }
  }
}
