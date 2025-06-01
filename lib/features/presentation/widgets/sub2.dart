
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/screens/details_screen.dart';
import 'package:libro/features/presentation/screens/login_screen.dart';
import 'package:libro/features/presentation/screens/signup_screen.dart';
import 'package:libro/features/presentation/widgets/animation.dart';

UserModel userhi=UserModel();

class LibroSubscriptionScreen2 extends StatelessWidget {
  LibroSubscriptionScreen2({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final String uid = '';
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final String imgUrl = '';
  final String subscription = '';

  UserModel addUserDetails=UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF3E3),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomPaint(
                  painter: CircleCutPainter(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.menu_book,
                                color: AppColors.black,
                                size: 28,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Libro',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocBuilder<OnboardingBloc, OnboardingState>(
                          builder: (context, state) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 300,
                              child: PageView(
                                controller: state.pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  LoginScreen(),
                                  SignupScreen(
                                  //   // uid: uid!,
                                  //   // emailController: emailController,
                                  //   // passwordController: passwordController,
                                  //   // usernameController: usernameController,
                                  //   // confirmPasswordController:confirmPasswordController,
                                  // user: addUserDetails,
                                  ),
                                  DetailsScreen(
                                    // fullNameController: fullNameController,
                                    // phoneNumberController:
                                    //     phoneNumberController,
                                    // placeController: placeController,
                                    // imgUrl: imgUrl,
                                    // uid: uid,
                                    // email: emailController,
                                    // usertemp: addUserDetails,
                                  ),
                                  SubscriptionPage(
                                    // subType: subscription,
                                    // uid: uid!,
                                    // username: usernameController,
                                    // email: emailController,
                                    // fulname: fullNameController,
                                    // imageUrl: imgUrl,
                                    // phone: phoneNumberController,
                                    // place: placeController,
                                    // usertemp: addUserDetails,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircleCutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFFFFC96C)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(80, 30), 180, paint);
    canvas.drawCircle(Offset(size.width + -60, size.height + 40), 150, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SubscriptionCubit extends Cubit<String> {
  SubscriptionCubit() : super('Silver');

  void selectPlan(String plan) {
    log('Selected plan: $plan');
    emit(plan);
  }
}
