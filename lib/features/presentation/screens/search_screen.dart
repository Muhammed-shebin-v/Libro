import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_bloc.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_state.dart';
import 'package:libro/features/presentation/screens/book_info.dart';
import 'package:libro/features/presentation/widgets/search_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  String? _selectedSort;
  final List<String> _sortOptions = ['Alphabetical', 'Latest'];
  Future<void> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid == null){
    userData =  UserModel(
      uid: uid,
      username: prefs.getString('username') ?? '',
      imgUrl: prefs.getString('imgUrl') ?? '',
    );
    }
  }

  UserModel? userData;

  @override
  Widget build(BuildContext context) {
    getUserFromPrefs();
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              CustomSearchBar(),
              Gap(10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                  
                      context.read<SearchBloc>().add(
                        LoadBooksByCategory('tech'),
                      );
                    },
                    icon: const Icon(Icons.filter_list),
                    label: const Text('Categories'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  Gap(10),
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return DropdownButton<String>(
                          underline: const SizedBox(),
                          hint: Text(_selectedSort ?? 'Sort by'),
                          value: _selectedSort,
                          items:
                              _sortOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _selectedSort = newValue;
                              context.read<SearchBloc>().add(
                                SortChanged(newValue),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return  Expanded(child: SizedBox(child:Center(child: CircularProgressIndicator())));
                  } else if (state is SearchLoaded &&
                      state.searchs.isNotEmpty) {
                    final books = state.searchs;
                    return Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Gap(5),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => BookInfo(
                                        book: book,
                                        userid: userData!.uid!,
                                      ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      book.imageUrls.first,
                                      width: 50,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(book.bookName),
                                    Text(book.authorName),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text('error'));
                  } else {
                    return Expanded(child: SizedBox(child: Center(child: Text('No Book Found!'))));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
