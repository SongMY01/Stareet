import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_api/pages/mypage/mypage_profile.dart';

import '../community/search.dart';
import '../../utilities/color.dart';
import '../../utilities/text_style.dart';

var mate_ING = [];

class mateMagnage extends StatelessWidget {
  mateMagnage({super.key});

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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(
              child:
                  Text('메이트 관리', style: bold16.copyWith(color: AppColor.text))),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Opacity(
                opacity: 0, // 투명도를 0으로 설정하여 완전히 투명하게 만듭니다.
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: StreamBuilder<Map<String, dynamic>>(
          stream: getUserInfoStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var userInfo = snapshot.data!;
              print(userInfo);
              mate_ING = userInfo['mate_ing'] as List<dynamic>? ?? [];

              print(mate_ING);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  const MateNameListIng(),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

String uid = FirebaseAuth.instance.currentUser!.uid;

Stream<Map<String, dynamic>> getUserInfoStream() {
  return FirebaseFirestore.instance
      .collection('user')
      .doc(uid)
      .snapshots()
      .map((docSnapshot) => docSnapshot.data() as Map<String, dynamic>);
}

OutlineInputBorder myinputborder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        color: Color.fromRGBO(254, 254, 254, 1),
        width: 1,
      ));
}

Stream<List<Map<String, dynamic>>> getMateListRealStream() {
  return FirebaseFirestore.instance
      .collection('user')
      .where('user-id', whereIn: mate_ING)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  });
}

class MateNameListIng extends StatefulWidget {
  const MateNameListIng({Key? key}) : super(key: key);

  @override
  State<MateNameListIng> createState() => _MateNameListIngState();
}

class _MateNameListIngState extends State<MateNameListIng> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: getMateListRealStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var mate_realInfoList = snapshot.data!;

            return Container(
              height: 60.0 * (mate_realInfoList.length) as double,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mate_realInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var mate_realInfo = mate_realInfoList[index];
                  var uid = mate_realInfo['user-id'] ?? '없음';
                  var nickName = mate_realInfo['nickName'] ?? '없음';
                  var imageUrl = mate_realInfo['profileImage'] ?? '없음';
                  print('$imageUrl 입니다요');
                  return MateNameIng(
                    uid: uid,
                    nickName: nickName,
                    imageUrl: imageUrl,
                  );
                },
              ),
            );
          }
        });
  }
}

class MateNameIng extends StatefulWidget {
  final String uid;
  final String nickName;
  final String imageUrl;

  const MateNameIng(
      {Key? key,
      required this.uid,
      required this.nickName,
      required this.imageUrl})
      : super(key: key);

  @override
  _MateNameIngState createState() => _MateNameIngState();
}

class _MateNameIngState extends State<MateNameIng> {
  bool _isStarSelected = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
            ],
          ),
          title: Text(widget.nickName,
              style: medium16.copyWith(color: AppColor.text)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'data,',
                    style: semibold14,
                  )),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'data,',
                    style: semibold14,
                  ))
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
