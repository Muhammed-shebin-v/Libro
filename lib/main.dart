import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libro/features/auth/auth_service.dart';
import 'package:libro/features/presentation/bloc/ad/ad_bloc.dart';
import 'package:libro/features/presentation/bloc/novels/novel_books_bloc.dart';
import 'package:libro/features/presentation/bloc/novels/novel_books_event.dart';
import 'package:libro/features/presentation/bloc/wishlist/wishlist_bloc.dart';
import 'package:libro/features/presentation/bloc/history_books/history_books_bloc.dart';
import 'package:libro/features/presentation/bloc/history_books/history_books_event.dart';

import 'package:libro/features/presentation/bloc/search/search_dart_bloc.dart';
import 'package:libro/features/presentation/bloc/search/search_dart_event.dart';
import 'package:libro/features/presentation/bloc/latest_books/books_bloc.dart';
import 'package:libro/features/presentation/bloc/latest_books/books_event.dart';
import 'package:libro/features/presentation/bloc/login/login_bloc.dart';
import 'package:libro/features/presentation/bloc/signup/signup_bloc.dart';
import 'package:libro/features/presentation/bloc/user/user_bloc_bloc.dart';
import 'package:libro/features/presentation/screens/splash_screen.dart';
import 'package:libro/features/presentation/widgets/animation.dart';
import 'package:libro/features/presentation/widgets/noti.dart';
import 'package:libro/features/presentation/widgets/notiscreen.dart';
import 'package:libro/features/presentation/widgets/sub2.dart';
import 'package:libro/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        BlocProvider(create: (context) => BookBloc()..add(FetchBooks())),
        BlocProvider(create: (context) => SearchBloc()..add(LoadBooks())..add(CategoryFilterChanged('news'))),
        BlocProvider(create: (context) => OnboardingBloc()),
        BlocProvider(create: (_) => SubscriptionCubit()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => HistoryBookBloc()..add(HistoryFetchBooks()),),
        BlocProvider(create: (context)=> AdBloc()..add(FetchAds())),
        BlocProvider(create: (context)=>NovelsBloc()..add(NovelsFetchBooks()))
             

      ],
      child: MaterialApp(
        title: 'Libro',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
      //    onGenerateRoute: (settings) {
      //   if (settings.name == '/approved') {
      //     return MaterialPageRoute(
      //       builder: (_) => const ApprovedScreen(),
      //     );
      //   }
      //   return MaterialPageRoute(
      //     builder: (_) => const UserHomeScreen(),
      //   );
      // },
         
      ),
    );
  }
}
