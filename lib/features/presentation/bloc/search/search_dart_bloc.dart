import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:libro/features/domain/services/serach_service.dart';
import 'package:libro/features/presentation/bloc/search/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/search/search_dart_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final _searchService = SearchService();
  SearchBloc() : super(SearchInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SelectBook>(_onSelectBook);
    on<LoadBooksAlphabetical>(_loadAlphabetical);
    on<LoadBooksAlphabeticalDesc>(_loadAlphabeticalDesc);
    on<LoadBooksLatest>(_loadLatest);
    on<LoadBooksOldest>(_loadOldest);
    on<SortChanged>(_sortchanged);
    on<CategoryFilterChanged>(_onFilterByCategory);
    on<SearchBooks>(_onSearchBooks);
    on<ToggleAvailabilityFilter>(_onToggleAvailabilityFilter);
  }
Future<void>_onToggleAvailabilityFilter(ToggleAvailabilityFilter event, Emitter<SearchState> emit)async
 {
  if (state is SearchLoaded) {
    final current = state as SearchLoaded;
    emit(current.copyWith(showAvailableOnly: !current.showAvailableOnly));
  }
}




  Future<void> _onLoadBooks(LoadBooks event, Emitter<SearchState> emit) async {
  emit(SearchLoading());
  try {
    final bookList = await _searchService.loadBooks();
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      bookList,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError("Failed to fetch books: $e"));
  }
}


  void _onSelectBook(SelectBook event, Emitter<SearchState> emit) {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(selectedSearch: event.book));
    }
  }

 Future<void> _loadAlphabetical(
  LoadBooksAlphabetical event,
  Emitter<SearchState> emit,
) async {
  emit(SearchLoading());
  try {
    final books = await _searchService.loadAlphabetical();
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      books,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError('Failed to load books'));
  }
}


 Future<void> _loadAlphabeticalDesc(
  LoadBooksAlphabeticalDesc event,
  Emitter<SearchState> emit,
) async {
  emit(SearchLoading());
  try {
    final books = await _searchService.loadAlphabeticDesc();
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      books,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError('Failed to load books'));
  }
}

Future<void> _loadLatest(
  LoadBooksLatest event,
  Emitter<SearchState> emit,
) async {
  emit(SearchLoading());
  try {
    final books = await _searchService.loadLatestBooks();
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      books,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError('Failed to load books: $e'));
  }
}

Future<void> _loadOldest(
  LoadBooksOldest event,
  Emitter<SearchState> emit,
) async {
  emit(SearchLoading());
  try {
    final books = await _searchService.loadOldestBooks();
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      books,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError('Failed to load books: $e'));
  }
}

Future<void> _sortchanged(
  SortChanged event,
  Emitter<SearchState> emit,
) async {
  emit(SortState(event.newSort));

  switch (event.newSort) {
    case 'Alphabetical ↑':
      add(LoadBooksAlphabetical());
      break;
    case 'Alphabetical ↓':
      add(LoadBooksAlphabeticalDesc());
      break;
    case 'Latest':
      add(LoadBooksLatest());
      break;
    case 'Oldest':
      add(LoadBooksOldest());
      break;
  }
}

Future<void> _onFilterByCategory(
  CategoryFilterChanged event,
  Emitter<SearchState> emit,
) async {
  emit(SearchLoading());
  try {
    final books = await _searchService.filterBooksByCategory(
      event.selectedCategory,
    );
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      books,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError('Failed to load category books: $e'));
  }
}

Future<void> _onSearchBooks(
  SearchBooks event,
  Emitter<SearchState> emit,
) async {
  if (event.query.isEmpty) {
    add(LoadBooks());
    return;
  }

  emit(SearchLoading());

  try {
    final results = await _searchService.searchBooks(event.query);
    final current = state is SearchLoaded ? state as SearchLoaded : null;
    emit(SearchLoaded(
      results,
      showAvailableOnly: current?.showAvailableOnly ?? false,
    ));
  } catch (e) {
    emit(SearchError('Error searching books: $e'));
  }
}

}
