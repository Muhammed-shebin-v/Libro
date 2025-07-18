import 'package:libro/features/data/models/book.dart';

abstract class HistoryBookState {}

class HistoryBookInitial extends HistoryBookState {}

class HistoryBookLoading extends HistoryBookState {}

class HistoryBookLoaded extends HistoryBookState {
  final List<BookModel> books;
  HistoryBookLoaded(this.books);
}

class HistoryBookError extends HistoryBookState {
  final String message;
  HistoryBookError(this.message);
}


