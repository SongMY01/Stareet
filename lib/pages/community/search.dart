import 'package:flutter/material.dart';
import 'package:music_api/pages/community/mate_detail.dart';
import 'package:music_api/pages/community/star_detail.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
//------ 페이지 3, 5

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
                  builder: (context) => const StarDetail(),
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
                    style: medium11.copyWith(color: AppColor.sub1),
                  ),
                ),
                const Positioned(
                  left: 15,
                  bottom: 23,
                  child: Text(
                    "용가리자리",
                    style: bold15, //bold 17이 큰거 같다.
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
        return GestureDetector(
          onTap: () {
            // Navigate to the MateDetail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MateDetail(),
              ),
            );
          },
          child: ListTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/fonts/images/profile.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.fill, // 이미지가 공간에 꽉 차도록 조절
                ),
                SizedBox(
                  width: 10,
                ),
                Text("좌", style: medium16.copyWith(color: Colors.white)),
              ],
            ),
            trailing: SizedBox(
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
                  mateRequested[index] ? "메트" : "메이트 신청",
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
  }
}
