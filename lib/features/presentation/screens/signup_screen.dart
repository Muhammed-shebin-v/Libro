



import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/data/models/user_model.dart';
import 'package:libro/features/presentation/dummmy/const.dart';
import 'package:libro/features/presentation/screens/details_screen.dart';
import 'package:libro/features/presentation/screens/login_screen.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';

class SignupScreen extends StatefulWidget {
   SignupScreen({
    super.key,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController= TextEditingController();

  final TextEditingController usernameController= TextEditingController();

  final TextEditingController confirmPasswordController= TextEditingController();

  bool _isLoading = false;

  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> _createAuthUser(context) async {
    if (_formKey.currentState!.validate()) {
      // setState(() {
      //   _isLoading = true;
      // });

      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            );

        if (userCredential.user != null){
          // if (mounted) {
          //   // widget.uid = userCredential.user!.uid;
          //   // log(widget.uid);
          //   widget.user= UserModel(uid: userCredential.user!.uid,email: emailController.text,username: usernameController.text);
            userhi=UserModel(uid: userCredential.user!.uid,email: emailController.text,username: usernameController.text);
            context.read<OnboardingBloc>().add(NextPageEvent());
            
        //   }
         }
      } catch (e) {
        // if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Error: ${e.toString()}')),
          );
        // }
      } finally {
        // if (mounted) {
        //   setState(() {
        //     _isLoading = false;
        //   });
        // }
      }
    }
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
            Text('Create Account!', style: AppFonts.heading1),
            Text('we happy to see you,sign in to your account'),
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
              controller:emailController,
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
              controller:passwordController,
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
            Center(
              child: Text(
                'By signing up, you agree to our Terms & Conditions.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
            Expanded(child: SizedBox()),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                    endIndent: 10,
                  ),
                ),
                Text('or Sign In with'),
                Expanded(
                  child: Divider(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    thickness: 1,
                    indent: 10,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.g_mobiledata)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.apple)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.facebook)),
                ],
              ),
            ),
           Expanded(child: SizedBox()),
            Center(
              child: TextButton(
                onPressed: () {
                 context.read<OnboardingBloc>().add(NextPageEvent());
                },
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
