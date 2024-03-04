import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hello_user/viewmodels/book_viewmodel.dart';
import 'package:flutter_hello_user/views/home_page.dart';
import 'package:flutter_hello_user/views/signup_page.dart';
import 'package:flutter_hello_user/views/splash_page.dart';
import 'package:flutter_hello_user/viewmodels/auth_viewmodel.dart';
import 'package:flutter_hello_user/utils/routes.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyBg04LFXNMkY_YFJh6IlF6wyKDe5ov6zVA",
              appId: "1:783766536749:android:52bddcdcfabb5e5461aea4",
              messagingSenderId: "783766536749",
              projectId: "flutter-memoneet-hello-user"));
    } else {
      await Firebase.initializeApp();
    }
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookViewModel(),
        ),
      ],
      child: const MyApp(),
    ));
  } catch (error) {
    print('Error initializing Firebase: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: Provider.of<AuthViewModel>(context, listen: true).isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashPage();
          } else {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error initializing Firebase: ${snapshot.error}'),
                ),
              );
            } else {
              return Consumer<AuthViewModel>(
                builder: (context, authProvider, _) {
                  if (authProvider.user != null) {
                    return const HomePage();
                  } else {
                    return const LoginPage();
                  }
                },
              );
            }
          }
        },
      ),
      routes: {
        AppRoute.loginRoute: (context) => const LoginPage(),
        AppRoute.signupRoute: (context) => const SignUpPage(),
        AppRoute.homeRoute: (context) => const HomePage(),
      },
    );
  }
}
