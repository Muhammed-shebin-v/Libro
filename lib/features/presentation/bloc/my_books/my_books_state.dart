import 'package:libro/features/data/models/book.dart';

abstract class MyBooksState {}

class MyBooksInitial extends MyBooksState {}

class MyBooksLoading extends MyBooksState {}

class MyBooksLoaded extends MyBooksState {
  final List<BookModel> books;
  MyBooksLoaded(this.books);
}

class MyBooksError extends MyBooksState {
  final String message;
  MyBooksError(this.message);
}