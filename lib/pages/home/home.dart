import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:music_api/pages/preview_page.dart';
import 'package:provider/provider.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../components/custom_drawer.dart';
import '../../components/custom_snackbar.dart';
import '../../components/custom_switch.dart';
import '../../components/home_components.dart';
import '../../providers/map_state.dart';
import '../../providers/switch_state.dart';
import '../../utilities/color_scheme.dart';
import '../../utilities/info.dart';
import '../../utilities/text_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get getGlobalKey => _scaffoldKey;
  StreamSubscription<Position>? _positionSubscription;
  final Completer<NaverMapController> _controller = Completer();
  final ScrollController _scrollController = ScrollController();
  final _tooltipController = SuperTooltipController();
  NMarker? _userLocationMarker;
  bool editMode = false;
  late NCameraPosition camera;
  int selectedIndex = 0;

  late NCameraPosition initPosition = const NCameraPosition(
      target: NLatLng(36.10174928712425, 129.39070716683418), zoom: 15);

  late Position position;

  // 권한 요청
  Future<bool> _determinePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value(false);
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.value(false);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.value(false);
    }
    return Future.value(true);
  }

  // firebase에서 Star 정보 가져오기
  Future<List<StarInfo>> fetchUserStars() async {
    final snapshot = await FirebaseFirestore.instance.collection('Star').get();

    return snapshot.docs.map((doc) => StarInfo.fromMap(doc.data())).toList();
  }

  // 지도에 Star 그리기
  void pickMarker(BuildContext context, List<StarInfo> stars) {
    for (StarInfo star in stars) {
      context.read<MapProvider>().drawMarker(
          context, star.uid!, NLatLng(star.location![0], star.location![1]));
    }
  }

  // GPS 정보 얻기
  Future<Position> _getPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  // 현재 위치로 이동
  void _updatePosition() async {
    final mapController =
        Provider.of<MapProvider>(context, listen: false).mapController;
    final results = await Future.wait([_getPosition()]);
    position = results[0];
    mapController.updateCamera(NCameraUpdate.withParams(
        target: NLatLng(position.latitude, position.longitude)));
    // _drawCircle(position);
  }

  // 이미지 저장
  void saveMapImage() async {
    final mapController =
        Provider.of<MapProvider>(context, listen: false).mapController;
    try {
      // 현재 카메라 위치 저장
      camera = await mapController.getCameraPosition();
      camera = NCameraPosition(
          target: camera.target,
          zoom: camera.zoom - 0.15,
          bearing: camera.bearing);
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    position: camera,
                  )));
    } catch (e) {
      debugPrint('이미지 저장 중 오류 발생: $e');
    }
  }

  void _updateUserMarker(Position position) {
    _userLocationMarker = NMarker(
        id: 'user_location',
        position: NLatLng(position.latitude, position.longitude),
        icon: const NOverlayImage.fromAssetImage(
            'assets/images/my_location.png'), // 동그라미 이미지
        size: const Size(30, 30));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _determinePermission();
    _positionSubscription = Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.best, distanceFilter: 10))
        .listen(_updateUserMarker);
  }

  @override
  void dispose() {
    Geolocator.getPositionStream().listen((_) {}).cancel();
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final switchProvider = Provider.of<SwitchProvider>(context);
    final mapProvider = Provider.of<MapProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const SizedBox(
        width: 240,
        child: CustomDrawer(),
      ),
      body: Stack(children: [
        Container(
          color: Colors.black,
          child: NaverMap(
            options: NaverMapViewOptions(
                initialCameraPosition: initPosition,
                mapType: NMapType.navi,
                nightModeEnable: true,
                indoorEnable: true,
                logoClickEnable: false,
                consumeSymbolTapEvents: false,
                // locationButtonEnable: true,
                pickTolerance: 10),
            // 지도 실행 시 이벤트
            onMapReady: (controller) async {
              context.read<MapProvider>().setController(controller);
              _controller.complete(controller);
              _updateUserMarker(await mapProvider.getPosition());
              mapProvider.mapController.addOverlay(_userLocationMarker!);
              List<StarInfo> stars = await fetchUserStars();
              pickMarker(context, stars);
            },

            // 지도 탭 이벤트
            onMapTapped: (point, latLng) async {},
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 95,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.black.withOpacity(0.2),
                          const Color(0xff191821).withOpacity(0)
                        ])),
                  ),
                ),
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 105,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                          Colors.black.withOpacity(0.2),
                          const Color(0xff191821).withOpacity(0)
                        ])),
                  ),
                ),
              ),
            ],
          ),
        ),

        // AppBar
        Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 160,
              color: Colors.transparent,
              padding: const EdgeInsets.only(top: 60),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 25),
                      GestureDetector(
                          onTap: () {
                            if (!switchProvider.switchMode) {
                              context.read<SwitchProvider>().toggleMode();
                              showCustomSnackbar(context, "별자리 공작소로 전환합니다.");
                            } else {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return Theme(
                                      data: ThemeData.dark(),
                                      child: CupertinoAlertDialog(
                                        title: const Text("별 잇기를 그만하시겠어요?",
                                            style: regular17),
                                        actions: [
                                          CupertinoDialogAction(
                                              child: Text("계속하기",
                                                  style: regular17.copyWith(
                                                      color: AppColor.sub2)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              }),
                                          CupertinoDialogAction(
                                              child: Text("나가기",
                                                  style: regular17.copyWith(
                                                      color: AppColor.error)),
                                              onPressed: () {
                                                mapProvider.mapController
                                                    .clearOverlays(
                                                        type: NOverlayType
                                                            .polylineOverlay);

                                                mapProvider.clearLines();
                                                Navigator.pop(context);
                                                switchProvider.toggleMode();
                                              })
                                        ],
                                      ),
                                    );
                                  });
                            }
                          },
                          child: const CustomSwitch()),
                      const SizedBox(width: 65),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/logo.png",
                              width: 85, height: 35),
                          const SizedBox(width: 8),
                          switchProvider.switchMode
                              ? CustomTooltip(controller: _tooltipController)
                              : const SizedBox(width: 22)
                        ],
                      ),
                      const SizedBox(width: 65),
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                        child: Image.asset("assets/images/menu.png",
                            width: 24, height: 18),
                      ),
                      const SizedBox(width: 25)
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Chip들
                  Visibility(
                    visible: !switchProvider.switchMode,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        // physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: List.generate(6, (int index) {
                          if (index != 5) {
                            return Row(children: [
                              CustomChip(
                                  name: [
                                    '전체',
                                    '나',
                                    '메이트 전체',
                                    '메이트 1',
                                    '메이트 2',
                                    '메이트 3'
                                  ][index],
                                  isSelected: index == selectedIndex,
                                  function: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  }),
                              const SizedBox(width: 7.2)
                            ]);
                          } else {
                            return CustomChip(
                                name: [
                                  '전체',
                                  '나',
                                  '메이트 전체',
                                  '메이트 1',
                                  '메이트 2',
                                  '메이트 3'
                                ][index],
                                isSelected: index == selectedIndex,
                                function: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                });
                          }
                        }).toList()),
                      ),
                    ),
                  ),
                ],
              ),
            )),

        // 현재 위치 버튼
        Visibility(
          visible: !switchProvider.switchMode,
          child: Positioned(
            bottom: 60,
            right: 40,
            child: LocationButton(goToLocation: _updatePosition),
          ),
        ),

        // FAB
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: switchProvider.switchMode
                ? (mapProvider.lineOverlays.isEmpty
                    ? const CompleteButtonDisable()
                    : CompleteButtonEnable(complete: saveMapImage))
                : const PutStar(),
          ),
        ),
      ]),
    );
  }
}
