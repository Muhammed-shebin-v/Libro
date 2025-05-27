import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/presentation/bloc/login/login_bloc.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/bottom_navigation.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/form.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(30),
                  Text('Hi Welcome Back!', style: AppFonts.heading1),
                  Text('we happy to see you,sign in to your account'),
                  Gap(30),
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
                  ),
                  CustomForm(
                    obsecure: true,
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
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'forgot password?',
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                  Gap(20),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigation(),
                          ),
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

                  Gap(5),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'By signing up you agree to our terms and conditions ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 159, 163, 174),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Gap(30),
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
                  Gap(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.g_mobiledata),
                        ),
                        IconButton(onPressed: () {}, icon: Icon(Icons.apple)),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.facebook),
                        ),
                      ],
                    ),
                  ),
                  Gap(30),
                  Center(
                    child: TextButton(
                      onPressed: () {
                         context.read<OnboardingBloc>().add(NextPageEvent());
                      },
                      child: Text(
                        'Dont have an account? Create one',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 159, 163, 174),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
   
    );
  }
}
