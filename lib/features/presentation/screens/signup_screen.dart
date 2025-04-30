import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/presentation/screens/details_screen.dart';
import 'package:libro/features/presentation/screens/login_screen.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isLoading = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _createAuthUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );

        if (userCredential.user != null) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => DetailsScreen(
                      uid: userCredential.user!.uid,
                      email: _emailController.text.trim(),
                      username: _usernameController.text.trim(),
                    ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Error: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          // child: BlocListener<SignupBloc, SignupState>(
          //   listener: (context, state) {
          //     if (state is SignupSuccess) {
          //       Navigator.pushReplacement(context, );
          //     } else if (state is UserAlreadyExists) {
          //       // Show Snackbar for user already exists
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(
          //             state.error,
          //           ), 
          //           duration: Duration(
          //             seconds: 3,
          //           ), // Duration for how long the Snackbar will be visible
          //         ),
          //       );
          //     } else if (state is SignupFailure) {
          //       // Show other error messages
          //       ScaffoldMessenger.of(
          //         context,
          //       ).showSnackBar(SnackBar(content: Text(state.error)));
          //     }
          //   },

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
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length < 2) {
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
                    controller: _emailController,
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
                    hint: 'enter email',
                  ),
                  SizedBox(height: 15),
                  CustomForm(
                    title: 'Password',
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
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
                    hint: 'enter password',
                  ),
                  SizedBox(height: 25),
                  CustomForm(
                    title: 'Confirm',
                    controller: _confirmPasswordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    hint: 'enter password',
                  ),

                  Center(
                    //BlocConsumer<SignupBloc, SignupState>(
                    //   listener: (context, state) {
                    //     if (state is SignupSuccess) {
                    //       Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(builder: (context) => DetailsScreen(
                    //            uid: userCredential.user!.uid,
                    // email: _emailController.text.trim(),
                    // username: _usernameController.text.trim(),
                    //         )),
                    //       );
                    //     } else if (state is SignupFailure) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(content: Text(state.error)),
                    //       );
                    //     }
                    //   },
                    //   builder: (context, state) {
                    //     return
                    child: ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        //   // context.read<SignupBloc>().add(
                        //   //   SignupUser(
                        //   //     _usernameController.text,
                        //   //     _emailController.text,
                        //   //     _passwordController.text,
                        //   //    ),
                        //   // );
                        // }
                        _createAuthUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 50,
                        ),
                      ),
                      child:
                          _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
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
      // ),
    );
  }
}
