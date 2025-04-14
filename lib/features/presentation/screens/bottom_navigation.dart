import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_bloc.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_event.dart';
import 'package:libro/features/presentation/bloc/bottom_navigation/bottom_navigtion_state.dart';
import 'package:libro/features/presentation/screens/book_details.dart';
import 'package:libro/features/presentation/screens/book_shelf.dart';
import 'package:libro/features/presentation/screens/home_screen.dart';
import 'package:libro/features/presentation/screens/user.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final List<Widget> _pages = [
    HomeScreen(),
    User(),
    Boook(),
    Bookshelf(),
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
              color: const Color.fromARGB(255, 255, 255, 255),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GNav(
                hoverColor: Colors.transparent,
                rippleColor: Colors.transparent,
                selectedIndex: state.selectedIndex,
                onTabChange: (index) {
                  context.read<BottomNavBloc>().add(TabChanged(index));
                },
                gap: 8,
                padding: EdgeInsets.all(16),
                backgroundColor:const Color.fromARGB(255, 255, 255, 255),
                activeColor: const Color.fromARGB(255, 33, 149, 243),
                color: Colors.grey,
                tabBackgroundColor: Colors.transparent,
                tabBorder: Border.all(),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.person,
                    text: 'User',
                  ),
                  GButton(
                    icon: Icons.chat,
                    text: 'AI Chat',
                  ),
                  GButton(
                    icon: Icons.book,
                    text: 'Bookshelf',
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