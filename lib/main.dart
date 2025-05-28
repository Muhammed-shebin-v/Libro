import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/auth/auth_service.dart';
import 'package:libro/features/presentation/bloc/bloc/search_dart_bloc.dart';
import 'package:libro/features/presentation/bloc/book/books_bloc.dart';
import 'package:libro/features/presentation/bloc/book/books_event.dart';
import 'package:libro/features/presentation/bloc/login/login_bloc.dart';
import 'package:libro/features/presentation/bloc/signup/signup_bloc.dart';
import 'package:libro/features/presentation/screens/details_screen.dart';
import 'package:libro/features/presentation/screens/login_screen.dart';
import 'package:libro/features/presentation/screens/signup_screen.dart';
import 'package:libro/features/presentation/screens/splash_screen.dart';
import 'package:libro/features/presentation/screens/subscription.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/sub.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:libro/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(Libro());
}

class Libro extends StatelessWidget {
  const Libro({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignupBloc(AuthService())),
        BlocProvider(create: (context) => LoginBloc(AuthService())),
        BlocProvider(create: (context)=>BookBloc()..add(FetchBooks()),),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => OnboardingBloc()),
        BlocProvider(create: (_) => SubscriptionCubit()),
      ],
      child: MaterialApp(
        title: 'Libro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home:  SplashScreen(),

      ),
    );
  }
}
