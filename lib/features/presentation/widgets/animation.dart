import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/widgets/bottom_navigation.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_act/slide_to_act.dart';

// BLoC Events
abstract class OnboardingEvent {}

class NextPageEvent extends OnboardingEvent {}

class PreviousPageEvent extends OnboardingEvent {}

// BLoC State
class OnboardingState {
  final int currentPage;
  final PageController pageController;

  OnboardingState({required this.currentPage, required this.pageController});

  OnboardingState copyWith({int? currentPage, PageController? pageController}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      pageController: pageController ?? this.pageController,
    );
  }
}

// BLoC
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
    : super(OnboardingState(currentPage: 0, pageController: PageController())) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
  }

  void _onNextPage(NextPageEvent event, Emitter<OnboardingState> emit) {
    if (state.currentPage < 3) {
      final newPage = state.currentPage + 1;
      state.pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(state.copyWith(currentPage: newPage));
    }
  }

  void _onPreviousPage(PreviousPageEvent event, Emitter<OnboardingState> emit) {
    if (state.currentPage > 0) {
      final newPage = state.currentPage - 1;
      state.pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      emit(state.copyWith(currentPage: newPage));
    }
  }
}

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({super.key,});
  final GlobalKey<SlideActionState> slidekey = GlobalKey();

  Future<void> _saveUserDetails(context) async {
    try {
      final userData = UserModel(
        uid: userhi.uid,
        username: userhi.username,
        email: userhi.email,
        place: userhi.place,
        phoneNumber: userhi.phoneNumber,
        imgUrl: userhi.imgUrl,
        subscriptionType: subType

      );
  
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.uid)
          .set(userData.toMap());

      await saveUserToPrefs(
        uid: userData.uid!,
        username: userData.username??'',
        imgUrl: userData.imgUrl??'',
      );
      log(userData.subscriptionType!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration complete!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigation()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving details: ${e.toString()}')),
      );

      // }
    }
  }
  String subType='Silver';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subscription plan!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontFamily: 'serif',
            ),
          ),
          // Subtitle
          Text(
            'For Borrowing books you need to buy our Membership...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),

          //make all these two custom widgets
          Gap(30),
          BlocBuilder<SubscriptionCubit, String>(
            builder: (context, selectedPlan) {
              return Column(
                children: [
                  _buildSubscriptionOption(
                    context,
                    'Silver',
                    '\$200/-',
                    'Silver',
                    selectedPlan,
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionOption(
                    context,
                    'Gold',
                    '\$300/-',
                    'Gold',
                    selectedPlan,
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionOption(
                    context,
                    'Diamond',
                    '\$500/-',
                    'Diamond',
                    selectedPlan,
                  ),
                  const SizedBox(height: 40),
                ],
              );
              // Subscription options
            },
          ),

          // Slide to confirm button
          //  SlideWidget(slideKey: slidekey, title: 'Slide to confirm',function:fun(),)
          IconButton(
            onPressed: () {
              _saveUserDetails(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption(
    BuildContext context,
    String title,
    String price,
    String value,
    String selectedplan,
  ) {
    final bool isSelected = selectedplan == value;

    return GestureDetector(
      onTap: () {
        context.read<SubscriptionCubit>().selectPlan(value);
        subType=value;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFC96C),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'duration:6 month',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'borrow limit:3books',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Text(
              price,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> saveUserToPrefs({
  required String uid,
  required String username,
  required String imgUrl,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
  await prefs.setString('username', username);
  await prefs.setString('imgUrl', imgUrl);
  log('User saved to prefs: $uid');
}
