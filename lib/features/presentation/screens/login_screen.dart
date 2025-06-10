import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:libro/features/presentation/bloc/login/login_bloc.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/bottom_navigation.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:libro/features/presentation/widgets/form.dart';
import 'package:libro/features/presentation/widgets/long_button.dart';
import 'package:libro/features/presentation/widgets/onboarding_heading.dart';
import 'package:libro/features/presentation/widgets/social_media_authenticators.dart';
import 'package:libro/features/presentation/widgets/switching_buttom.dart';
import 'package:libro/features/presentation/widgets/terms_conditios.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(30),
            OnboardingHeading(
              title: 'Hi Welcome Back!',
              subTitle: 'we happy to see you,sign in to your account',
            ),
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
                    MaterialPageRoute(builder: (context) => BottomNavigation()),
                  );
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return CustomLongButton(
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<LoginBloc>(context).add(
                        LoginRequested(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        ),
                      );
                    }
                  },
                  widget:
                      state is LoginLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Log in', style: TextStyle(fontSize: 20)),
                );
              },
            ),
            Gap(5),
            TermsAndConditios(signin: true),
            Gap(30),
            SocialMediaAuthenticators(signin: true),
            Gap(30),
            SwitchingButtom(
              onpressed: () {
                context.read<OnboardingBloc>().add(NextPageEvent());
              },
              text: 'Dont have an account? Create one',
            ),
          ],
        ),
      ),
    );
  }
}
