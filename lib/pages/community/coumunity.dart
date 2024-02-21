import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_api/components/card_frame.dart';
import 'package:music_api/components/custom_drawer.dart';
import 'package:music_api/pages/community/star_detail.dart';
import 'package:music_api/utilities/info.dart';
import 'package:music_api/youtube/music/video_detail_page.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
import '../mypage/my_page.dart';
import 'search.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPage();
}

class _CommunityPage extends State<CommunityPage> {
  final searchController = TextEditingController();
  String query = '';

  List? contentList;
  bool isLoading = false;
  bool firstLoad = true;

  FocusNode textfieldFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: Center(
            child: Text(
              "별별게시판",
              style: bold16.copyWith(color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final uid = user?.uid;

                if (uid != null) {
                  final docSnap = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .get();
                  final userInfo = UsersInfo.fromFirebase(docSnap);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomDrawer(),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 29),
            Center(
              child: SizedBox(
                width: 340,
                height: 36,
                child: TextField(
                  focusNode: textfieldFocusNode,
                  controller: searchController,
                  style: medium16,
                  decoration: InputDecoration(
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    border: OutlineInputBorder(
                      // 테두리 스타일 정의
                      borderRadius:
                          BorderRadius.circular(5.0), // border-radius: 5px
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(
                            255, 255, 255, 0.3), // border 색상과 투명도
                        width: 1.0, // border: 1px
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // 기본 테두리 스타일
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 포커스 시 테두리 스타일
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        width: 1.0,
                      ),
                    ),
                    hintStyle: medium14.copyWith(color: AppColor.sub2),
                    hintText: '별자리 이름이나, 메이트 이름을 검색하세요',
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          query = '';
                        },
                        icon: const Icon(Icons.close, color: Colors.white)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value; //textfield 입력하자마자 바뀜
                    });
                  },
                  onSubmitted: (value) {
                    setState(() {
                      query = value; //textfield 입력 후 enter 누르면 바뀜
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            query.isNotEmpty
                ? _buildSearchedTabBar(query)
                : _buildCommunitySearch() //textfield에 무언가는 입력했을 때 SearchedTabBar가 나오고 아무것도 입력하지 않으면 CommunitySearch가 나옴
          ],
        ),
      ),
    );
  }
}

//Textfield Deco
OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return const OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: Color.fromRGBO(254, 254, 254, 1),
        width: 1,
      ));
}

