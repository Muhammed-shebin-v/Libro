
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_bloc.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_event.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_state.dart';
import 'package:libro/features/presentation/screens/book_shelf.dart';
import 'package:libro/features/presentation/screens/home_screen.dart';
import 'package:libro/features/presentation/screens/qr_scanner.dart';
import 'package:libro/features/presentation/screens/search_screen.dart';
import 'package:libro/features/presentation/screens/user.dart';

class BottomNavigation extends StatelessWidget {

  BottomNavigation({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    QrScanner(),
    Bookshelf(),
    User(),

  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.selectedIndex],
            bottomNavigationBar: Container(
              color: AppColors.color60,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GNav(
                hoverColor: const Color.fromARGB(77, 0, 0, 0),
                rippleColor: const Color.fromARGB(35, 0, 0, 0),
                selectedIndex: state.selectedIndex,
                onTabChange: (index) {
                  context.read<BottomNavBloc>().add(TabChanged(index));
                },
                gap: 8,
                padding: EdgeInsets.all(16),
                backgroundColor:AppColors.color60,
                color: Colors.grey,
                activeColor: AppColors.color10,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.search,
                    text: 'search',
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: 'AI Chat',
                  ),
                  GButton(
                    icon: Icons.book,
                    text: 'Bookshelf',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'User',
                  ),
                ],
              ),
            ),
          );
        },
      )
      );
  }
}