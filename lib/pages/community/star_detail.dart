import 'package:flutter/material.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
//-----페이지 3

class StarDetail extends StatelessWidget {
  const StarDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/fonts/images/background.gif')),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("별플리", style: bold16),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, top: 20),
                      child: Container(
                        height: 264,
                        child: Stack(
                          children: [
                            Image.asset('assets/fonts/images/starback.png'),
                            Positioned(
                              left: 30,
                              bottom: 20,
                              child:
                                  Image.asset('assets/fonts/images/stars.png'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 170),
                        const Text("용가리 자리",
                            style: bold20),
                        const Text("좌",
                            style: medium16),
                        Text("음악 7개",
                            style:
                                regular12.copyWith(color: AppColor.sub2)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.share))
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 42,
                      width: 165,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bookmark),
                              Text('저장'),
                            ],
                          )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 42,
                      width: 165,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                          ),
                          onPressed: () {},
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow),
                              Text('모두 대생'),
                            ],
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const UserPlayList(),
              ],
            )));
  }
}

class UserPlayList extends StatelessWidget {
  const UserPlayList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return const UserPlay();
        },
      ),
    );
  }
}

class UserPlay extends StatelessWidget {
  const UserPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.location_on,
              color: Color.fromRGBO(19, 228, 206, 1),
            ),
            Text('포항시 북구 흥해읍 한동로 558',
                style: regular13.copyWith(color: AppColor.sub1)),
          ],
        ),
        const SizedBox(height: 5),
        ListTile(
          leading: Image.asset('assets/fonts/images/songprofile.jpeg'),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("잘 지내자, 우리",
                  style: bold16.copyWith(color: AppColor.sub1)),
              Text('최유리', style: regular12.copyWith(color: AppColor.sub2))
            ],
          ),
          trailing:
              Text('3:54', style: regular13.copyWith(color: AppColor.sub2)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

//--------여기까지가 별플리 이후부터 유저 정보 커뮤니티
