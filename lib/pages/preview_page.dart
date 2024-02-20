import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';

import '../components/card_frame.dart';
import '../components/custom_snackbar.dart';
import '../providers/map_state.dart';
import '../providers/switch_state.dart';
import '../providers/user_state.dart';
import '../utilities/color_scheme.dart';
import '../utilities/info.dart';
import '../utilities/text_theme.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PreviewPage extends StatefulWidget {
  const PreviewPage({super.key, required this.position});
  final NCameraPosition position;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late NaverMapController newController;
  TextEditingController textController = TextEditingController();
  Uint8List? capturedImage;
  String loggedInUid = FirebaseAuth.instance.currentUser!.uid;
  String nickName = '';
  String profileLink = '';
  List<NMarker> markerList = [];
// Uint8List를 File로 변환하는 함수
  Future<File> convertUint8ListToFile(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/temp.jpg').create();
    await file.writeAsBytes(data);
    return file;
  }

  Future<void> uploadImageToFirebaseStorage(
      File imageFile, List<NMarker> markers) async {
    //파베 구조 만들기
    final docRef = FirebaseFirestore.instance.collection("playlist").doc();

    final List<String> stars = [];
    for (final marker in markers) {
      stars.add(marker.info.id);
    }

    final playlistInfo = PlaylistInfo(
      uid: docRef.id,
      registerTime: Timestamp.now(),
      image_url: '',
      owner: FirebaseAuth.instance.currentUser?.uid,
      title: textController.text,
      stars_id: stars,
      subscribe: [],
    );
    await docRef.set(playlistInfo.toMap());

    // Storage에 playlist id로 올리기.
    final storage = firebase_storage.FirebaseStorage.instance;
    final storageRef =
        storage.ref().child('playlist_images').child('$docRef.id.jpg');

    await storageRef.putFile(imageFile);

    final imageUrl = await storageRef.getDownloadURL();
    await saveImageToFirebase(docRef.id, imageUrl);
  }

  Future<void> saveImageToFirebase(String docId, String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('playlist').doc(docId).set(
          {
            'image_url': imageUrl,
          },
          SetOptions(
              merge: true)); // merge: true 옵션으로 기존 데이터를 보존하면서 새로운 필드를 추가합니다.
      debugPrint("파베 저장 완료~");
    } catch (e) {
      debugPrint(e as String?);
    }
  }

  // 이미지 캡처
  Future<Uint8List?> captureMap() async {
    final Uint8List mapImage =
        await (await newController.takeSnapshot(showControls: false))
            .readAsBytes();
    return mapImage;
  }

  Future<StarInfo> getMarkerData(String markerId) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(loggedInUid)
        .collection("Star")
        .doc(markerId)
        .get();
    return StarInfo.fromMap(doc.data()!);
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    markerList = mapProvider.selectedList.toSet().toList();
    // 배경 그라데이션
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColor.text,
          elevation: 0,
          title: const Text("별플리 미리보기", style: bold16),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () async {
                  capturedImage = await captureMap();
                  if (capturedImage != null) {
                    newController.clearOverlays();
                    final result =
                        await ImageGallerySaver.saveImage(capturedImage!);
                    if (!mounted) return;
                    if (result != null && result['isSuccess'] == true) {
                      showCustomSnackbar(context, '별플리가 저장되었습니다.');
                    } else {
                      showCustomSnackbar(context, '별플리 저장에 실패하였습니다.');
                    }
                    context.read<MapProvider>().clearLines();
                    Navigator.pop(context);
                    context.read<SwitchProvider>().setMode(false);
                    final imageFile =
                        await convertUint8ListToFile(capturedImage!);
                    await uploadImageToFirebaseStorage(imageFile, markerList);
                  } else {
                    debugPrint("이미지 저장 실패");
                  }
                },
                child: const Text("저장", style: bold16))
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit, color: AppColor.sub2),
                    SizedBox(
                        width: 90,
                        height: 40,
                        child: TextField(
                            controller: textController,
                            maxLength: 5,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              counterText: "",
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 2),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: textController.text.isEmpty
                                        ? Colors.white
                                        : Colors.transparent),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            style: bold20.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: AppColor.text))),
                    const Text("자리", style: bold20)
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.network(
                              userProvider.userData['profileLink'])),
                    ),
                    const SizedBox(width: 8),
                    Text(userProvider.getNickName(), style: medium16)
                  ],
                ),
                const SizedBox(height: 13),
                StarCard(
                  child: NaverMap(
                    options: NaverMapViewOptions(
                        initialCameraPosition: widget.position,
                        mapType: NMapType.navi,
                        nightModeEnable: true,
                        indoorEnable: true,
                        logoClickEnable: false,
                        scaleBarEnable: false,
                        stopGesturesEnable: false,
                        tiltGesturesEnable: false,
                        zoomGesturesEnable: false,
                        scrollGesturesEnable: false,
                        rotationGesturesEnable: false,
                        consumeSymbolTapEvents: false,
                        lightness: -1,
                        pickTolerance: 10),
                    // 지도 실행 시 이벤트
                    onMapReady: (controller) async {
                      newController = controller;
                      newController.addOverlayAll(markerList.toSet());
                      newController.addOverlayAll(mapProvider.lineOverlays);
                      // debugPrint(
                      //     "child: ${await newController.getContentBounds()}");
                      // 배경 이미지
                      final imageOverlay = NGroundOverlay(
                          id: "background",
                          image: const NOverlayImage.fromAssetImage(
                              "assets/images/card.png"),
                          bounds: await newController.getContentBounds());
                      imageOverlay.setGlobalZIndex(180000);
                      newController.addOverlay(imageOverlay);
                      setState(() {});
                      debugPrint("${mapProvider.selectedList}");
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: markerList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return FutureBuilder(
                          future: getMarkerData(markerList[index].info.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            } else {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final starInfo = snapshot.data!;
                                return MusicBar(
                                  starInfo: starInfo,
                                );
                              }
                            }
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 음악 플레이리스트
class MusicBar extends StatelessWidget {
  final StarInfo starInfo;
  const MusicBar({super.key, required this.starInfo});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.location_on, color: AppColor.primary),
            Text(starInfo.address!,
                style:
                    regular13.copyWith(color: AppColor.sub1.withOpacity(0.8))),
          ],
        ),
        const SizedBox(height: 5),
        ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                width: 60,
                height: 60,
                child: Image.network(
                    'https://i1.ytimg.com/vi/${starInfo.videoId}/maxresdefault.jpg',
                    fit: BoxFit.fitHeight),
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(starInfo.title!,
                  style: bold16.copyWith(color: AppColor.sub1)),
              Text(starInfo.singer!,
                  style: regular12.copyWith(color: AppColor.sub2))
            ],
          ),
          trailing:
              Text('3:24', style: regular13.copyWith(color: AppColor.sub2)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
