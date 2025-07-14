import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'package:libro/features/presentation/bloc/my_books/my_books_event.dart';
import 'package:libro/features/presentation/bloc/my_books/my_books_state.dart';

class MyBooksBloc extends Bloc<MyBooksEvent, MyBooksState> {
  final BooksService _borrowService = BooksService();
  MyBooksBloc() : super(MyBooksInitial()) {
    on<LoadMyBooks>(_onLoadMyReturnedBooks);
  }

  Future<void> _onLoadMyReturnedBooks(
    LoadMyBooks event,
    Emitter<MyBooksState> emit,
  ) async {
    emit(MyBooksLoading());

    try {
      final books = await _borrowService.fetchReturnedBooksByUser(event.userId);
      emit(MyBooksLoaded(books));
    } catch (e) {
      log("MyBooksBloc error: $e");
      emit(MyBooksError('Failed to load returned books.'));
    }
  }
}
