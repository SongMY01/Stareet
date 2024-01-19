import 'package:flutter/material.dart';

import 'pages/home/home_page.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xff2d2d2d),
            scaffoldBackgroundColor: const Color(0xff2d2d2d)));
  }
}
