import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:music_api/firebase_options.dart';

import 'package:music_api/pages/mypage/my_page.dart';

import 'package:provider/provider.dart';

import 'pages/data_search.dart';
import 'pages/account/signup.dart';
import 'pages/home/home.dart';
import 'pages/account/login.dart';
import 'providers/map_state.dart';
import 'providers/switch_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initNaverMap();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SwitchProvider()),
    ChangeNotifierProvider(create: (_) => MapProvider(SwitchProvider()))
  ], child: const MyApp()));
}

// 네이버 맵 초기화
Future<void> _initNaverMap() async {
  await NaverMapSdk.instance.initialize(
      clientId: 'oic87mpcyw',
      onAuthFailed: (e) => debugPrint("********* 네이버맵 인증오류 : $e *********"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromRGBO(54, 209, 0, 1),
          scaffoldBackgroundColor: Colors.white),
      initialRoute: '/home',
      routes: {
        '/signup': (BuildContext context) => const SignupPage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/home': (BuildContext context) => const HomePage(),
        '/search': (BuildContext context) => DataSearchPage(),
        '/mypage': (BuildContext context) => MyPage(),
      },
    );
  }
}
