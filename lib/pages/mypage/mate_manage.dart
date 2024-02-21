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
              mateIng = userInfo['mate_ing'] as List<dynamic>? ?? [];

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



Stream<List<Map<String, dynamic>>> getMateListIngStream() {
  return FirebaseFirestore.instance
      .collection('user')
      .where('user-id', whereIn: mateIng)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => doc.data()).toList();
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
        stream: getMateListIngStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var mateIngInfoList = snapshot.data!;

            return SizedBox(
              height: 60.0 * (mateIngInfoList.length),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mateIngInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var mateRealInfo = mateIngInfoList[index];
                  var uid = mateRealInfo['user-id'] ?? '없음';
                  var nickName = mateRealInfo['nickName'] ?? '없음';
                  var imageUrl = mateRealInfo['profileImage'] ?? '없음';
                 
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
             GestureDetector(
  onTap: () {
    String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
     FirebaseFirestore.instance
                          .collection('user')
                          .doc(currentUserId)
                          .update({
                        'mate_ing': FieldValue.arrayRemove([widget.uid])
                      }).then((_) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUserId)
                            .update({
                          'mate_friend': FieldValue.arrayUnion([widget.uid])
                        });
                      });
                        FirebaseFirestore.instance
                          .collection('user')
                          .doc(widget.uid)
                          .update({
                        'mate_ing': FieldValue.arrayRemove([currentUserId])
                      }).then((_) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.uid)
                            .update({
                          'mate_friend': FieldValue.arrayUnion([currentUserId])
                        });
                      });
  },
  child: Container(
    width: 52,
    height: 33,
    decoration: BoxDecoration(
      color: AppColor.primary, // background color
      borderRadius: BorderRadius.circular(16.0), // border radius
    ),
    child: Center(
      child: Text(
        '수락',
        style: semibold14,
      ),
    ),
  ),
),
SizedBox(
  width: 10,
),
              GestureDetector(
  onTap: () {
    String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
     FirebaseFirestore.instance
                          .collection('user')
                          .doc(currentUserId)
                          .update({
                        'mate_ing': FieldValue.arrayRemove([widget.uid])
                      }).then((_) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(widget.uid)
                            .update({
                          'mate_ing': FieldValue.arrayUnion([currentUserId])
                        });
                      });
  },
  child: Container(
    width: 52,
    height: 33,
    decoration: BoxDecoration(
      color: AppColor.text2, // background color
      borderRadius: BorderRadius.circular(16.0), // border radius
    ),
    child: Center(
      child: Text(
        '거절',
        style: semibold14,
      ),
    ),
  ),
),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
