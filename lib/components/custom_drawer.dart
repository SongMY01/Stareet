import 'package:flutter/material.dart';
import 'package:music_api/pages/community/coumunity.dart';
import 'package:provider/provider.dart';

import '../pages/mypage/my_page.dart';
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
          ListTile(
              leading:
                  Image.asset("assets/images/exit_button.png", width: 20, height: 20),
                  onTap: () => Navigator.pop(context),),
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
              leading: Image.asset("assets/images/home.png",
                  width: 23,
                  height: 26,
                  color: (!switchMode &&
                          !(ModalRoute.of(context)?.settings.name == '/search'))
                      ? AppColor.text
                      : AppColor.sub2),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
                context.read<SwitchProvider>().setMode(false);
              },
              title: Text("홈",
                  style: (!switchMode &&
                          !(ModalRoute.of(context)?.settings.name == '/search'))
                      ? semibold24.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.text)
                      : semibold24.copyWith(color: AppColor.sub2))),
          ListTile(
            //여기서부터
            leading: Image.asset("assets/images/drawer2.png",
                width: 23, height: 26, color: AppColor.sub2),
            onTap: () {},
            //

//             leading: Image.asset("assets/images/leave_star.png",
//                 width: 23,
//                 height: 26,
//                 color: ModalRoute.of(context)?.settings.name == '/search'
//                     ? AppColor.text
//                     : AppColor.sub2),
//             onTap: () {
//               Navigator.pushNamed(context, '/search');
//             },
            title: Text("별자국 남기기",
            style: (ModalRoute.of(context)?.settings.name == '/search')
                      ? semibold24.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.text)
                      : semibold24.copyWith(color: AppColor.sub2))
          ),
          ListTile(
              leading: Image.asset("assets/images/connect_star.png",
                  width: 23,
                  height: 23,
                  color: (switchMode &&
                          !(ModalRoute.of(context)?.settings.name == '/search')) ? AppColor.text : AppColor.sub2),
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
                context.read<SwitchProvider>().setMode(true);
              },
              title: Text("별자리 공작소",
                  style: (switchMode &&
                          !(ModalRoute.of(context)?.settings.name == '/search'))
                      ? semibold24.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.text)
                      : semibold24.copyWith(color: AppColor.sub2))),
          ListTile(
              leading: Image.asset("assets/images/community.png",
                  width: 23, height: 25, color: AppColor.sub2),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityPage(),
                  ),
                );
              },

              title: Text("별별 게시판",
                  style: semibold24.copyWith(color: AppColor.sub2))),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyPage()));
            },
            child: Row(
              children: [
                const SizedBox(width: 15),
                Image.asset("assets/images/my_page.png",
                    width: 23, height: 25, color: AppColor.text),
                const SizedBox(width: 9),
                const Text("마이페이지", style: medium14)
              ],
            ),
          ),
          const SizedBox(height: 19),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                const SizedBox(width: 14),
                Image.asset("assets/images/info.png",
                    width: 21, height: 21, color: AppColor.text),
                const SizedBox(width: 9),
                const Text("앱 정보", style: medium14)
              ],
            ),
          ),
          const SizedBox(height: 60)
        ]),
      ),
    );
  }
}
