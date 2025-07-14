import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/domain/services/books_service.dart';
import 'package:libro/features/presentation/bloc/fetch_borrows/borrowed_dart_event.dart';
import 'package:libro/features/presentation/bloc/fetch_borrows/borrowed_dart_state.dart';


class UserBorrowBloc extends Bloc<UserBorrowEvent, UserBorrowState> {
   final BooksService _borrowService = BooksService();
  UserBorrowBloc() : super(UserBorrowInitial()) {

on<LoadUserBorrowedBooks>((event, emit) async {
  emit(UserBorrowLoading());
  try {
    final books = await _borrowService.fetchUserBorrowedBooks(event.userId);
    emit(UserBorrowLoaded(books));
  } catch (e) {
    emit(UserBorrowError('Failed to load borrowed books: $e'));
    log(e.toString());
  }
});
  }
}
