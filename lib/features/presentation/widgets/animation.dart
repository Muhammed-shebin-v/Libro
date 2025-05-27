import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';

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

  @override
  Future<void> close() {
    state.pageController.dispose();
    return super.close();
  }
}

// Main Screen
class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2D2D),
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Animated circles
              // AnimatedCircles(currentPage: state.currentPage),

              // Main content
              SafeArea(
                child: PageView(
                  controller: state.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    LoginPage(),
                    CreateAccountPage(),
                    ProfilePage(),
                    SubscriptionPage(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// // Animated Circles Widget
// class AnimatedCircles extends StatelessWidget {
//   final int currentPage;

//   const AnimatedCircles({Key? key, required this.currentPage}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width+100;
//     final screenHeight = MediaQuery.of(context).size.height;

//     // Calculate circle positions based on current page
//     double topCircleX = _getTopCirclePosition(currentPage, screenWidth);
//     double bottomCircleX = _getBottomCirclePosition(currentPage, screenWidth);

//     return Stack(
//       children: [
//         // Top circle
//         AnimatedPositioned(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           top: -40,
//           left: topCircleX,
//           child: Container(
//             width: 180,
//             height: 180,
//             decoration: const BoxDecoration(
//               color: Color(0xFFE6B366),
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),

//         // Bottom circle
//         AnimatedPositioned(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           bottom: -30,
//           left: bottomCircleX,
//           child: Container(
//             width: 300,
//             height: 200,
//             decoration: const BoxDecoration(
//               color: Color(0xFFE6B366),
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   double _getTopCirclePosition(int page, double screenWidth) {
//     switch (page) {
//       case 0:
//         return screenWidth * 0.6;
//       case 1:
//         return screenWidth * 0.4;
//       case 2:
//         return screenWidth * 0.2;
//       case 3:
//         return screenWidth * 0.0;
//       default:
//         return screenWidth * 0.6;
//     }
//   }

//   double _getBottomCirclePosition(int page, double screenWidth) {
//     switch (page) {
//       case 0:
//         return -50;
//       case 1:
//         return screenWidth * 0.2;
//       case 2:
//         return screenWidth * 0.4;
//       case 3:
//         return screenWidth * 0.6;
//       default:
//         return -50;
//     }
//   }
// }

// Custom TextField Widget
class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xFFE6B366),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}

// Custom Button Widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE6B366),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Login Page
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Hi Welcome Back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'I\'m happy to see you again in your account',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const CustomTextField(hintText: 'Email'),
          const CustomTextField(hintText: 'Password', isPassword: true),
          const SizedBox(height: 20),
          CustomButton(
            text: 'LOGIN',
            onPressed: () {
             
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'or sign in with',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('G'),
              const SizedBox(width: 20),
              _buildSocialIcon('F'),
              const SizedBox(width: 20),
              _buildSocialIcon('A'),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Don\'t have an account? Create here',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String letter) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Create Account Page
class CreateAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Create Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your journey starts here take the first step into the realm of creativity',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          const CustomTextField(hintText: 'Username'),
          const CustomTextField(hintText: 'Email'),
          const CustomTextField(hintText: 'Password', isPassword: true),
          const CustomTextField(hintText: 'Confirm', isPassword: true),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Sign up',
            onPressed: () {
              context.read<OnboardingBloc>().add(NextPageEvent());
            },
          ),
          const SizedBox(height: 20),
          const Text(
            'or sign in with',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon('G'),
              const SizedBox(width: 20),
              _buildSocialIcon('F'),
              const SizedBox(width: 20),
              _buildSocialIcon('A'),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Do you have a account?Continue here',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(String letter) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Profile Page
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Tell Us More About You!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'I\'m happy to see you sign up in your account',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFE6B366),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            'User Profile Image',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 30),
          const CustomTextField(hintText: 'FullName'),
          const CustomTextField(hintText: 'Phone number'),
          const CustomTextField(hintText: 'Address'),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Continue',
            onPressed: () {
              context.read<OnboardingBloc>().add(NextPageEvent());
            },
          ),
          const SizedBox(height: 10),
          const Text(
            'Close quickly correctly this will take you to connect to admin',
            style: TextStyle(color: Colors.white70, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Subscription Page
class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

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
          const SizedBox(height: 30),
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
          Center(
            child: Container(
              width: 280,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB347),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.black, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Slide to Confirm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
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
