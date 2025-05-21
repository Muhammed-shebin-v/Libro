import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_bloc.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_state.dart';
import 'package:libro/features/presentation/widgets/books_borrowed.dart';

class SearchScreen extends StatelessWidget {
   SearchScreen({super.key});
 final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: SafeArea(child: 
      Column(
        children: [
          Stack(
            children: [
              Column(
          children: [
            // Your search bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                onChanged: (query) {
                  context.read<SearchBloc>().add(SearchBooks(query));
                },
                decoration: InputDecoration(
                  hintText: "Search books...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // Rest of your page content (if any)
          ],
              ),
          
              // Overlayed search result box
             
            ],
          ),
        ],
      ),
),  
    );
  }
}