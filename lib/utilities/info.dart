import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfo {
  final String? uid;
  final String? nickName;
  final String? userEmail;

  // final String? userPassword;
  final String? profileImageURL;
  // final List<Map<String, dynamic>>? mate;
  // final List<String>? playlist_my;
  // final List<String>? playlist_others;

  UserInfo({
    required this.uid,
    required this.nickName,
    required this.userEmail,

    // required this.userPassword,
    required this.profileImageURL,
    // required this.mate,
    // required this.playlist_my,
    // required this.playlist_others,
  });

  String? get userNickName => nickName;

  // userEmail에 대한 getter를 추가
  String? get userEmail1 => userEmail;

  factory UserInfo.fromFirebase(
      DocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return UserInfo(
      uid: snapshotData?['uid'],
      nickName: snapshotData?[userNameFieldName],
      userEmail: snapshotData?[userEmailFieldName],
      // userPassword: snapshotData?[userPasswordFieldName],
      profileImageURL: snapshotData?[profileImageURLFieldName],
      // mate: snapshotData?[mateFieldName],
      // playlist_my: snapshotData?[playlistMyFieldName],
      // playlist_others: snapshotData?[playlistOthersFieldName],
    );
  }
}

const String userNameFieldName = "userName";
const String userEmailFieldName = "userEmail"; // <-- 수정된 부분
const String userPasswordFieldName = "userPassword";
const String profileImageURLFieldName = "profileImageURL";
const String mateFieldName = 'mate';
const String playlistMyFieldName = 'playlist_my';
const String playlistOthersFieldName = 'playlist_others';

Future<void> fetchAuthInfo() async {
  Map data = {};

  var docref = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  await docref.get().then((doc) => {
        (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>;
          debugPrint(data as String?);
        },
      });
}

class StarInfo {
  final String? uid;
  final List<double>? location;
  final String? song;
  final String? comment;
  final String? owner;
  final Timestamp? registerTime;
  final String? address;
  final List? like;

  StarInfo(
      {required this.uid,
      required this.location,
      required this.song,
      required this.comment,
      required this.owner,
      required this.registerTime,
      required this.address,
      required this.like});

  factory StarInfo.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return StarInfo(
      uid: snapshotData[uidFieldName],
      registerTime: snapshotData[registerTimeFieldName],
      location: snapshotData[locationFieldName],
      song: snapshotData[songFieldName],
      comment: snapshotData[commentFieldName],
      owner: snapshotData[ownerFieldName],
      address: snapshotData[addressFieldName],
      like: snapshotData[likeFieldName],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      uidFieldName: uid,
      registerTimeFieldName: registerTime,
      locationFieldName: location,
      songFieldName: song,
      commentFieldName: comment,
      ownerFieldName: owner,
      addressFieldName: address,
      likeFieldName: like,
    };
  }
}

const String uidFieldName = "uid";
const String registerTimeFieldName = "registerTime";
const String locationFieldName = "location";
const String songFieldName = "song";
const String commentFieldName = "comment";
const String ownerFieldName = "owner";
const String addressFieldName = "address";
const String likeFieldName = "like";

class PlaylistInfo {
  final String? uid;
  final Timestamp? registerTime;
  final String? imageUrl;
  final String? owner;
  final String? title;
  final List? starsId;
  final List? subscribe;

  PlaylistInfo(
      {required this.uid,
      required this.registerTime,
      required this.imageUrl,
      required this.owner,
      required this.title,
      required this.starsId,
      required this.subscribe});

  factory PlaylistInfo.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return PlaylistInfo(
      uid: snapshotData[uidFieldName],
      registerTime: snapshotData[registerTimeFieldName],
      imageUrl: snapshotData[imageUrlFieldName],
      owner: snapshotData[ownerFieldName],
      title: snapshotData[titleFieldName],
      subscribe: snapshotData[subscribeFieldName],
      starsId: snapshotData[starsIdFieldName],
    );
  }
}

const imageUrlFieldName = 'imageUrl';
const titleFieldName = 'title';
const subscribeFieldName = 'subscribe';
const starsIdFieldName = 'starsId';
