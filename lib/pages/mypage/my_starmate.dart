import 'package:flutter/material.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';

class MyStarMate extends StatelessWidget {
  const MyStarMate({super.key});

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
          title: Text('스타메이트', style: bold16.copyWith(color: AppColor.text)),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            const Divider(),
            const SizedBox(height: 10),
            SizedBox(
              width: 340,
              height: 36,
              child: TextField(
                onSubmitted: (String searchText) {
                  // Navigate to the SearchedTabBar page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         SearchedTabBar(searchText: searchText),
                  //   ),
                  // );
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                  labelText: "메이트 이름을 검색해요",
                  labelStyle: medium14.copyWith(color: AppColor.sub1),
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const MateNameList(),
          ],
        ),
      ),
    );
  }
}

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

class MateNameList extends StatelessWidget {
  const MateNameList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return const MateName();
        },
      ),
    );
  }
}

class MateName extends StatefulWidget {
  const MateName({Key? key}) : super(key: key);

  @override
  _MateNameState createState() => _MateNameState();
}

class _MateNameState extends State<MateName> {
  bool _isStarSelected = false; // 별 아이콘이 선택되었는지 상태를 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Container(
                  width: 30, // 원하는 크기로 지정
                  height: 30, // 원하는 크기로 지정
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // border radius 설정
                  ),
                  child: Icon(
                    Icons.star,
                    color: _isStarSelected
                        ? const Color.fromRGBO(19, 228, 206, 1)
                        : Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isStarSelected = !_isStarSelected;
                  });
                },
              ),
              Image.asset('assets/fonts/images/profile.png'),
            ],
          ),
          title: Text("소다", style: medium16.copyWith(color: AppColor.text)),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromRGBO(37, 37, 37, 1),
                    title: Center(
                      child: Text(
                        '메이트를 삭제하시겠어요?',
                        style: regular17.copyWith(color: AppColor.text),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('취소',
                            style:
                                regular17.copyWith(color: AppColor.sub1)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Spacer(),
                      TextButton(
                        child: Text('삭제',
                            style: semibold17.copyWith(color: AppColor.error)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
