import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:provider/provider.dart';

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

  // 마커 그리기 함수
  void drawMarker(BuildContext context, NLatLng latLng) async {
    // 마커 생성
    final marker = NMarker( 
      id: '${_markers.length}',
      position: NLatLng(latLng.latitude, latLng.longitude),
      icon: const NOverlayImage.fromAssetImage('assets/images/my_marker.png'),
      size: const Size(35, 35),
      anchor: const NPoint(0.5, 0.5),
    );
    // 마커 클릭 시 이벤트 설정
    marker.setOnTapListener((overlay) {
      debugPrint('In drawMarker, switchMode is: ${context.read<SwitchProvider>().switchMode}');
      if (context.read<SwitchProvider>().switchMode) {
        _selectedMarkerCoords.add(marker.position);
        debugPrint("$_selectedMarkerCoords");
        if (_selectedMarkerCoords.length == 2) {
          debugPrint("선 두개!! $_selectedMarkerCoords");
          drawPolyline(context);
        }
      }
    });
    marker.setGlobalZIndex(200000);
    _mapController.addOverlay(marker);
    _markers.add(marker);
    debugPrint("${marker.info}");
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
}
