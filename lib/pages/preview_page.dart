import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';

import '../components/card_frame.dart';
import '../components/custom_snackbar.dart';
import '../providers/map_state.dart';
import '../providers/switch_state.dart';
import '../utilities/color_scheme.dart';
import '../utilities/text_theme.dart';


class PreviewPage extends StatefulWidget {
  const PreviewPage(
      {super.key,
      required this.position});
  final NCameraPosition position;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late NaverMapController newController;
  TextEditingController textController = TextEditingController();
  Uint8List? capturedImage;

  // 이미지 캡처
  Future<Uint8List?> captureMap() async {
    final Uint8List mapImage =
        await (await newController.takeSnapshot(showControls: false))
            .readAsBytes();
    return mapImage;
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
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
                              contentPadding: const EdgeInsets.symmetric(vertical: 2),
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
                    const Text("자리",
                        style: bold20)
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset("assets/images/profile.png")),
                    ),
                    const SizedBox(width: 8),
                    const Text("태정태세비욘세",
                        style: medium16)
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
                    newController.addOverlayAll(mapProvider.markers);
                    newController.addOverlayAll(mapProvider.lineOverlays);
                    debugPrint(
                        "child: ${await newController.getContentBounds()}");
                    // 배경 이미지
                    final imageOverlay = NGroundOverlay(
                        id: "background",
                        image: const NOverlayImage.fromAssetImage(
                            "assets/images/card.png"),
                        bounds: await newController.getContentBounds());
                    imageOverlay.setGlobalZIndex(180000);
                    newController.addOverlay(imageOverlay);
                    setState(() {});
                  },
                )),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return const MusicBar();
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
  const MusicBar({super.key});

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
            Text('포항시 북구 흥해읍 한동로 558',
                style: regular13.copyWith(color: AppColor.sub1.withOpacity(0.8))),
          ],
        ),
        const SizedBox(height: 5),
        ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset('assets/images/album.png'))),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("잘 지내자, 우리",
                  style: bold16.copyWith(color: AppColor.sub1)),
              Text('최유리', style: regular12.copyWith(color: AppColor.sub2))
            ],
          ),
          trailing: Text('3:54',
              style: regular13.copyWith(color: AppColor.sub2)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
