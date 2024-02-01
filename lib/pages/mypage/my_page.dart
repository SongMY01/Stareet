import 'package:flutter/material.dart';


import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
import 'my_starmate.dart';
import 'mypage_profile.dart';
import 'mypage_setting.dart';

//------6페이지
class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool mateRequested = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/fonts/images/background.gif'),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              "마이페이지",
              style: bold16.copyWith(color: AppColor.text),
            ),
            actions: [
              PopupMenuButton<int>(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ), // 아이콘 설정
                offset: const Offset(0, 50), // X와 Y 오프셋을 조정하여 팝업 위치 설정
                itemBuilder: (context) => [
                  PopupMenuItem(
                      value: 1,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                          child: Text('프로필 편집',
                              style: medium14.copyWith(
                                  color: AppColor.sub1)))),
                  PopupMenuItem(
                      value: 2,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingPage(),
                              ),
                            );
                          },
                          child: Text('설정',
                              style: medium14.copyWith(
                                  color: AppColor.sub1)))),
                ],
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/fonts/images/profile.png',
                height: 72,
                width: 72,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Text('닉네임은 일곱글',
                          style: bold18.copyWith(color: AppColor.text)),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyStarMate(),
                              ),
                            );
                          },
                          child: Text('4 스타 메이트',
                              style: medium13.copyWith(color: AppColor.text))),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text('soda@handong.ac.kr',
                          style: regular15.copyWith(color: AppColor.sub2)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const TabBar(
                labelColor: AppColor.text,
                indicatorColor: AppColor.text, //tabbar 아랫 부분에 흰색 줄 (움직이는거)
                tabs: [
                  Tab(text: "내 플리"),
                  Tab(text: "저장한 플리"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    MySongList(),
                    SaveSongList(),
                  ],
                ),
              ),
              const SizedBox(
                height: 28,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MySongList extends StatelessWidget {
  const MySongList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 15,
      itemBuilder: (BuildContext context, int index) {
        return const MySong();
      },
    );
  }
}

class MySong extends StatelessWidget {
  const MySong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        image: const DecorationImage(
          image: AssetImage('assets/fonts/images/starback.jpeg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(children: [
        Positioned(
            left: 25,
            bottom: 8,
            child: SizedBox(
                height: 100,
                child: Image.asset('assets/fonts/images/stars.png')))
      ]),
    );
  }
}

class SaveSongList extends StatelessWidget {
  const SaveSongList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return const SaveSong();
      },
    );
  }
}

class SaveSong extends StatelessWidget {
  const SaveSong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        image: const DecorationImage(
          image: AssetImage('assets/fonts/images/starback.jpeg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(children: [
        Positioned(
            left: 25,
            bottom: 8,
            child: SizedBox(
                height: 100,
                child: Image.asset('assets/fonts/images/stars.png')))
      ]),
    );
  }
}
