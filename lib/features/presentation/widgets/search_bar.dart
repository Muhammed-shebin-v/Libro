import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/presentation/bloc/book/books_bloc.dart';
import 'package:libro/features/presentation/bloc/book/books_event.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: SearchBar(
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.all(
          const Color.fromARGB(255, 223, 220, 220),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        leading: Icon(Icons.search),
        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 15)),
        trailing: [Icon(Icons.filter_list)],
        onChanged: (query) {
                  context.read<BookBloc>().add(SearchBooks(query));
                },
      ),
    );
  }
}
