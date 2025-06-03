

import 'package:libro/features/data/models/book.dart';

abstract class SearchEvent {
   const SearchEvent();
}

class LoadBooks extends SearchEvent {
  const LoadBooks();
}

class SelectBook extends SearchEvent {
  final BookModel book;
  const SelectBook(this.book);
}





class LoadBooksAlphabetical extends SearchEvent {
  const LoadBooksAlphabetical();
}
class LoadBooksLatest extends SearchEvent {
  const LoadBooksLatest();
}
class SortChanged extends SearchEvent {
  final String newSort;
  SortChanged(this.newSort);
}

class UploadSearchEvent extends SearchEvent {
  final String title;
  UploadSearchEvent(this.title);
}
class LoadBooksByCategory extends SearchEvent {
  final String categoryName;
  LoadBooksByCategory(this.categoryName);
}
class SearchBooks extends SearchEvent {
  final String query;
  SearchBooks(this.query);
}
