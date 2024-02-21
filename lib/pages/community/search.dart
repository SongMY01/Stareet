import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_api/pages/community/mate_detail.dart';
import 'package:music_api/pages/community/star_detail.dart';
import 'package:music_api/pages/mypage/my_page.dart';
import 'package:music_api/utilities/info.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
//------ 페이지 3, 5

//TabBar PalyList
class TabOne extends StatelessWidget {
  final String query;
  const TabOne({
    Key? key,
    required this.query,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('playlist')
            .where('title',
                isGreaterThanOrEqualTo: query) // Here is the use of query
            .where('title', isLessThan: query + 'z') // Here is the use of query
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 28,
              mainAxisExtent: 230,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              PlaylistInfo playlistInfo = PlaylistInfo.fromFirebase(snapshot
                  .data!
                  .docs[index] as QueryDocumentSnapshot<Map<String, dynamic>>);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StarDetail(
                          owner: playlistInfo.owner ?? 'default_owner',
                          image_url:
                              playlistInfo.image_url ?? 'default_image_url',
                          title: playlistInfo.title ?? 'default_title',
                          nickname: playlistInfo.nickname ?? 'default_nickname',
                          uid: playlistInfo.uid as String),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Image.asset('assets/fonts/images/starback.png'),
                    Positioned(
                      left: 25,
                      bottom: 27.5,
                      child: SizedBox(
                        height: 174.232,
                        child: Image.network(
                          playlistInfo.image_url ?? 'default_image_url',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      bottom: 45,
                      child: SizedBox(
                          height: 17,
                          child:
                              Image.asset('assets/fonts/images/profile.png')),
                    ),
                    Positioned(
                      left: 35,
                      bottom: 44,
                      child: Text(
                        playlistInfo.nickname ?? 'default_owner',
                        style: medium11.copyWith(color: AppColor.sub1),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      bottom: 23,
                      child: Text(
                        playlistInfo.title ?? 'default_title',
                        style: bold15,
                      ),
                    ),
                    Positioned(
                      left: 15,
                      bottom: 8,
                      child: Text(
                        "8개의 곡",
                        style: medium11.copyWith(color: AppColor.sub1),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<String> fetchAuthInfo() async {
  String currentUserNickName = '';
  var docref = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  await docref.get().then((doc) => {
        currentUserNickName = doc.data()![userNameFieldName],
      });

  return currentUserNickName;
}

class TabTwo extends StatefulWidget {
  final String query;
  const TabTwo({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<TabTwo> createState() => _TabTwoState();
}

class _TabTwoState extends State<TabTwo> {
  List<bool> mateRequested = List.generate(5, (index) => false);
  late String currentUserNickName;

  @override
  void initState() {
    super.initState();
    fetchAuthInfo().then((value) {
      setState(() {
        currentUserNickName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('user')
          .where('nickName', isGreaterThanOrEqualTo: widget.query)
          .where('nickName', isLessThan: widget.query + 'z')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (BuildContext context, int index) {
            UsersInfo userInfo = UsersInfo.fromFirebase(snapshot.data!
                .docs[index] as QueryDocumentSnapshot<Map<String, dynamic>>);
            bool isCurrentUser = (userInfo.nickName == currentUserNickName);

            return GestureDetector(
              onTap: () {
                // Navigate to the MyPage if current user, else navigate to MateDetail
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isCurrentUser
                        ? MyPage() //별별게시판에서 유저가 현재 유저이면 mypage로
                        : MateDetail(
                            nickName: userInfo.nickName ?? 'default_owner',
                            profileImage:
                                userInfo.profileImage ?? 'default_image_url',
                          ),
                  ),
                );
              },
              child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Image.network(
                      userInfo.profileImage ?? 'default_image_url',
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill, // 이미지가 공간에 꽉 차도록 조절
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(userInfo.nickName ?? 'default_owner',
                        style: medium16.copyWith(color: Colors.white)),
                  ],
                ),
                trailing: isCurrentUser
                    ? null
                    : SizedBox(
                        height: 30,
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              mateRequested[index] = !mateRequested[index];
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: mateRequested[index]
                                ? const Color.fromRGBO(19, 228, 206, 1)
                                : Colors.black,
                            backgroundColor: mateRequested[index]
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
                            mateRequested[index] ? "메이트" : "메이트 신청",
                            style: mateRequested[index]
                                ? bold12.copyWith(color: AppColor.primary)
                                : bold12.copyWith(color: AppColor.text2),
                          ),
                        ),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