Widget _buildSearchedTabBar(String query) {
  return Expanded(
    child: DefaultTabController(
      length: 2, // Number of tabs
      initialIndex: 0, // Initial selected tab index
      child: Column(
        children: [
          TabBar(
            labelStyle: bold14.copyWith(color: AppColor.text),
            labelColor: AppColor.text,
            indicatorColor: AppColor.text, //tabbar 아랫 부분에 흰색 줄 (움직이는거)
            tabs: const [
              Tab(text: "플리"),
              Tab(text: "스타메이트"),
            ],
          ),
          const SizedBox(height: 20),
          // The TabBarView with the associated content for each tab
          Expanded(
            child: TabBarView(
              children: [
                // Content for Tab 1
                TabOne(query: query),
                // Content for Tab 2
                TabTwo(query: query),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCommunitySearch() {
  return Expanded(
    child: ListView(
      children: [
        Row(
          children: [
            SizedBox(width: 12),
            Text(
              "지금 핫한 별플리",
              style: bold20.copyWith(color: AppColor.sub1),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const StarPictureList(),
        const SizedBox(height: 25),
        Row(
          children: [
            SizedBox(width: 12),
            Text(
              "주변 지역에서 추천하는 음악",
              style: bold20.copyWith(color: AppColor.sub1),
            ),
          ],
        ),
        const SizedBox(height: 25),
        const SongPictureList(),
        const SizedBox(
          height: 29,
        ),
      ],
    ),
  );
}

//지금 핫한 별플리
class StarPictureList extends StatelessWidget {
  const StarPictureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.803,
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('playlist').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          } //이 부분은 별별게시판에서 지금 핫 별플리 사진 로딩 중에 오류 생기면 나옴

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              PlaylistInfo playlistInfo = PlaylistInfo.fromFirebase(snapshot
                  .data!
                  .docs[index] as QueryDocumentSnapshot<Map<String, dynamic>>);
              return StarPicture(
                  imgurl: playlistInfo.image_url,
                  owner: playlistInfo.nickname,
                  title: playlistInfo.title,
                  uid: playlistInfo.owner,
                  song: playlistInfo.stars_id);
            },
          );
        },
      ),
    );
  }
}

class StarPicture extends StatelessWidget {
  final String? imgurl;
  final String? owner;
  final String? title;
  final String? uid;
  final List<dynamic>? song;

  const StarPicture(
      {Key? key,
      required this.imgurl,
      required this.owner,
      required this.title,
      required this.uid,
      required this.song})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 12,
        ),
        SizedBox(
          height: 280.803,
          width: 191,
          child: StarCard(
            child: Stack(
              children: [
                Positioned(
                  // right: 5,
                  bottom: 77,
                  // top: 5,
                  left: -4,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => StarDetail(
                      //       owner: owner ?? 'default_owner',
                      //       image_url: imgurl ?? 'default_image_url',
                      //       title: title ?? 'default_title',
                      //       nickname: owner ?? 'default_nickname',
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      height: 275,
                      width: 186,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(72),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(imgurl!),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 7,
                  bottom: 130,
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc(uid)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // 로딩 인디케이터를 보여줍니다.
                      } else if (snapshot.hasError) {
                        return Text(
                            "Error: ${snapshot.error}"); // 에러가 발생하면 에러 메시지를 보여줍니다.
                      } else {
                        Map<String, dynamic> data = snapshot.data!.data()
                            as Map<String, dynamic>; // 문서의 데이터를 가져옵니다.
                        return ClipOval(
                          child: Image.network(
                            data['profileImage'],
                            height: 20,
                            width: 20,
                            fit: BoxFit.cover,
                          ),
                        ); // 'profileImage' 필드의 값을 사용하여 이미지를 로드하고, ClipOval 위젯으로 원형으로 만듭니다.
                      }
                    },
                  ),
                ),
                Positioned(
                  left: 33,
                  bottom: 132,
                  child: Text(
                    owner!,
                    style: medium12.copyWith(color: Colors.white),
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 105,
                  child: Text(
                    title!,
                    style: bold17.copyWith(color: AppColor.sub1),
                  ),
                ),
                Positioned(
                  left: 50,
                  bottom: 88,
                  child: Text(
                    "${song?.length ?? 0}개의 곡",
                    style: medium11.copyWith(color: AppColor.sub1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        )
      ],
    );
  }
}

class SongPictureList extends StatefulWidget {
  const SongPictureList({Key? key}) : super(key: key);

  @override
  _SongPictureListState createState() => _SongPictureListState();
}

class _SongPictureListState extends State<SongPictureList> {
  late Future<QuerySnapshot> future;

  @override
  void initState() {
    super.initState();
    future = FirebaseFirestore.instance.collection('user').get();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206, // Set an appropriate height,
      child: FutureBuilder<QuerySnapshot>(
        future: future,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loadingg");
          }

          // 'user' 컬렉션의 모든 문서 목록
          final allDocs = snapshot.data!.docs;

          // 랜덤하게 두 개의 문서를 선택
          final docs = List<DocumentSnapshot>.from(allDocs)..shuffle();
          final selectedDocs = docs.take(3).toList();

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selectedDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final userDoc = selectedDocs[index];

              return StreamBuilder<QuerySnapshot>(
                stream: userDoc.reference.collection('Star').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }

                  final List<SongInfo> songs = snapshot.data!.docs.map((doc) {
                    return SongInfo.fromFirebase(
                        doc as QueryDocumentSnapshot<Map<String, dynamic>>);
                  }).toList();

                  return Row(
                    children: songs.map((song) {
                      return SongPicture(
                        videoId: song.videoId,
                        singer: song.singer,
                        title: song.title,
                        uid: song.uid,
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class SongPicture extends StatelessWidget {
  final String? videoId;
  final String? singer;
  final String? title;
  final String? uid;

  const SongPicture({
    Key? key,
    required this.videoId,
    required this.singer,
    required this.title,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 15,
        ),
        SizedBox(
          height: 206,
          width: 144,
          child: StarCard(
            child: Stack(
              children: [
                Positioned(
                  bottom: 150, // bottom 값을 조절해 위치를 원하는 대로 조정하세요.
                  left: -6,
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => VideoDetailPage(
                      //         markerId: StarInfo.,
                      //         ownerId: uid ?? 'uid error',
                      //         videoId: videoId as String,
                      //         nickName: sin,
                      //         profileImg: profileImg),
                      //   ),
                      // );
                    },
                    child: Container(
                      height: 202,
                      width: 140,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(72),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://i1.ytimg.com/vi/$videoId/maxresdefault.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  bottom: 170,
                  child: Text(
                    title!,
                    style: medium12.copyWith(color: AppColor.text),
                  ),
                ),
                Positioned(
                  left: 5,
                  bottom: 153,
                  child: Text(singer!,
                      style: bold10.copyWith(color: AppColor.text)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
