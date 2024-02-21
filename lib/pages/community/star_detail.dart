import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../components/card_frame.dart';
import '../../utilities/color_scheme.dart';
import '../../utilities/info.dart';
import '../../utilities/text_theme.dart';
import '../../youtube/music/video_list_detail_page.dart';
//-----페이지 3

class StarDetail extends StatelessWidget {
  final String owner;
  final String image_url;
  final String title;
  final String nickname;
  final String uid;

  const StarDetail(
      {Key? key,
      required this.owner,
      required this.image_url,
      required this.title,
      required this.nickname,
      required this.uid})
      : super(key: key);

  Future<PlaylistInfo> fetchPlaylistInfo(String playlistId) async {
    final doc = await FirebaseFirestore.instance
        .collection('playlist')
        .doc(playlistId)
        .get();

    // 가져온 문서를 StarInfo 객체로 변환하여 반환함
    return PlaylistInfo.fromMap(doc.data()!);
  }

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
            body: FutureBuilder(
                future: fetchPlaylistInfo(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  PlaylistInfo playlistInfo = snapshot.data!;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, top: 20),
                            child: SizedBox(
                              height: 264,
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
                              Text(playlistInfo.title as String, style: bold20),
                              Text(playlistInfo.nickname as String,
                                  style: medium16),
                              Text("음악 7개",
                                  style:
                                      regular12.copyWith(color: AppColor.sub2)),
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
                                onPressed: () async {
                                  List<String> videoIds = [];
                                  if (playlistInfo.owners_id != null) {
                                    // owners_id 리스트를 순회합니다.
                                    for (String owner_id
                                        in playlistInfo.owners_id!) {
                                      // 각 owner_id에 해당하는 'Star' 컬렉션을 가져옵니다.
                                      CollectionReference starCollection =
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(owner_id)
                                              .collection('Star');

                                      if (playlistInfo.stars_id != null) {
                                        // stars_id 리스트를 순회합니다.
                                        for (String star_id
                                            in playlistInfo.stars_id!) {
                                          // 각 star_id에 해당하는 문서를 가져옵니다.
                                          DocumentSnapshot starDoc =
                                              await starCollection
                                                  .doc(star_id)
                                                  .get();

                                          if (starDoc.exists) {
                                            Map<String, dynamic>? data =
                                                starDoc.data()
                                                    as Map<String, dynamic>?;

                                            if (data != null &&
                                                data['videoId'] != null) {
                                              var videoId = data['videoId'];

                                              // videoId 값을 리스트에 추가합니다.
                                              videoIds.add(videoId);
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VideoListDetailPage(
                                                  videoIds: videoIds)));
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.play_arrow),
                                    Text('모두 재생'),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      UserPlayList(uid: uid),
                    ],
                  );
                })));
  }
}

class UserPlayList extends StatelessWidget {
  final String uid;
  const UserPlayList({required this.uid, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future<PlaylistInfo> fetchPlaylistInfo(String playlistId) async {
      final doc = await FirebaseFirestore.instance
          .collection('playlist')
          .doc(playlistId)
          .get();

      // 가져온 문서를 StarInfo 객체로 변환하여 반환함
      return PlaylistInfo.fromMap(doc.data()!);
    }

    return Expanded(
      child: FutureBuilder(
        future: fetchPlaylistInfo(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          PlaylistInfo playlistInfo = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: playlistInfo.stars_id!.length,
            itemBuilder: (BuildContext context, int index) {
              return UserPlay(
                ownersId: playlistInfo.owners_id![index],
                starsId: playlistInfo.stars_id![index],
              );
            },
          );
        },
      ),
    );
  }
}

class UserPlay extends StatelessWidget {
  final String ownersId;
  final String starsId;

  const UserPlay({required this.ownersId, required this.starsId, Key? key})
      : super(key: key);
  Future<StarInfo> fetchStarInfo() async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(ownersId)
        .collection('Star')
        .doc(starsId)
        .get();

    // 가져온 문서를 StarInfo 객체로 변환하여 반환함
    return StarInfo.fromMap(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchStarInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        StarInfo starInfo = snapshot.data!;

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
                Text(starInfo.address as String,
                    style: regular13.copyWith(color: AppColor.sub1)),
              ],
            ),
            const SizedBox(height: 5),
            ListTile(
              leading: SizedBox(
                height: 60,
                width: 60,
                child: Image.network(
                  'https://i1.ytimg.com/vi/${starInfo.videoId}/maxresdefault.jpg',
                  fit: BoxFit.fitHeight,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.network(
                      'https://i1.ytimg.com/vi/${starInfo.videoId}/sddefault.jpg',
                      fit: BoxFit.fitHeight,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          color: Colors.yellow,
                        );
                      },
                    );
                  },
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(starInfo.title as String,
                      style: bold16.copyWith(color: AppColor.sub1)),
                  Text(starInfo.singer as String,
                      style: regular12.copyWith(color: AppColor.sub2))
                ],
              ),
              trailing: Text(starInfo.duration!,
                  style: regular13.copyWith(color: AppColor.sub2)),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
//--------여기까지가 별플리 이후부터 유저 정보 커뮤니티
