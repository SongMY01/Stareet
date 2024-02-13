import 'package:flutter/material.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
//-----페이지 3

class StarDetail extends StatelessWidget {
  final String owner;
  final String image_url;
  final String title;

  const StarDetail(
      {Key? key,
      required this.owner,
      required this.image_url,
      required this.title})
      : super(key: key);
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
                              child: Image.network(
                                this.image_url,
                                width: 60,
                                height: 60,
                                fit: BoxFit.fill,
                              ),
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
                        Text(this.title, style: bold20),
                        Text(this.owner, style: medium16),
                        Text("음악 7개",
                            style: regular12.copyWith(color: AppColor.sub2)),
                        SizedBox(height: 15),
                        Container(
                          width: 43.0, // 원하는 너비 설정
                          height: 43.0, // 원하는 높이 설정
                          decoration: BoxDecoration(
                            color: AppColor.text2,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share_outlined,
                                color: AppColor.sub1),
                          ),
                        )
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
              Text("잘 지내자, 우리", style: bold16.copyWith(color: AppColor.sub1)),
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
