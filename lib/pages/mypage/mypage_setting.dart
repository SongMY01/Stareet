import 'package:flutter/material.dart';
import 'package:music_api/utilities/color_scheme.dart';

import '../../utilities/text_theme.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool switchValue = false;

  void toggleSwitch(bool value) {
    // 스위치 상태를 토글하고 UI를 업데이트하기 위해 setState를 호출.
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
          title: const Text('설정', style: bold16),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const Divider(),
            const ListTile(
              leading: Icon(
                Icons.announcement,
                color: Colors.white,
              ),
              title: Text("공지사항", style: regular17),
            ),
            const ListTile(
              leading: Icon(
                Icons.question_mark_outlined,
                color: Colors.white,
              ),
              title: Text("고객센터/운영정책", style: regular17),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text("푸쉬 알림", style: regular17),
              trailing: GestureDetector(
                onTap: () => toggleSwitch(!switchValue), // 탭 시 스위치 값을 토글합니다.
                child: SizedBox(
                  height: 28,
                  width: 53,
                  child: Image.asset(switchValue
                      ? 'assets/fonts/images/switch_inactive.png'
                      : 'assets/fonts/images/switch_active.png'),
                ),
              ),
            ),
            const Spacer(),
            const Divider(),
            Row(
              children: [
                const Spacer(),
                TextButton(
                    onPressed: () {},
                    child: const Text('로그아웃',
                        style: TextStyle(
                            color: AppColor.error,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColor.error,
                            decorationThickness: 2))),
              ],
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
