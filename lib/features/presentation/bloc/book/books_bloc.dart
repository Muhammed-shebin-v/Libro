import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro/features/data/models/book.dart';
import 'package:libro/features/presentation/bloc/book/books_event.dart';
import 'package:libro/features/presentation/bloc/book/books_state.dart';
import 'package:libro/features/presentation/widgets/book.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
   
  final CollectionReference booksRef = FirebaseFirestore.instance.collection(
    'books',
  );

  BookBloc() : super(BookInitial()) {
    on<FetchBooks>(_onFetchBooks);
    on<SelectBook>(_onSelectBook);
    on<SearchBooks>(_onSearch);

  }

  Future<void> _onFetchBooks(FetchBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final snapshot = await booksRef.get();
      final bookList =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      emit(BookLoaded(bookList));
    } catch (e) {
      emit(BookError("Failed to fetch users: $e"));
    }
  }

  void _onSelectBook(SelectBook event, Emitter<BookState> emit) {
    if (state is BookLoaded) {
      final current = state as BookLoaded;
      emit(BookLoaded(current.books, selectedBook: event.book));
    }
  }
    
    
    Future<void> _onSearch(event, emit) async {
  if (event.query.trim().isEmpty) {
    emit(BookSearchInitial());
    return;
  }

  emit(BookSearchLoading());
  try {
    final query = event.query.toLowerCase();
    final booksSnap = await FirebaseFirestore.instance.collection('books').get();

    final results = booksSnap.docs
        .map((doc) => BookModel.fromMap(doc.data()))
        .where((book) =>
            book.bookName.toLowerCase().contains(query)||book.authorName.toLowerCase().contains(query)).toList();
    

    emit(BookSearchLoaded(results));
  } catch (e) {
    emit(BookSearchError('Error searching books: $e'));
  }
}

  }




