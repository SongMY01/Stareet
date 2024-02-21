import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_api/pages/mypage/mateSearch.dart';
import 'package:music_api/pages/mypage/mate_manage.dart';
import 'package:music_api/pages/mypage/my_page.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
import '../community/search.dart';

var mateReal = [];
var mateFriend = [];
var mateAll = [];

class MyStarMate extends StatefulWidget {
  const MyStarMate({
    Key? key,
  }) : super(key: key);

  @override
  State<MyStarMate> createState() => _MyStarMateState();
}

class _MyStarMateState extends State<MyStarMate> {
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
    var userInfo = snapshot.data();

    setState(() {
      mateReal = userInfo!['mate_real'] as List<dynamic>? ?? [];
      mateFriend = userInfo['mate_friend'] as List<dynamic>? ?? [];
      mateAll = mateReal + mateFriend;
    });
    print('${mateAll}every all!!!');
  }

  final searchController = TextEditingController();
  String query = '';
  FocusNode textfieldFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                        builder: (context) => const MateManage(),
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              const SizedBox(height: 10),
              SizedBox(
                width: 340,
                height: 36,
                child: Form(
                  key: _formKey,
                  child: TextField(
                    focusNode: textfieldFocusNode,
                    controller: searchController,
                    key: UniqueKey(),
                    style: medium16,
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                      filled: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                      border: OutlineInputBorder(
                        // 테두리 스타일 정의
                        borderRadius:
                            BorderRadius.circular(5.0), // border-radius: 5px
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(
                              255, 255, 255, 0.3), // border 색상과 투명도
                          width: 1.0, // border: 1px
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // 기본 테두리 스타일
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        // 포커스 시 테두리 스타일
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                          width: 1.0,
                        ),
                      ),
                      hintStyle: medium14.copyWith(color: AppColor.sub2),
                      hintText: '별자리 이름이나, 메이트 이름을 검색하세요',
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            query = '';
                          },
                          icon: const Icon(Icons.close, color: Colors.white)),
                    ),
                    // onChanged: (value) {
                    //   setState(() {
                    //     query = value;
                    //   });
                    // },
                    onSubmitted: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (mateReal.isNotEmpty && mateFriend.isNotEmpty)
                if (query.isNotEmpty)
                  _buildSearchedTabBar(query)
                else
                  _buildEveryList()
            ],
          )),
    );
  }
}

Widget _buildEveryList() {
  return const Column(
    children: [
      MateNameListReal(),
      SizedBox(height: 10),
      MateNameListFriend(),
    ],
  );
}

String uid = FirebaseAuth.instance.currentUser!.uid;

class MateNameListReal extends StatefulWidget {
  const MateNameListReal({Key? key}) : super(key: key);

  @override
  State<MateNameListReal> createState() => _MateNameListRealState();
}

class _MateNameListRealState extends State<MateNameListReal> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('user')
            .where('user-id', whereIn: mateReal)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var mateRealInfoList = snapshot.data!.docs;

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
  State<MateNameReal> createState() => _MateNameRealState();
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
                                      // debugPrint('${widget.uid}입니다.');
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
      .where('user-id', whereIn: mateFriend)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs.map((doc) => doc.data()).toList();
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
    return SizedBox(
      height: 60.0 * (mateFriend.length),
      child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('user')
              .where('user-id', whereIn: mateFriend)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var mateRealInfoList = snapshot.data!.docs;

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: mateRealInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  var mateFriendInfo = mateRealInfoList[index];
                  var uid = mateFriendInfo['user-id'] ?? '없음';
                  var nickName = mateFriendInfo['nickName'] ?? '없음';
                  var imageUrl = mateFriendInfo['profileImage'] ?? '없음';
                  // debugPrint('$imageUrl 입니다요');
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
  State<MateNameFriend> createState() => _MateNameFriendState();
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
                    print(_isStarSelected);
                    if (_isStarSelected) {
                      _isStarSelected = !_isStarSelected;
                      String currentUserId =
                          FirebaseAuth.instance.currentUser!.uid;
                      debugPrint('$currentUserId입니다!');
                      debugPrint('${widget.uid}입니다');
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
                                      // debugPrint('${widget.uid}입니다.');
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



Widget _buildSearchedTabBar(String query) {
  return Expanded(
    child:
        Column(children: [MateNameListSearch(query: query, mateAll: mateAll)]),
  );
}
