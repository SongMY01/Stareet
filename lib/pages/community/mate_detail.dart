import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_api/utilities/info.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';

//tabtwo에서 유저 누르면 detail page
class MateDetail extends StatefulWidget {
  final String nickName;
  final String profileImage;

  const MateDetail(
      {Key? key, required this.nickName, required this.profileImage})
      : super(key: key);

  @override
  _MateDetailState createState() => _MateDetailState(nickName, profileImage);
}

class _MateDetailState extends State<MateDetail> {
  final String owner;
  final String profileImage;

  _MateDetailState(this.owner, this.profileImage);
  bool mateRequested = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            backgroundColor: Colors.transparent,
            actions: [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  // 메뉴 항목을 선택했을 때 실행될 코드
                  debugPrint(value); // 선택된 값을 사용하여 로직을 처리할 수 있습니다.
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'report', // 메뉴 항목의 값을 설정합니다.
                    child: Container(
                      height: 20.0, // 원하는 높이로 설정
                      width: 80.0, // 원하는 너비로 설정
                      alignment: Alignment.center,
                      child: const Text(
                        '신고하기',
                        style: TextStyle(color: Colors.white), // 텍스트 색상 설정
                      ),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert, color: Colors.white),
                // 팝업 메뉴의 위치를 조정하고 싶다면 offset 값을 조정하세요.
                offset: const Offset(0.0, 40.0),
              )
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Image.network(
                    this.profileImage, //이미지 바꿀 때 network인지 asset인지 구분 잘할 것
                    width: 60,
                    height: 60,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text('${widget.nickName}', //닉네임 바꾸는 곳
                      style: bold18.copyWith(color: AppColor.sub1)),
                  const Spacer(),
                  SizedBox(
                    height: 28,
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          mateRequested = !mateRequested;
                        });

                        if (mateRequested) {
                          try {
                            // FirebaseFirestore 인스턴스를 가져옵니다.
                            FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

                            // 현재 사용자의 UID
                            String myUid =
                                FirebaseAuth.instance.currentUser!.uid;

                            // 메이트의 정보를 조회합니다.
                            QuerySnapshot mateQuery = await firestore
                                .collection('user')
                                .where('nickName', isEqualTo: widget.nickName)
                                .get();

                            // 메이트의 정보가 없거나, 둘 이상이면 예외를 발생시킵니다.
                            if (mateQuery.docs.length != 1) {
                              throw Exception('메이트의 정보를 찾을 수 없거나, 닉네임이 중복됩니다.');
                            }

                            // 메이트의 정보를 가져옵니다.
                            UsersInfo mateInfo = UsersInfo.fromFirebase(
                                mateQuery.docs.first
                                    as DocumentSnapshot<Map<String, dynamic>>);

                            // 현재 사용자의 mate_friend 필드에 메이트의 UID를 추가합니다.
                            firestore.collection('user').doc(myUid).set({
                              'mate_ing':
                                  FieldValue.arrayUnion([mateInfo.uid ?? ""])
                            }, SetOptions(merge: true));

                            // 메이트의 mate_friend 필드에 현재 사용자의 UID를 추가합니다.
                            firestore.collection('user').doc(mateInfo.uid).set({
                              'mate_ing': FieldValue.arrayUnion([myUid])
                            }, SetOptions(merge: true));
                          } catch (e) {
                            print(e);
                            // 여기서 필요한 경우 사용자에게 오류 메시지를 표시할 수 있습니다.
                          }
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: mateRequested
                            ? const Color.fromRGBO(19, 228, 206, 1)
                            : Colors.black,
                        backgroundColor: mateRequested
                            ? const Color.fromRGBO(19, 228, 206, 0.5)
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
                        mateRequested ? "메이트 신청 중" : "메이트 신청",
                        style: const TextStyle(fontSize: 10.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Text('4 스타 메이트',
                      style: medium13.copyWith(color: AppColor.text)),
                ],
              ),
              const SizedBox(height: 20),
              const TabBar(
                labelColor: AppColor.text,
                indicatorColor: AppColor.text, //tabbar 아랫 부분에 흰색 줄 (움직이는거)
                tabs: [
                  Tab(text: "내 플리"),
                  Tab(text: "저장한 플리"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MySongList(
                      nickName: owner,
                    ),
                    SaveSongList(
                      nickName: owner,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 28,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> fetchUIDFromNickname(String nickname) async {
  QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
      .collection('user')
      .where('nickName', isEqualTo: nickname)
      .get();

  if (!query.docs.isEmpty) {
    return query
        .docs.first.id; // Return the uid of the user with the given nickname
  } else {
    throw Exception('User not found');
  }
}

Future<UsersInfo> fetchUserInfo(String uid) async {
  var docref = FirebaseFirestore.instance.collection('user').doc(uid);

  DocumentSnapshot<Map<String, dynamic>> doc = await docref.get();

  return UsersInfo.fromFirebase(doc);
}

class MySongList extends StatelessWidget {
  final String nickName;

  const MySongList({Key? key, required this.nickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUIDFromNickname(nickName),
      builder: (BuildContext context, AsyncSnapshot<String> uidSnapshot) {
        if (uidSnapshot.hasData) {
          return FutureBuilder<UsersInfo>(
            future: fetchUserInfo(uidSnapshot.data!),
            builder: (BuildContext context, AsyncSnapshot<UsersInfo> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.5,
                  ),
                  itemCount: snapshot.data!.playlist_my!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MySong(imageUrl: snapshot.data!.playlist_my![index]);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else if (uidSnapshot.hasError) {
          return Text('Error: ${uidSnapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class MySong extends StatelessWidget {
  final String imageUrl;

  const MySong({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.3),
          image: DecorationImage(
            image: NetworkImage(imageUrl), // 수정된 부분
            fit: BoxFit.fill,
          )),
    );
  }
}

class SaveSongList extends StatelessWidget {
  final String nickName;

  const SaveSongList({Key? key, required this.nickName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchUIDFromNickname(nickName),
      builder: (BuildContext context, AsyncSnapshot<String> uidSnapshot) {
        if (uidSnapshot.hasData) {
          return FutureBuilder<UsersInfo>(
            future: fetchUserInfo(uidSnapshot.data!),
            builder: (BuildContext context, AsyncSnapshot<UsersInfo> snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 1.5,
                  ),
                  itemCount: snapshot.data!.playlist_others!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SaveSong(
                        imageUrl: snapshot.data!.playlist_others![index]);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else if (uidSnapshot.hasError) {
          return Text('Error: ${uidSnapshot.error}');
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class SaveSong extends StatelessWidget {
  final String imageUrl;

  const SaveSong({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0.3),
          image: DecorationImage(
            image: NetworkImage(imageUrl), // 수정된 부분
            fit: BoxFit.fill,
          )),
    );
  }
}
