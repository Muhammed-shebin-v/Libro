

import 'package:libro/features/data/models/book.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<BookModel> searchs;
  final BookModel? selectedSearch;

  const SearchLoaded(this.searchs, {this.selectedSearch});

  SearchLoaded copyWith({
    List<BookModel>? searchs,
    BookModel? selectedSearch,
  }) {
    return SearchLoaded(
      searchs ?? this.searchs,
      selectedSearch: selectedSearch ?? this.selectedSearch,
    );
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
