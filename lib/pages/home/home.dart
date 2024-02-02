import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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
import '../../utilities/text_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<NaverMapController> _controller = Completer();
  final ScrollController _scrollController = ScrollController();
  final _tooltipController = SuperTooltipController();
  final _textController = TextEditingController();
  NMarker? _userLocationMarker;
  // late NaverMapController mapController;
  int markerCount = 0;
  // int lineCount = 0;
  bool editMode = false;
  late NCameraPosition camera;
  int selectedIndex = 0;

  NCameraPosition initPosition = const NCameraPosition(
      target: NLatLng(36.10174928712425, 129.39070716683418), zoom: 15);

  late Position position;

  // Set<NMarker> markers = {};
  // Set<NPolylineOverlay> lineOverlays = {};

  // 선 그리기 전 선택되는 마커
  // List<NLatLng> selectedMarkerCoords = [];

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

  // GPS 정보 얻기
  Future<Position> _getPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  // GPS 정보 도로명 주소로 변환
  Future<String> _getAddress(double lat, double lon) async {
    // 네이버 API 키
    String clientId = 'oic87mpcyw';
    String clientSecret = 'ftEbewAoHtXhrpokEHAk7TUPAZzR1r4woeMja3hE';

    // 요청 URL 만들기
    String url =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=$lon,$lat&sourcecrs=epsg:4326&output=json&orders=addr,admcode,roadaddr';

    // HTTP GET 요청 보내기
    var response = await http.get(Uri.parse(url), headers: {
      'X-NCP-APIGW-API-KEY-ID': clientId,
      'X-NCP-APIGW-API-KEY': clientSecret
    });

    // 응답 처리
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var address = jsonResponse['results'][0]['region']['area2']['name'] +
          ' ' +
          jsonResponse['results'][0]['region']['area3']['name'];
      return address;
    } else {
      return '주소 정보를 가져오는데 실패했습니다.';
    }
  }

  // 현재 위치로 이동
  void _updatePosition() async {
    final mapController =
        Provider.of<MapProvider>(context, listen: false).mapController;
    camera = await mapController.getCameraPosition();
    position = await _getPosition();
    mapController.updateCamera(NCameraUpdate.withParams(
        target: NLatLng(position.latitude, position.longitude),
        zoom: camera.zoom));
    // _drawCircle(position);
  }

  // 현재 위치에 마커 찍기
  void _userLocation() {
    final mapController =
        Provider.of<MapProvider>(context, listen: false).mapController;
    Geolocator.getPositionStream().listen((Position position) {
      if (_userLocationMarker == null) {
        // 초기 사용자 위치 마커를 생성합니다.
        _userLocationMarker = NMarker(
            id: 'user_location',
            position: NLatLng(position.latitude, position.longitude),
            icon: const NOverlayImage.fromAssetImage(
                'assets/images/my_location.png'), // 동그라미 이미지
            size: const Size(32, 32));
        setState(() {
          // 마커를 지도에 추가합니다.
          mapController.addOverlay(_userLocationMarker!);
        });
      } else {
        // 사용자 위치가 변경될 때마다 마커 위치를 업데이트합니다.
        setState(() {
          _userLocationMarker = NMarker(
            id: 'user_location',
            position: NLatLng(position.latitude, position.longitude),
            icon: const NOverlayImage.fromAssetImage(
                'assets/images/my_location.png'),
            size: const Size(32, 32), // 동그라미 이미지
          );
        });
      }
    });
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
      debugPrint("parent: ${await mapController.getContentBounds()}");
      String name = _textController.text;
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewPage(
                    position: camera,
                    name: name,
                  )));
    } catch (e) {
      debugPrint('이미지 저장 중 오류 발생: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePermission();
  }

  @override
  void dispose() {
    Geolocator.getPositionStream().listen((_) {}).cancel();
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
                pickTolerance: 10),
            // 지도 실행 시 이벤트
            onMapReady: (controller) async {
              context.read<MapProvider>().setController(controller);
              _controller.complete(controller);
              _userLocation();
            },
            // 지도 탭 이벤트
            onMapTapped: (point, latLng) async {
              context.read<MapProvider>().drawMarker(latLng);
              debugPrint(await _getAddress(latLng.latitude, latLng.longitude));
            },
          ),
        ),

        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
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
                          InkWell(
                            onTap: () {
                              _showBottomSheet(context);
                            },
                            child: Image.asset("assets/images/logo.png",
                                width: 85, height: 35),
                          ),
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
                ? (mapProvider.lineOverlays.isNotEmpty
                    ? const CompleteButtonDisable()
                    : CompleteButtonEnable(complete: saveMapImage))
                : PutStar(putMarker: (){Navigator.pushNamed(context, "/search");}),
          ),
        ),
      ]),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Color.fromRGBO(45, 45, 45, 1),
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          child: Container(
            height: 289,
            margin: const EdgeInsets.only(left: 25, right: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Color.fromRGBO(45, 45, 45, 0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    width: 124,
                    height: 6,
                    decoration: BoxDecoration(
                        color: AppColor.text,
                        borderRadius: BorderRadius.circular(24)),
                  ),
                ),
                const SizedBox(height: 34),
                Column(
                  children: [
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                      text: '나는 쿼카입니다님', style: semibold17),
                                  TextSpan(text: '이 추천하는', style: regular16),
                                ],
                              ),
                            ),
                            Text(
                              '이곳에 어울리는 음악',
                              style: semibold17,
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Icon(Icons.favorite, color: AppColor.error),
                            Text('25',
                                textAlign: TextAlign.left,
                                style:
                                    regular13.copyWith(color: AppColor.sub1)),
                          ],
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                    const SizedBox(height: 19),
                    Row(
                      children: <Widget>[
                        Stack(
                          children: [
                            SizedBox(
                              height: 70,
                              width: 70,
                              child: Image.network(
                                'https://i1.ytimg.com/vi/_fd_hwSm9zI/maxresdefault.jpg',
                                fit: BoxFit.fitHeight,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.network(
                                    'https://i1.ytimg.com/vi/_fd_hwSm9zI/sddefault.jpg',
                                    fit: BoxFit.fitHeight,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Container(
                                        color: Colors.yellow,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20, left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '잘지내자 우리',
                                  textAlign: TextAlign.left,
                                  style: bold17,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('최유리',
                                    textAlign: TextAlign.left,
                                    style: regular13.copyWith(
                                        color: AppColor.sub1)),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 19),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => VideoSearchPage(
                    //               video: '_fd_hwSm9zI',
                    //             )));
                  },
                  child: Container(
                    width: 340,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12), // 테두리 반경 값을 12로 설정
                      border:
                          Border.all(color: Colors.white), // 테두리 색상을 흰색으로 설정
                      color: Colors.transparent, // 배경색을 투명하게 설정
                    ),
                    child: Center(
                      child: Text(
                        '우끼끼,,,여기는 이 음악을 올린 사람이 쓴 코멘트가... 있을까말...',
                        style: semibold12.copyWith(color: AppColor.sub1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
