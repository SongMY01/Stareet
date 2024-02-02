import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfo {
  final String? uid;
  final String? nickName;
  final String? userEmail;
  final String? userPassword;
  final String? profileImageURL;
  final List<Map<String, dynamic>>? mate;
  final List<String>? playlist_my;
  final List<String>? playlist_others;

  UserInfo({
    required this.uid,
    required this.nickName,
    required this.userEmail,
    required this.userPassword,
    required this.profileImageURL,
    required this.mate,
    required this.playlist_my,
    required this.playlist_others,
  });

  factory UserInfo.fromFirebase(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnap) {
    final snapshotData = docSnap.data();
    return UserInfo(
        uid: snapshotData['uid'],
        nickName: snapshotData[userNameFieldName],
        userEmail: snapshotData[userEmailFieldName],
        userPassword: snapshotData[userPasswordFieldName],
        profileImageURL: snapshotData[profileImageURLFieldName],
        mate: snapshotData[mateFieldName],
        playlist_my: snapshotData[playlist_myFieldName],
        playlist_others: snapshotData[playlist_othersFieldName]);
  }
}

const String userNameFieldName = "userName";
const String userEmailFieldName = "userEamil";
const String userPasswordFieldName = "userPassword";
const String profileImageURLFieldName = "profileImageURL";
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
  final String? song;
  final String? comment;
  final String? owner;
  final Timestamp? registerTime;
  final String? address;
  final List<int>? like;

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
  final String? image_URL;
  final String? owner;
  final String? title;
  final List? stars_id;
  final List? subscribe;

  PlaylistInfo(
      {required this.uid,
      required this.registerTime,
      required this.image_URL,
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
      image_URL: snapshotData[image_URLFieldName],
      owner: snapshotData[ownerFieldName],
      title: snapshotData[titleFieldName],
      subscribe: snapshotData[subscribeFieldName],
      stars_id: snapshotData[stars_idFieldName],
    );
  }
}

const image_URLFieldName = 'image_URL';
const titleFieldName = 'title';
const subscribeFieldName = 'subscribe';
const stars_idFieldName = 'stars_id';
