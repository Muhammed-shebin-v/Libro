import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'package:libro/features/presentation/bloc/history_books/history_books_event.dart';
import 'package:libro/features/presentation/bloc/history_books/history_books_state.dart';

class HistoryBookBloc extends Bloc<HistoryBookEvent, HistoryBookState> {
  final BooksService _bookService = BooksService();

  HistoryBookBloc() : super(HistoryBookInitial()) {
    on<HistoryFetchBooks>(_onHistoryFetchBooks);
  }

  Future<void> _onHistoryFetchBooks(HistoryFetchBooks event, Emitter<HistoryBookState> emit) async {
    emit(HistoryBookLoading());

    try {
      final bookList = await _bookService.fetchHistoryBooks();
      emit(HistoryBookLoaded(bookList));
    } catch (e) {
      emit(HistoryBookError("Failed to fetch books: $e"));
      log(e.toString());
    }
  }

}
