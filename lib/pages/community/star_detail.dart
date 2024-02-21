import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_api/components/card_frame.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
//-----페이지 3

class StarDetail extends StatelessWidget {
  final String owner;
  final String image_url;
  final String title;
  final String nickname;

  const StarDetail(
      {Key? key,
      required this.owner,
      required this.image_url,
      required this.title,
      required this.nickname})
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
                      child: SizedBox(
                        height: 264,
                        width: 180,
                        child: StarCard(
                          child: Stack(
                            children: [
                              Positioned(
                                top: -1,
                                left: -1,
                                child: Container(
                                  height: 258,
                                  width: 173,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(72),
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          image_url), // image_url을 사용하도록 수정했습니다.
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                        Text(title, style: bold20),
                        Text(nickname, style: medium16),
                        Text("음악 7개",
                            style: regular12.copyWith(color: AppColor.sub2)),
                        const SizedBox(height: 15),
                        Container(
                          width: 43.0, // 원하는 너비 설정
                          height: 43.0, // 원하는 높이 설정
                          decoration: const BoxDecoration(
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
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('playlist').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          final playlists = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: playlists.length,
            itemBuilder: (BuildContext context, int index) {
              return UserPlay(
                playlistId: playlists[index].id,
              );
            },
          );
        },
      ),
    );
  }
}

class UserPlay extends StatelessWidget {
  final String playlistId;

  const UserPlay({required this.playlistId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('playlist')
          .doc(playlistId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        final playlistData = snapshot.data!.data() ?? {};

        // final starsId = playlistData['stars_id'];
        // final ownersId = playlistData['owners_id'];

        // `starsId`와 `ownersId`를 사용하여 위젯을 빌드하세요.

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
      },
    );
  }
}
//--------여기까지가 별플리 이후부터 유저 정보 커뮤니티
