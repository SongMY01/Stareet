import 'package:flutter/material.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';

//------6페이지
class MateDetail extends StatefulWidget {
  const MateDetail({Key? key}) : super(key: key);

  @override
  _MateDetailState createState() => _MateDetailState();
}

class _MateDetailState extends State<MateDetail> {
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
            actions: [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  // 메뉴 항목을 선택했을 때 실행될 코드
                  print(value); // 선택된 값을 사용하여 로직을 처리할 수 있습니다.
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'report', // 메뉴 항목의 값을 설정합니다.
                    child: Container(
                      height: 20.0, // 원하는 높이로 설정
                      width: 80.0, // 원하는 너비로 설정
                      alignment: Alignment.center,
                      child: Text(
                        '신고하기',
                        style: TextStyle(color: Colors.white), // 텍스트 색상 설정
                      ),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.white),
                // 팝업 메뉴의 위치를 조정하고 싶다면 offset 값을 조정하세요.
                offset: Offset(0.0, 40.0),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Image.asset(
                    'assets/fonts/images/profile.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text('좌좌좌좌', style: bold18.copyWith(color: AppColor.sub1)),
                  const Spacer(),
                  SizedBox(
                    height: 28,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          mateRequested = !mateRequested;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: mateRequested
                            ? const Color.fromRGBO(19, 228, 206, 1)
                            : Colors.black,
                        backgroundColor: mateRequested
                            ? Colors.black
                            : const Color.fromRGBO(19, 228, 206, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(19, 228, 206, 1),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: Text(
                        mateRequested ? "메이트" : "메이트 신청",
                        style: const TextStyle(fontSize: 10.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text('4 스타 메이트',
                      style: medium13.copyWith(color: AppColor.text)),
                ],
              ),
              const SizedBox(height: 20),
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
