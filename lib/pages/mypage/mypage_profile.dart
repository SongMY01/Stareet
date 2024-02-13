import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../utilities/text_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

String uid = FirebaseAuth.instance.currentUser!.uid;
Future<Map<String, dynamic>> getUserInfo() async {
  var result =
      await FirebaseFirestore.instance.collection('user').doc(uid).get();
  return result.data() as Map<String, dynamic>;
}

class _ProfilePageState extends State<ProfilePage> {
  String nickname = '';
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nicknameFocus = FocusNode(); // Add this line
  File? _image;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImageToFirebaseStorage(
      File imageFile, String userId) async {
    final storage = firebase_storage.FirebaseStorage.instance;
    final storageRef =
        storage.ref().child('profile_images').child('$userId.jpg');

    await storageRef.putFile(imageFile);

    final imageUrl = await storageRef.getDownloadURL();
    return imageUrl;
  }

  Future<void> saveUserDataToFirestore(
      String userId, String nickname, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(userId).update({
        'nickName': nickname,
        'profileImage': imageUrl,
      });
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  bool? _isNicknameAvailable;

  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('user')
          .where('nickName', isEqualTo: nickname)
          .get();

      return result.docs.isEmpty;
    } catch (e) {
      debugPrint(e as String?);
      return false;
    }
  }

  Future<void> _tryValidation() async {
    _isNicknameAvailable = await isNicknameAvailable(nickname);
    debugPrint(_isNicknameAvailable as String?);

    final isValid = _formKey.currentState!.validate();
    debugPrint(isValid as String?);

    if (isValid) {
      _formKey.currentState!.save();

      try {
        final user = FirebaseAuth.instance.currentUser!;

        // 이미지 업로드
        final imageUrl = await uploadImageToFirebaseStorage(_image!, user.uid);
        debugPrint(nickname);

        // Firebase Firestore에 사용자 정보 저장
        await saveUserDataToFirestore(user.uid, nickname, imageUrl);
      } catch (e) {
        debugPrint(e as String?);
        // 에러 처리
      }
    }
    Navigator.pushNamed(context, '/mypage');
  }

  String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요.';
    } else if (value.length > 7) {
      return '닉네임은 7자 이하로 입력해주세요.';
    } else if (!RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(value)) {
      return '올바른 형식의 닉네임이 아닙니다.';
    } else if (_isNicknameAvailable == false) {
      //상태 변수 활용
      return '이미 사용 중인 닉네임입니다.';
    }
    return null;
  }

  final _authentication = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/fonts/images/background.gif"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              '프로필 편집',
              style: bold16,
            ),
          ),
          body: FutureBuilder<Map<String, dynamic>>(
              future: getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var userInfo = snapshot.data!;

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(25, 40, 25, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 62,
                                              backgroundImage: _image != null
                                                  ? FileImage(_image!)
                                                  : NetworkImage(userInfo[
                                                          'profileImage'])
                                                      as ImageProvider,
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          // InkWell 사진 업로드하기
                                          top: 80,
                                          left: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50) /
                                                  2 +
                                              20,
                                          child: GestureDetector(
                                            onTap: _pickImage,
                                            child: Image.asset(
                                              'assets/images/cameralogo.png',
                                              width: 38,
                                              height: 38,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 46,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '닉네임(2-7자리 한글 및 영문)',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ), //user title
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
                                            style: const TextStyle(
                                                color: Colors.white), //바꾸기
                                            focusNode: _nicknameFocus,
                                            onTap: () {
                                              _nicknameFocus.requestFocus();
                                            },
                                            key: const ValueKey(1),
                                            validator: validateNickname,
                                            onSaved: (value) {
                                              nickname = value!;
                                            },
                                            onChanged: (value) {
                                              nickname = value;
                                            },
                                            decoration: const InputDecoration(
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                              ),
                                              hintText: '닉네임 입력',
                                              hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff9E9EA4),
                                              ),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      20, 10, 10, 10),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 18,
                                        ),

                                        const Text(
                                          '* 별이닷은 익명으로 즐거운 소통을 지향해요.',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () async {
                            _tryValidation();
                          },
                          child: Container(
                              width: double.infinity,
                              height: 48,
                              margin: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF64FFEE),
                                    Color(0xFFF0F2BD)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: const Center(
                                  child: Text(
                                '다음',
                                style: TextStyle(fontSize: 17),
                              ))),
                        ),
                      ),
                    ],
                  );
                }
              })),
    );
  }
}
