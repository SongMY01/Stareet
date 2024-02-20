import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  late String _userUid;
  DocumentSnapshot? _userData;

  UserProvider() {
    _user = _auth.currentUser;
    _loadUserData();
  }

  User get user => _user!;
  DocumentSnapshot get userData => _userData!;
  String get userUid => _userUid;
  
  Future<void> _loadUserData() async {
    if (_user != null) {
      _userUid = _user!.uid;
      _userData = await FirebaseFirestore.instance.collection('users').doc(_userUid).get();
    }
    notifyListeners();
  }

  String getNickName() {
    return _userData!['nickName'];
  }

  List<String> getMate() {
    return _userData!['mate_friend'];
  }
}