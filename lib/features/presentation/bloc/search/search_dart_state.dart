import 'package:libro/features/data/models/book.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<BookModel> allBooks;
  final BookModel? selectedSearch;
  final bool showAvailableOnly;

  SearchLoaded(this.allBooks, {this.selectedSearch, this.showAvailableOnly = false});

  SearchLoaded copyWith({
    List<BookModel>? allBooks,
    BookModel? selectedSearch,
    bool? showAvailableOnly,
  }) {
    return SearchLoaded(
      allBooks ?? this.allBooks,
      selectedSearch: selectedSearch ?? this.selectedSearch,
      showAvailableOnly: showAvailableOnly ?? this.showAvailableOnly,
    );
  }

  List<BookModel> get filteredBooks {
    return showAvailableOnly
        ? allBooks.where((book) => book.isAvailable).toList()
        : allBooks;
  }
}



class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
}

class SortState extends SearchState {
  final String selectedSort;
  SortState(this.selectedSort);
}
