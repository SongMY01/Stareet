import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../custom.dart';
import '../utils/text_style.dart';
import '/helpers/data_search.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xff2d2d2d),
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        elevation: 0.5,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CustomSearchPage()));
            // showSearch(context: context, delegate: DataSearch());
          },
          child: Container(
            width: 340,
            height: 36,
            color: Color.fromRGBO(255, 255, 255, 0.1),
            // child: SizedBox(
            //   width: 340,
            //   height: 36,
            //   child: TextField(
            //       decoration: InputDecoration(
            //     filled: true,
            //     fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
            //     labelText: "별자리 이름이나, 메이트 이름을 검색해요",
            //     labelStyle: sub_text2,
            //     border: myinputborder(), //normal border
            //     enabledBorder: myinputborder(), //enabled border
            //     // set more border style like disabledBorder
            //     prefixIcon: Icon(
            //       Icons.search, // 여기에 원하는 아이콘을 지정
            //       color: Colors.white, // 아이콘 색상 설정
            //     ),
            //   )),
            // ),
          ),
        ));
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
