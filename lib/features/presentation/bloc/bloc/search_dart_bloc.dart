import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_state.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchBooks>(_onSearchBooks);

  }
  Future<void> _onSearchBooks(event, emit) async {
  if (event.query.isEmpty) {
    emit(SearchInitial());
    return;
  }

  emit(SearchLoading());
  try {
    final query = event.query.toLowerCase();
    final booksSnap = await FirebaseFirestore.instance.collection('books').get();

    final results = booksSnap.docs
        .map((doc) => BookModel.fromMap(doc.data()))
        .where((book) =>
            book.bookName.toLowerCase().contains(query)||book.authorName.toLowerCase().contains(query)).toList();
    

    emit(SearchLoaded(results));
  } catch (e) {
    emit(SearchError('Error searching books: $e'));
  }
}
  
}

