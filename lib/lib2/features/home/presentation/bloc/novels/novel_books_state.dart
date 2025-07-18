import 'package:libro/features/data/models/book.dart';

abstract class NovelsState {}

class NovelsInitial extends NovelsState {}

class NovelsLoading extends NovelsState {}

class NovelsLoaded extends NovelsState {
  final List<BookModel> books;
  NovelsLoaded(this.books);
}

class NovelsError extends NovelsState {
  final String message;
  NovelsError(this.message);
}
