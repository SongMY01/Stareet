import 'package:flutter/material.dart';

import '../../utilities/color.dart';
import '../../utilities/text_style.dart';
import 'mate_detail.dart';
import 'star_detail.dart';

//------ 페이지 3, 5
class SearchedTabBar extends StatelessWidget {
  final String searchText;

  const SearchedTabBar({required this.searchText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      initialIndex: 0, // Initial selected tab index
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
            title: Text("별별 게시판 $searchText",
                style: bold16.copyWith(color: AppColor.subtext1)),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
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
              TabBar(
                labelStyle: bold14.copyWith(color: AppColor.text),
                labelColor: AppColor.text,
                indicatorColor: AppColor.text, //tabbar 아랫 부분에 흰색 줄 (움직이는거)
                tabs: [
                  Tab(text: "플리"),
                  Tab(text: "스타메이트"),
                ],
              ),
              const SizedBox(height: 20),
              // The TabBarView with the associated content for each tab
              const Expanded(
                child: TabBarView(
                  children: [
                    // Content for Tab 1
                    TabOne(),
                    // Content for Tab 2
                    TabTwo(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Textfield Deco
OutlineInputBorder myinputborder() {
  return const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(
      color: Color.fromRGBO(254, 254, 254, 1),
      width: 1,
    ),
  );
}

//TabBar PalyList
class TabOne extends StatelessWidget {
  const TabOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 28,
          mainAxisExtent: 230, //gridview 크기 변형 가능
          //   mainAxisSpacing: 15.0, //gridview 위아래 space 높이 설정
        ),
        itemCount: 9,
        //  shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the StarDetail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StarDetail(),
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
                    child: Image.asset('assets/fonts/images/stars.png'),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 45,
                  child: SizedBox(
                      height: 17,
                      child: Image.asset('assets/fonts/images/profile.png')),
                ),
                Positioned(
                  left: 35,
                  bottom: 44,
                  child: Text(
                    "좌",
                    style: medium11.copyWith(color: AppColor.subtext1),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 23,
                  child: Text(
                    "용가리자리",
                    style:
                        bold15.copyWith(color: AppColor.text), //bold 17이 큰거 같다.
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 8,
                  child: Text(
                    "8개의 곡",
                    style: medium11.copyWith(color: AppColor.subtext1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TabTwo extends StatefulWidget {
  const TabTwo({Key? key});

  @override
  _TabTwoState createState() => _TabTwoState();
}

class _TabTwoState extends State<TabTwo> {
  List<bool> mateRequested = List.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Card(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                // Navigate to the MateDetail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MateDetail(),
                  ),
                );
              },
              child: ListTile(
                leading: Image.asset('assets/fonts/images/profile.png'),
                title: Text("좌", style: medium16.copyWith(color: Colors.white)),
                trailing: SizedBox(
                  height: 28,
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
                      style: bold13.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
