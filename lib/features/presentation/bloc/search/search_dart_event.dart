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
class ToggleAvailabilityFilter extends SearchEvent {}

class LoadBooksAlphabetical extends SearchEvent {
  const LoadBooksAlphabetical();
}
class LoadBooksAlphabeticalDesc extends SearchEvent{
  const LoadBooksAlphabeticalDesc();
}

class LoadBooksLatest extends SearchEvent {
  const LoadBooksLatest();
}
class LoadBooksOldest extends SearchEvent{
  const LoadBooksOldest();
}
class CategoryFilterChanged extends SearchEvent {
  final String selectedCategory;
  CategoryFilterChanged(this.selectedCategory);
}

class SortChanged extends SearchEvent {
  final String newSort;
  SortChanged(this.newSort);
}

class UploadSearchEvent extends SearchEvent {
  final String title;
  UploadSearchEvent(this.title);
}



class SearchBooks extends SearchEvent {
  final String query;
  SearchBooks(this.query);
}
