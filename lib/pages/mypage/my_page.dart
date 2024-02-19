import 'package:flutter/material.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
import 'my_starmate.dart';
import 'mypage_profile.dart';
import 'mypage_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key, String? nickName}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

String uid = FirebaseAuth.instance.currentUser!.uid;

Future<Map<String, dynamic>> getUserInfo() async {
  var result =
      await FirebaseFirestore.instance.collection('user').doc(uid).get();
  return result.data() as Map<String, dynamic>;
}

Future<List<Map<String, dynamic>>> getPlaylistMyInfo() async {
  var result = await FirebaseFirestore.instance
      .collection('playlist')
      .where('uid', whereIn: playlistMy)
      .get();

  return result.docs.map((doc) => doc.data()).toList();
}

Future<List<Map<String, dynamic>>> getPlaylistOthersInfo() async {
  var result = await FirebaseFirestore.instance
      .collection('playlist')
      .where('uid', whereIn: playlistOthers)
      .get();

  return result.docs.map((doc) => doc.data()).toList();
}

var mateListReal = [];
var mateListFriend = [];
var playlistMy = [];
var playlistOthers = [];

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
            ),
            title: Text(
              "마이페이지",
              style: bold16.copyWith(color: AppColor.text),
            ),
            actions: [
              PopupMenuButton<int>(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                offset: const Offset(0, 50),
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
                          style: medium14.copyWith(color: AppColor.sub1)),
                    ),
                  ),
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
                          style: medium14.copyWith(color: AppColor.sub1)),
                    ),
                  ),
                ],
              )
            ],
          ),
          body: FutureBuilder<Map<String, dynamic>>(
            future: getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var userInfo = snapshot.data!;

                mateListFriend =
                    userInfo['mate_friend'] as List<dynamic>? ?? [];
                mateListReal = userInfo['mate_real'] as List<dynamic>? ?? [];
                playlistMy = userInfo['playlist_my'] as List<dynamic>? ?? [];
                playlistOthers =
                    userInfo['playlist_others'] as List<dynamic>? ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          radius: 36,
                          backgroundImage:
                              NetworkImage(userInfo['profileImage']),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(userInfo['nickName'],
                                style: bold18.copyWith(color: AppColor.text)),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyStarMate(),
                                  ),
                                );
                              },
                              child: Text(
                                '${mateListFriend.length + mateListReal.length - 2}  스타 메이트',
                                style: medium13.copyWith(color: AppColor.text),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Text(userInfo['email'],
                                style:
                                    regular15.copyWith(color: AppColor.sub2)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const TabBar(
                      labelColor: AppColor.text,
                      indicatorColor:
                          AppColor.text, //tabbar 아랫 부분에 흰색 줄 (움직이는거)
                      tabs: [
                        Tab(text: "내 플리"),
                        Tab(text: "저장한 플리"),
                      ],
                    ),
                    Expanded(
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class MySongList extends StatelessWidget {
  MySongList({Key? key}) : super(key: key);
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getPlaylistMyInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var playlistInfoList = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: playlistInfoList.length,
            itemBuilder: (BuildContext context, int index) {
              var playlistInfo = playlistInfoList[index];
              imageUrl = playlistInfo['image_url'] ?? '없음';
              debugPrint('$imageUrl입니다!');
              return MySong(imageUrl: imageUrl);
            },
          );
        }
      },
    );
  }
}

class MySong extends StatefulWidget {
  final String imageUrl;

  const MySong({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<MySong> createState() => _MySongState();
}

class _MySongState extends State<MySong> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.3),
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.fill,
          ),
        ),
        child: const SizedBox());
  }
}

class SaveSongList extends StatelessWidget {
  SaveSongList({Key? key}) : super(key: key);
  String imageUrl = '';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getPlaylistOthersInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var playlistInfoList = snapshot.data!;
          debugPrint(playlistInfoList[1]['imageUrl']);
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: playlistInfoList.length,
            itemBuilder: (BuildContext context, int index) {
              var playlistInfo = playlistInfoList[index];
              imageUrl = playlistInfo['image_url'] ?? '없음';
              debugPrint('$imageUrl입니다!');
              return MySong(imageUrl: imageUrl);
            },
          );
        }
      },
    );
  }
}

class SaveSong extends StatefulWidget {
  final String imageUrl;

  const SaveSong({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<MySong> createState() => _SaveSongState();
}

class _SaveSongState extends State<MySong> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.3),
          image: DecorationImage(
            image: NetworkImage(widget.imageUrl),
            fit: BoxFit.fill,
          ),
        ),
        child: const SizedBox());
  }
}
