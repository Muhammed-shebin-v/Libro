import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {

  SearchBloc() : super(SearchInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<SelectBook>(_onSelectBook);
    on<LoadBooksAlphabetical>(_loadAlphabetical);
    on<LoadBooksLatest>(_loadLatest);
    on<SortChanged>(_sortchanged);
    on<LoadBooksByCategory>(_onLoadBooksByCategory);
    on<SearchBooks>(_onSearchBooks);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();
      final bookList = snapshot.docs.map((e) => BookModel.fromMap(e.data())).toList();
      emit(SearchLoaded(bookList));
    } catch (e) {
      emit(SearchError("Failed to fetch users: $e"));
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
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .orderBy('bookName')
              .get();

      final books = snapshot.docs.map((doc) =>  BookModel.fromMap(doc.data())).toList();
      emit(SearchLoaded(books));
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
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .orderBy('date', descending: true)
              .get();

      final books = snapshot.docs.map((doc) =>  BookModel.fromMap(doc.data())).toList();
      emit(SearchLoaded(books));
    } catch (e) {
      emit(SearchError('Failed to load books'));
    }
  }

  Future<void> _sortchanged(
    SortChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(SortState(event.newSort));
    if (event.newSort == 'Alphabetical') {
      add(LoadBooksAlphabetical());
    } else if (event.newSort == 'Latest') {
      add(LoadBooksLatest());
    }
  }

  Future<void> _onLoadBooksByCategory(
    LoadBooksByCategory event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .where('category', isEqualTo: event.categoryName)
              .get();
      final books = snapshot.docs.map((doc) =>  BookModel.fromMap(doc.data())).toList();
      log(books.toString());
      emit(SearchLoaded(books));
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
    }

    emit(SearchLoading());
    try {
      final query = event.query.toLowerCase();
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();
      final results =
          snapshot.docs.map((doc) => BookModel.fromMap(doc.data())).toList().where((data) {
            final bookName = (data.bookName).toString().toLowerCase();
            final authorName =
                (data.authorName).toString().toLowerCase();
            return bookName.contains(query) || authorName.contains(query);
          }).toList();
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError('Error searching books: $e'));
    }
  }
}
