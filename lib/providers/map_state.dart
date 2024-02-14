import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:music_api/components/home_bottomsheet.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../utilities/info.dart';
import 'switch_state.dart';

class MapProvider extends ChangeNotifier {
  // 선 그리기 전 선택되는 마커
  final List<NLatLng> _selectedMarkerCoords = [];
  final Set<NMarker> _markers = {};
  final Set<NPolylineOverlay> _lineOverlays = {};
  late NaverMapController _mapController;

  List<NLatLng> get selectedMarkerCoords => _selectedMarkerCoords;
  Set<NMarker> get markers => _markers;
  Set<NPolylineOverlay> get lineOverlays => _lineOverlays;
  NaverMapController get mapController => _mapController;

  void setController(NaverMapController controller) {
    _mapController = controller;
    notifyListeners();
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

  Future<Position> getPosition() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void drawMarker(BuildContext context, String id, Position location) {
// 마커 생성
    final marker = NMarker(
      id: id,
      position: NLatLng(location.latitude, location.longitude),
      icon: const NOverlayImage.fromAssetImage('assets/images/my_marker.png'),
      size: const Size(35, 35),
      anchor: const NPoint(0.5, 0.5),
    );
    // 마커 클릭 시 이벤트 설정
    marker.setOnTapListener((overlay) {
      if (context.read<SwitchProvider>().switchMode) {
        _selectedMarkerCoords.add(marker.position);
        if (_selectedMarkerCoords.length == 2) {
          drawPolyline(context);
        }
      }
      if (!context.read<SwitchProvider>().switchMode) {
        // 기본 홈 화면일 때
        debugPrint('hello~');
        _showBottomSheet(context);
      }
    });
    marker.setGlobalZIndex(200000);
    _mapController.addOverlay(marker);
    _markers.add(marker);
    notifyListeners();
  }

  // 마커 그리기 함수
  void addMarker(BuildContext context, String videoTitle, String videoSinger,
      String videoId, String comment) async {
    final Position location = await getPosition();

    final String currentAddress =
        await _getAddress(location.latitude, location.longitude);

    final docRef = FirebaseFirestore.instance.collection("Star").doc();

    // 마커 그리기
    drawMarker(context, docRef.id, location);

    final starInfo = StarInfo(
      uid: docRef.id,
      location: [location.latitude, location.longitude],
      title: videoTitle,
      singer: videoSinger,
      videoId: videoId,
      comment: comment,
      owner: FirebaseAuth.instance.currentUser?.uid,
      registerTime: Timestamp.now(),
      address: currentAddress,
      like: [],
    );
    await docRef.set(starInfo.toMap());
    notifyListeners();
  }

  // 선 그리기 함수
  void drawPolyline(BuildContext context) {
    // 선 생성
    final polylineOverlay = NPolylineOverlay(
        id: '${_lineOverlays.length}',
        coords: List.from(_selectedMarkerCoords),
        color: Colors.white,
        width: 3);

    // 선 클릭 시 이벤트 설정
    polylineOverlay.setOnTapListener((overlay) {
      if (context.read<SwitchProvider>().switchMode) {
        removeLine(overlay);
        notifyListeners();
      }
    });
    polylineOverlay.setGlobalZIndex(190000);
    addLine(polylineOverlay);
    // 선 그린 후 선택된 마커들 삭제
    _selectedMarkerCoords.clear();
    notifyListeners();
  }

  void addLine(NPolylineOverlay overlay) {
    _lineOverlays.add(overlay);
    _mapController.addOverlay(overlay);
    notifyListeners();
  }

  void removeLine(NPolylineOverlay overlay) {
    _lineOverlays.remove(overlay);
    _mapController.deleteOverlay(overlay.info);
    notifyListeners();
  }

  void clearLines() {
    _selectedMarkerCoords.clear();
    _lineOverlays.clear();
    _mapController.clearOverlays(type: NOverlayType.polylineOverlay);
    notifyListeners();
  }

  void redrawLines() {
    _mapController.addOverlayAll(_lineOverlays);
    notifyListeners();
  }

  void addToFirebase() {}

  void _showBottomSheet(BuildContext context) {
    if (context.mounted) {
      showModalBottomSheet(
        backgroundColor: const Color.fromRGBO(45, 45, 45, 1),
        context: context,
        builder: (BuildContext context) {
          return const HomeBottomsheet();
        },
      );
    } else {
      debugPrint("this widget doesn't mounted!!!");
    }
  }
}
