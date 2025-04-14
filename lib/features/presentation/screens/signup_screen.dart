
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:libro/features/presentation/screens/details_screen.dart';
import 'package:libro/features/presentation/screens/login_screen.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/bloc/signup/signup_bloc.dart';
import 'package:libro/features/presentation/bloc/signup/signup_event.dart';
import 'package:libro/features/presentation/bloc/signup/signup_state.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(30),
                    Text('Create New Account!', style: AppFonts.heading1),
                    Text('we happy to see you,sign in to your account'),
                    Gap(40),
            
                CustomForm(
                  title: 'User name',
                  hint: 'enter username',
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 2) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                CustomForm(
                  title: 'Email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  hint: 'enter email',
                ),
                SizedBox(height: 15),
                CustomForm(
                  title: 'Password',
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  hint: 'enter password',
                ),
                SizedBox(height: 25),
            
                
                 Center(
                  child: BlocConsumer<SignupBloc, SignupState>(
                    listener: (context, state) {
                      if (state is SignupSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => DetailsScreen()),
                        );
                      } else if (state is SignupFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<SignupBloc>().add(
                              SignupUser(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                        ),
                        child: state is SignupLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.black)),
                      );
                    },
                  ),
                ),
            
                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
            
                SizedBox(height: 20),
            
                Center(
                  child: Text(
                    'By signing up, you agree to our Terms & Conditions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
