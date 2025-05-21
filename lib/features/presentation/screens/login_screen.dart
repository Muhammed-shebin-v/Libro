import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/presentation/bloc/login/login_bloc.dart';
import 'package:libro/features/presentation/widgets/bottom_navigation.dart';
import 'package:libro/features/presentation/screens/signup_screen.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(30),
                  Text('Hi Welcome Back!', style: AppFonts.heading1),
                  Text('we happy to see you,sign in to your account'),
                  Gap(50),
                  CustomForm(
                    title: 'Email',
                    hint: 'enter email',
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
                  ),
                  CustomForm(
                    title: 'Password',
                    hint: 'enter password',
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'forgot password?',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 72, 255),
                      ),
                    ),
                  ),
                  Gap(50),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNavigation()),
                        );
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    builder: (context, state) {
                      return Align(
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<LoginBloc>(context).add(
                                LoginRequested(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            height: 40,
                            width: 250,
                            child: Center(
                              child:
                                  state is LoginLoading
                                      ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : Text(
                                        'Log in',
                                        style: TextStyle(fontSize: 20),
                                      ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  Gap(10),
                  Align(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Dont have an account? Create one',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 159, 163, 174),
                        ),
                      ),
                    ),
                  ),
                  Gap(30),
                  // Align(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: const Color.fromARGB(255, 222, 217, 204),
                  //       border: Border.all(),
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     height: 60,
                  //     width: 250,
                  //     child: Align(
                  //       alignment: Alignment.center,
                  //       child: Text(
                  //         'G continue with google',
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Expanded(child: SizedBox()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'By signing up you agree to our terms and conditions of Use',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 159, 163, 174),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
