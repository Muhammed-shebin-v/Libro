import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'package:libro/features/presentation/bloc/latest_books/books_event.dart';
import 'package:libro/features/presentation/bloc/latest_books/books_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BooksService _bookService = BooksService();

  BookBloc() : super(BookInitial()) {
    on<FetchBooks>(_onFetchBooks);
  }

  Future<void> _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());

    try {
      final bookList = await _bookService.fetchAllBooks();
      emit(BookLoaded(bookList));
    } catch (e) {
      emit(BookError("Failed to fetch books: $e"));
      log(e.toString());
    }
  }

}
