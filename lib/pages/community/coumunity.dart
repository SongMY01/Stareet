import 'package:flutter/material.dart';

import '../../utilities/color.dart';
import '../../utilities/text_style.dart';
import '../mypage/my_page.dart';
import 'search.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ))
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
                  onSubmitted: (String searchText) {
                    // Navigate to the SearchedTabBar page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchedTabBar(searchText: searchText),
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                    labelText: "별자리 이름이나, 메이트 이름을 검색해요",
                    labelStyle: medium14.copyWith(color: AppColor.subtext2),
                    border: myinputborder(),
                    enabledBorder: myinputborder(),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 29),
            Expanded(
              child: ListView(
                children: [
                  Text(
                    "지금 핫한 별플리",
                    style: bold20.copyWith(color: AppColor.subtext1),
                  ),
                  const SizedBox(height: 29),
                  const StarPictureList(),
                  const SizedBox(height: 29),
                  Text(
                    "주변 지역에서 추천하는 음악",
                    style: bold20.copyWith(color: AppColor.subtext1),
                  ),
                  const SizedBox(height: 29),
                  const SongPictureList(),
                  const SizedBox(
                    height: 29,
                  ),
                ],
              ),
            ),
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

//지금 핫한 별플리
class StarPictureList extends StatelessWidget {
  const StarPictureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280.803,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return const StarPicture();
        },
      ),
    );
  }
}

class StarPicture extends StatelessWidget {
  const StarPicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 12,
        ),
        Container(
          height: 280.803,
          width: 191,
          child: Stack(
            children: [
              Image.asset('assets/fonts/images/starback.png'),
              Positioned(
                left: 30,
                bottom: 20,
                child: Image.asset('assets/fonts/images/stars.png'),
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
                  "좌",
                  style: medium11.copyWith(color: AppColor.subtext1),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 27,
                child: Text(
                  "용가리자리",
                  style: bold17.copyWith(color: AppColor.subtext1),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 10,
                child: Text(
                  "8개의 곡",
                  style: medium11.copyWith(color: AppColor.subtext1),
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
              child:
                  Text("최유리", style: bold12.copyWith(color: AppColor.subtext1)),
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
