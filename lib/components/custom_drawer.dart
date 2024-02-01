import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/switch_state.dart';
import '../utilities/color_scheme.dart';
import '../utilities/text_theme.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool switchMode = Provider.of<SwitchProvider>(context).switchMode;
    return Drawer(
      backgroundColor: const Color(0xff171717),
      shadowColor: Colors.black.withOpacity(0.8),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(
                    width: 2, color: AppColor.text.withOpacity(0.85)))),
        child: Column(children: [
          const SizedBox(height: 75),
          const ListTile(
              leading:
                  Icon(Icons.close_rounded, color: AppColor.text, size: 22)),
          ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(color: AppColor.text)),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("닉네임은일곱글", style: bold16),
                  Text("34972rhf@gmail.com", style: regular11)
                ],
              )),
          const SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.home_rounded,
                  color: switchMode ? AppColor.sub2 : AppColor.text, size: 23),
              onTap: () {
                Navigator.pop(context);
                context.read<SwitchProvider>().setMode(false);
              },
              title: Text("홈",
                  style: switchMode
                      ? semibold24.copyWith(color: AppColor.sub2)
                      : semibold24.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.text))),
          ListTile(
            leading: Image.asset("assets/images/drawer2.png",
                width: 23,
                height: 26,
                color: AppColor.sub2),
            onTap: () {},
            title: Text("별자국 남기기",
                style: semibold24.copyWith(color: AppColor.sub2)),
          ),
          ListTile(
              leading: Image.asset("assets/images/drawer3.png",
                  width: 23,
                  height: 23,
                  color: switchMode ? AppColor.text : AppColor.sub2),
              onTap: () {
                Navigator.pop(context);
                context.read<SwitchProvider>().setMode(true);
              },
              title: Text("별자리 공작소",
                  style: switchMode
                      ? semibold24.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.text)
                      : semibold24.copyWith(color: AppColor.sub2))),
          ListTile(
              leading: Image.asset("assets/images/drawer4.png",
                  width: 23, height: 25, color: AppColor.sub2),
              onTap: () {
                
              },
              title: Text("별별 게시판",
                  style: semibold24.copyWith(color: AppColor.sub2))),
          const Spacer(),
          ListTile(
              leading: Image.asset("assets/images/my_page.png",
                  width: 23, height: 25, color: AppColor.text),
              onTap: () {},
              title: const Text("마이페이지", style: medium14)),
          ListTile(
              leading: const Icon(Icons.info_outline_rounded,
                  color: AppColor.text, size: 23),
              onTap: () {},
              title: const Text("앱 정보", style: medium14)),
          const SizedBox(height: 60)
        ]),
      ),
    );
  }
}
