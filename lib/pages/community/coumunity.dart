import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_api/utilities/info.dart';

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
                      builder: (context) => MyPage(nickName: userInfo.nickName),
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
        Text(
          "지금 핫한 별플리",
          style: bold20.copyWith(color: AppColor.sub1),
        ),
        const SizedBox(height: 29),
        const StarPictureList(),
        const SizedBox(height: 29),
        Text(
          "주변 지역에서 추천하는 음악",
          style: bold20.copyWith(color: AppColor.sub1),
        ),
        const SizedBox(height: 29),
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
                  owner: playlistInfo.owner,
                  title: playlistInfo.title);
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

  const StarPicture(
      {Key? key,
      required this.imgurl,
      required this.owner,
      required this.title})
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
          child: Stack(
            children: [
              Image.asset('assets/fonts/images/starback.png'),
              Positioned(
                left: 30,
                bottom: 20,
                child: Image.network(
                  imgurl!,
                  height: 50,
                  width: 50,
                ),
              ),
              Positioned(
                left: 20,
                bottom: 55,
                child: Image.asset('assets/fonts/images/profile.png'),
              ),
              Positioned(
                left: 43,
                bottom: 53,
                child: Text(
                  owner!,
                  style: medium11.copyWith(color: AppColor.sub1),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 27,
                child: Text(
                  title!,
                  style: bold17.copyWith(color: AppColor.sub1),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 10,
                child: Text(
                  "8개의 곡",
                  style: medium11.copyWith(color: AppColor.sub1),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        )
      ],
    );
  }
}

class SongPictureList extends StatelessWidget {
  const SongPictureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 206, // Set an appropriate height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return const SongPicture(); // Use SongPicture instead of StarPicture
        },
      ),
    );
  }
}

class SongPicture extends StatelessWidget {
  const SongPicture({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 12,
        ),
        Stack(
          children: [
            Image.asset('assets/fonts/images/song.png'),
            Positioned(
              left: 20,
              bottom: 27,
              child: Text(
                "잘 지내자, 우리",
                style: medium16.copyWith(color: AppColor.text),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 10,
              child: Text("최유리", style: bold12.copyWith(color: AppColor.sub1)),
            ),
          ],
        ),
        const SizedBox(
          width: 12,
        )
      ],
    );
  }
}
