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
    
    
    

  }




