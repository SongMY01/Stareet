import 'package:flutter/material.dart';

import '../../utilities/color.dart';
import '../../utilities/text_style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool switchValue = false;

  void toggleSwitch(bool value) {
    // 스위치 상태를 토글하고 UI를 업데이트하기 위해 setState를 호출합니다.
    setState(() {
      switchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/fonts/images/background.gif'),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('프로필편집', style: bold16.copyWith(color: AppColor.text)),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const Divider(),
          ],
        ),
      ),
    );
  }
}
