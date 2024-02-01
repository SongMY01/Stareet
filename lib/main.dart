import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_api/firebase_options.dart';

import 'pages/data_search.dart';
import 'pages/account/signup.dart';
import 'pages/home/home_page.dart';
import 'pages/account/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromRGBO(54, 209, 0, 1),
          scaffoldBackgroundColor: Colors.white),
      initialRoute: '/search',
      routes: {
        '/signup': (BuildContext context) => const SignupPage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/search': (BuildContext context) => DataSearchPage(),
      },
    );
  }
}
