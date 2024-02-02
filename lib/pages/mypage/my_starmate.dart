import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_api/pages/mypage/mate_manage.dart';
import 'package:music_api/pages/mypage/mypage_profile.dart';

import '../community/search.dart';
import '../../utilities/color.dart';
import '../../utilities/text_style.dart';

var mate_real = [];
var mate_friend = [];

class MyStarMate extends StatelessWidget {
  MyStarMate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
              Navigator.pushNamed(context, '/mypage');
            },
          ),
          title: Text('스타메이트', style: bold16.copyWith(color: AppColor.text)),
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 25, 0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => mateMagnage(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/starmate.png',
                  width: 26,
                  height: 26,
                ),
              ),
            )
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
              mate_real = userInfo['mate_real'] as List<dynamic>? ?? [];
              mate_friend = userInfo['mate_friend'] as List<dynamic>? ?? [];
              print(mate_real);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 340,
                    height: 36,
                    child: TextField(
                      onSubmitted: (String searchText) {
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
                        labelText: "메이트 이름을 검색해요",
                        labelStyle: medium14.copyWith(color: AppColor.subtext1),
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
                  const MateNameListReal(),
                  const SizedBox(height: 10),
                  const MateNameListFriend(),
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
      .where('user-id', whereIn: mate_real)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  });
}

class MateNameListReal extends StatefulWidget {
  const MateNameListReal({Key? key}) : super(key: key);

  @override
  State<MateNameListReal> createState() => _MateNameListRealState();
}

class _MateNameListRealState extends State<MateNameListReal> {
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
                  return MateNameReal(
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

class MateNameReal extends StatefulWidget {
  final String uid;
  final String nickName;
  final String imageUrl;

  const MateNameReal(
      {Key? key,
      required this.uid,
      required this.nickName,
      required this.imageUrl})
      : super(key: key);

  @override
  _MateNameRealState createState() => _MateNameRealState();
}

class _MateNameRealState extends State<MateNameReal> {
  bool _isStarSelected = true;

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
                    _isStarSelected = !_isStarSelected;
                    String currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;
                    print('${currentUserId}입니다!');
                    print('${widget.uid}입니다');
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
                      padding: EdgeInsets.all(0),
                      width: 270,
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            height: 44,
                            child: Center(
                              child: Text(
                                '메이트를 삭제하시겠어요?',
                                style: regular17.copyWith(color: AppColor.text),
                              ),
                            ),
                          ),
                          Divider(),
                          Container(
                            width: 270,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    child: Center(
                                      child: Text('취소',
                                          style: regular17.copyWith(
                                              color: AppColor.subtext1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Container(
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
                                    print('${currentUserId}입니다!');
                                    print('${widget.uid}입니다');

                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(currentUserId)
                                        .update({
                                      'mate_friend':
                                          FieldValue.arrayRemove([widget.uid])
                                    }).then((_) {
                                      print('${widget.uid}입니다.');
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

Stream<List<Map<String, dynamic>>> getMateListFriendStream() {
  return FirebaseFirestore.instance
      .collection('user')
      .where('user-id', whereIn: mate_friend)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  });
}

class MateNameListFriend extends StatefulWidget {
  const MateNameListFriend({Key? key}) : super(key: key);

  @override
  State<MateNameListFriend> createState() => _MateNameListFriendState();
}

class _MateNameListFriendState extends State<MateNameListFriend> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0 * (mate_friend.length) as double,
      child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: getMateListFriendStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var mate_realInfoList = snapshot.data!;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mate_realInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var mate_friendInfo = mate_realInfoList[index];
                  var uid = mate_friendInfo['user-id'] ?? '없음';
                  var nickName = mate_friendInfo['nickName'] ?? '없음';
                  var imageUrl = mate_friendInfo['profileImage'] ?? '없음';
                  print('$imageUrl 입니다요');
                  return MateNameFriend(
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

class MateNameFriend extends StatefulWidget {
  final String uid;
  final String nickName;
  final String imageUrl;

  const MateNameFriend(
      {Key? key,
      required this.uid,
      required this.nickName,
      required this.imageUrl})
      : super(key: key);

  @override
  _MateNameFriendState createState() => _MateNameFriendState();
}

class _MateNameFriendState extends State<MateNameFriend> {
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
                    _isStarSelected = !_isStarSelected;
                    String currentUserId =
                        FirebaseAuth.instance.currentUser!.uid;
                    print('${currentUserId}입니다!');
                    print('${widget.uid}입니다');
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
                      padding: EdgeInsets.all(0),
                      width: 270,
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            height: 44,
                            child: Center(
                              child: Text(
                                '메이트를 삭제하시겠어요?',
                                style: regular17.copyWith(color: AppColor.text),
                              ),
                            ),
                          ),
                          Divider(),
                          Container(
                            width: 270,
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Container(
                                    width: 100,
                                    child: Center(
                                      child: Text('취소',
                                          style: regular17.copyWith(
                                              color: AppColor.subtext1)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Container(
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
                                    print('${currentUserId}입니다!');
                                    print('${widget.uid}입니다');

                                    FirebaseFirestore.instance
                                        .collection('user')
                                        .doc(currentUserId)
                                        .update({
                                      'mate_friend':
                                          FieldValue.arrayRemove([widget.uid])
                                    }).then((_) {
                                      print('${widget.uid}입니다.');
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
