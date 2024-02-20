import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersInfo {
  final String? uid;
  final String? nickName;
  final String? userEmail;
  final String? userPassword;
  final String? profileImage;
  final List<Map<String, dynamic>>? mate;
  final List<String>? playlist_my;
  final List<String>? playlist_others;

  UsersInfo({
    required this.uid,
    required this.nickName,
    required this.userEmail,
    required this.userPassword,
    required this.profileImage,
    required this.mate,
    required this.playlist_my,
    required this.playlist_others,
  });

  factory UsersInfo.fromFirebase(
      DocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data() ?? {};
    return UsersInfo(
        uid: snapshotData['uid'],
        nickName: snapshotData[userNameFieldName],
        userEmail: snapshotData[userEmailFieldName],
        userPassword: snapshotData[userPasswordFieldName],
        profileImage: snapshotData[profileImageURLFieldName],
        mate: snapshotData[mateFieldName],
        playlist_my:
            List<String>.from(snapshotData[playlist_myFieldName] ?? []),
        playlist_others:
            List<String>.from(snapshotData[playlist_othersFieldName] ?? []));
  }
}

const String userNameFieldName = "nickName";
const String userEmailFieldName = "userEmail";
const String userPasswordFieldName = "userPassword";
const String profileImageURLFieldName = "profileImage";
const String mateFieldName = 'mate';
const String playlist_myFieldName = 'playlist_my';
const String playlist_othersFieldName = 'playlist_others';

Future<void> fetchAuthInfo() async {
  Map data = {};

  var docref = FirebaseFirestore.instance
      .collection('user')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  docref.get().then((doc) => {
        (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>;
          print(data);
        },
      });
}

class StarInfo {
  final String? uid;
  final List<double>? location;
  final String? title;
  final String? singer;
  final String? videoId;
  final String? comment;
  final String? owner;
  final Timestamp? registerTime;
  final String? address;
  final List<String>? like;

  StarInfo(
      {required this.uid,
      required this.location,
      required this.title,
      required this.singer,
      required this.videoId,
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
      title: snapshotData[musciTitleFieldName],
      singer: snapshotData[singerFieldName],
      videoId: snapshotData[videoIdFieldName],
      comment: snapshotData[commentFieldName],
      owner: snapshotData[ownerFieldName],
      address: snapshotData[addressFieldName],
      like: snapshotData[likeFieldName],
    );
  }

  static StarInfo fromMap(Map<String, dynamic> map) {
    return StarInfo(
        uid: map['uid'],
        location: List<double>.from(map['location'].map((e) => (e as num)
            .toDouble())), // Firestore에서는 모든 숫자를 double로 처리하지 않으므로, 명시적으로 변환해야 합니다.
        title: map['title'],
        singer: map['singer'],
        videoId: map['videoId'],
        comment: map['comment'],
        owner: map['owner'],
        registerTime: map['registerTime'],
        address: map['address'],
        like: List<String>.from(map['like']));
  }

  Map<String, dynamic> toMap() {
    return {
      uidFieldName: uid,
      registerTimeFieldName: registerTime,
      locationFieldName: location,
      musciTitleFieldName: title,
      singerFieldName: singer,
      videoIdFieldName: videoId,
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
const String musciTitleFieldName = "title";
const String singerFieldName = "singer";
const String videoIdFieldName = "videoId";
const String commentFieldName = "comment";
const String ownerFieldName = "owner";
const String addressFieldName = "address";
const String likeFieldName = "like";

class PlaylistInfo {
  final String? uid;
  final Timestamp? registerTime;
  final String? image_url;
  final String? owner;
  final String? title;
  final List? stars_id;
  final List? subscribe;

  PlaylistInfo(
      {required this.uid,
      required this.registerTime,
      required this.image_url,
      required this.owner,
      required this.title,
      required this.stars_id,
      required this.subscribe});

  factory PlaylistInfo.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return PlaylistInfo(
      uid: snapshotData[uidFieldName],
      registerTime: snapshotData[registerTimeFieldName],
      image_url: snapshotData[image_URLFieldName],
      owner: snapshotData[ownerFieldName],
      title: snapshotData[titleFieldName],
      subscribe: snapshotData[subscribeFieldName],
      stars_id: snapshotData[stars_idFieldName],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      uidFieldName: uid,
      registerTimeFieldName: registerTime,
      image_URLFieldName: image_url,
      ownerFieldName: owner,
      titleFieldName: title,
      subscribeFieldName: subscribe,
      stars_idFieldName: stars_id,
    };
  }
}

const image_URLFieldName = 'image_url';
const titleFieldName = 'title';
const subscribeFieldName = 'subscribe';
const stars_idFieldName = 'stars_id';
