import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libro/features/presentation/widgets/bottom_navigation.dart';
import 'package:libro/features/presentation/screens/onboarding_screen.dart';
import 'package:libro/core/themes/fonts.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLogo = true; 

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showLogo = false; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color60,
      body: Center(
        child:
            showLogo
                ? Lottie.asset('lib/assets/Animation - 1742030119292.json',height: 200,fit: BoxFit.fill)
                : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    log("Auth State Changed: ${snapshot.data}");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Something went wrong');
                    } else {
                      if (snapshot.data == null) {
                        return IntroductionPageView();
                      } else {
                        return BottomNavigation();
                      }
                    }
                  },
                ),
      ),
    );
  }
}
