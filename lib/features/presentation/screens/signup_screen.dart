import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/onboarding_heading.dart';
import 'package:libro/features/presentation/widgets/social_media_authenticators.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:libro/features/presentation/widgets/switching_buttom.dart';
import 'package:libro/features/presentation/widgets/terms_conditios.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> _createAuthUser(context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        if (userCredential.user != null) {
          userhi = UserModel(
            uid: userCredential.user!.uid,
            email: emailController.text,
            username: usernameController.text,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('success')));
          nextscreen(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication Error: ${e.toString()}')),
        );
        log(e.toString());
      } finally {}
    }
  }

  void nextscreen(context) {
    context.read<OnboardingBloc>().add(NextPageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(30),
            OnboardingHeading(
              title: 'Create Account!',
              subTitle: 'we happy to see you,sign in to your account',
            ),
            Expanded(child: SizedBox()),
            CustomForm(
              title: 'User name',
              controller: usernameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty || value.length < 2) {
                  return 'Please enter username';
                }
                if (value.contains(' ')) {
                  return 'Username cannot contain spaces';
                }
                return null;
              },
            ),
            CustomForm(
              title: 'Email',
              controller: emailController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter email';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            CustomForm(
              obsecure: _obscurePassword,
              title: 'Password',
              controller: passwordController,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  // setState(() {
                  //   _obscurePassword = !_obscurePassword;
                  // });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            CustomForm(
              obsecure: _obscureConfirmPassword,
              title: 'Confirm',
              controller: confirmPasswordController,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  // setState(() {
                  //   _obscureConfirmPassword = !_obscureConfirmPassword;
                  // });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            Expanded(child: SizedBox()),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _createAuthUser(context);
                  // log(widget.uid);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                ),
                child:
                    _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
              ),
            ),
            Gap(5),
            TermsAndConditios(),
            Expanded(child: SizedBox()),
            SocialMediaAuthenticators(),
            Expanded(child: SizedBox()),
            SwitchingButtom(
              onpressed: () {
                context.read<OnboardingBloc>().add(NextPageEvent());
              },
              text: 'Already have an account? Login',
            ),
          ],
        ),
      ),
    );
  }
}
