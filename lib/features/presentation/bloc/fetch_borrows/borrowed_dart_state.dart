import 'package:libro/features/data/models/book.dart';

abstract class UserBorrowState {}

class UserBorrowInitial extends UserBorrowState {}

class UserBorrowLoading extends UserBorrowState {}

class UserBorrowLoaded extends UserBorrowState {
  final List<BookModel> books;
  UserBorrowLoaded(this.books);
}

class UserBorrowError extends UserBorrowState {
  final String message;
  UserBorrowError(this.message);
}