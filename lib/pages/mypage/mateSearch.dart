import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_api/pages/mypage/mate_manage.dart';
import 'package:music_api/pages/mypage/my_page.dart';
import 'package:music_api/pages/mypage/my_starmate.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
import '../community/search.dart';

class MateNameListSearch extends StatefulWidget {
  final String query;
  final List mateAll;
  const MateNameListSearch({
    Key? key,
    required this.query,
    required this.mateAll
  }) : super(key: key);
  @override
  State<MateNameListSearch> createState() => _MateNameListSearchState();
}



class _MateNameListSearchState extends State<MateNameListSearch> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0 * (widget.mateAll.length),
      child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('user')
              .where('user-id', whereIn: widget.mateAll)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<QueryDocumentSnapshot> mateRealInfoList =
                  snapshot.data!.docs.where((doc) {
                String nickName = doc['nickName'];
                return nickName.compareTo(widget.query) >= 0 &&
                    nickName.compareTo(widget.query + 'z') < 0;
              }).toList();

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mateRealInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var mateFriendInfo = mateRealInfoList[index];
                  var uid = mateFriendInfo['user-id'] ?? '없음';
                  var nickName = mateFriendInfo['nickName'] ?? '없음';
                  var imageUrl = mateFriendInfo['profileImage'] ?? '없음';
                  // debugPrint('$imageUrl 입니다요');
                  return MateNameSearch(
                    uid: uid,
                    nickName: nickName,
                    imageUrl: imageUrl,
                  );
                },
              );
            }
          }),
    );
  }
}

class MateNameSearch extends StatefulWidget {
  final String uid;
  final String nickName;
  final String imageUrl;

  const MateNameSearch(
      {Key? key,
      required this.uid,
      required this.nickName,
      required this.imageUrl})
      : super(key: key);

  @override
  State<MateNameSearch> createState() => _MateNameSearchState();
}

class _MateNameSearchState extends State<MateNameSearch> {
  bool _isStarSelected = false;

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
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                    print(_isStarSelected);
                    if (_isStarSelected) {
                      _isStarSelected = !_isStarSelected;
                      String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      // debugPrint('$currentUserId입니다!');
                      // debugPrint('${widget.uid}입니다');
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(currentUserId)
                          .update({
                        'mate_real': FieldValue.arrayRemove([widget.uid])
                      }).then((_) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUserId)
                            .update({
                          'mate_friend': FieldValue.arrayUnion([widget.uid])
                        });
                      });
                    } else {
                      _isStarSelected = !_isStarSelected;
                      String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      // debugPrint('$currentUserId입니다!');
                      // debugPrint('${widget.uid}입니다');

                      FirebaseFirestore.instance
                          .collection('user')
                          .doc(currentUserId)
                          .update({
                        'mate_friend': FieldValue.arrayRemove([widget.uid])
                      }).then((_) {
                        FirebaseFirestore.instance
                            .collection('user')
                            .doc(currentUserId)
                            .update({
                          'mate_real': FieldValue.arrayUnion([widget.uid])
                        });
                      });
                    }
                  });
                },
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
            ],
          ),
          title: Text(widget.nickName,
              style: medium16.copyWith(color: AppColor.text)),
          trailing: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
                      padding: const EdgeInsets.all(0),
                      width: 270,
                      height: 100,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 44,
                            child: Center(
                              child: Text(
                                '메이트를 삭제하시겠어요?',
                                style: regular17.copyWith(color: AppColor.text),
                              ),
                            ),
                          ),
                          const Divider(),
                          SizedBox(
                            width: 270,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text('취소',
                                          style: regular17.copyWith(
                                              color: AppColor.sub1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: SizedBox(
                                    width: 100,
                                    child: Center(
                                      child: Text('삭제',
                                          style: semibold17.copyWith(
                                              color: AppColor.error)),
                                    ),
                                  ),
                                  onPressed: () {
                                    String currentUserId =
                                        FirebaseAuth.instance.currentUser!.uid;
                                    // debugPrint('$currentUserId입니다!');
                                    // debugPrint('${widget.uid}입니다');

                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(currentUserId)
                                        .update({
                                      'mate_friend':
                                          FieldValue.arrayRemove([widget.uid])
                                    }).then((_) {
                                      debugPrint('${widget.uid}입니다.');
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(currentUserId)
                                          .update({
                                        'mate_real':
                                            FieldValue.arrayRemove([widget.uid])
                                      }).then((_) {
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(widget.uid)
                                            .update({
                                          'mate_real': FieldValue.arrayRemove(
                                              [currentUserId])
                                        }).then((_) {
                                          FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(widget.uid)
                                              .update({
                                            'mate_friend':
                                                FieldValue.arrayRemove(
                                                    [currentUserId])
                                          }).then((_) {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MyStarMate(),
                                              ),
                                            );
                                          });
                                        });
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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