import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';

var mateIng = [];

class MateManage extends StatelessWidget {
  const MateManage({super.key});

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
            icon: const Icon(Icons.arrow_back),
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
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var userInfo = snapshot.data!;
              debugPrint(userInfo as String?);
              mateIng = userInfo['mate_ing'] as List<dynamic>? ?? [];

              debugPrint(mateIng as String?);
              return const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(),
                  MateNameListIng(),
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
      .where('user-id', whereIn: mateIng)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => doc.data())
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var mateRealInfoList = snapshot.data!;

            return SizedBox(
              height: 60.0 * (mateRealInfoList.length),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mateRealInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var mateRealInfo = mateRealInfoList[index];
                  var uid = mateRealInfo['user-id'] ?? '없음';
                  var nickName = mateRealInfo['nickName'] ?? '없음';
                  var imageUrl = mateRealInfo['profileImage'] ?? '없음';
                  debugPrint('$imageUrl 입니다요');
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
  State<MateNameIng> createState() => _MateNameIngState();
}

class _MateNameIngState extends State<MateNameIng> {
  final bool _isStarSelected = true;

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
                  child: const Text(
                    'data,',
                    style: semibold14,
                  )),
              TextButton(
                  onPressed: () {},
                  child: const Text(
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
