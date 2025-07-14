import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/bloc/search/search_dart_bloc.dart';
import 'package:libro/features/presentation/bloc/search/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/search/search_dart_state.dart';
import 'package:libro/features/presentation/screens/book_info.dart';
import 'package:libro/features/presentation/widgets/category_button.dart';
import 'package:libro/features/presentation/widgets/search_bar.dart';
import 'package:libro/features/presentation/widgets/sort_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedSort;
  String? _selectedCategory;
  List<String> _categoryOptions = [];
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    getUserFromPrefs();
    fetchCategoryNames();
  }

  Future<void> getUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    if (uid != null) {
      userData = UserModel(
        uid: uid,
        username: prefs.getString('username') ?? '',
        imgUrl: prefs.getString('imgUrl') ?? '',
      );
      log('Fetched user data in search screen');
    }
  }

  Future<void> fetchCategoryNames() async {
    try {
      final catSnap = await FirebaseFirestore.instance.collection('categories').get();
      _categoryOptions = catSnap.docs.map((doc) => doc.data()['name'] as String).toList();
      log('Loaded categories');
    } catch (e) {
      log('Error fetching category names: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const CustomSearchBar(),
              const Gap(10),
              _buildFilters(),
              const Gap(20),
              _buildSearchResults(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title:  Text('Search Books',style: AppFonts.heading2,),
      centerTitle: false,
      backgroundColor: AppColors.color60,
    );
  }

  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            return CustomCategoryDropdown(
              selectedCategory: _selectedCategory,
              categoryOptions: _categoryOptions,
              onCategoryChanged: (String newValue) {
                context.read<SearchBloc>().add(CategoryFilterChanged(newValue));
              },
            );
          },
        ),
        const Gap(10),
        CustomSortDropdown(
          selectedSort: _selectedSort,
          onSortChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _selectedSort = newValue);
              context.read<SearchBloc>().add(SortChanged(newValue));
            }
          },
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Expanded(
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded && state.allBooks.isNotEmpty) {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: state.allBooks.length,
              itemBuilder: (context, index) {
                final book = state.allBooks[index];
                return _buildBookTile(book);
              },
            );
          } else if (state is SearchError) {
            return const Center(child: Text('Error'));
          } else {
            return const Center(child: Text('No Book Found!'));
          }
        },
      ),
    );
  }

  Widget _buildBookTile(dynamic book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookInfo(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book.bookName, style: AppFonts.body3),
                Text(book.authorName, style: AppFonts.body2),
                const Gap(10),
                Container(
                  height: 18,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(book.category, textAlign: TextAlign.center, style: AppFonts.body2),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${book.readers} readers', style: AppFonts.body2),
                Text('${book.pages} pages', style: AppFonts.body2),
                const Gap(10),
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: book.currentStock > 0
                            ? AppColors.green
                            : AppColors.secondary,
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    const Gap(5),
                    Text(
                      book.currentStock > 0 ? 'available' : 'out of stock',
                      style: AppFonts.body3,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
