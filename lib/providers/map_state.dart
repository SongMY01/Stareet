import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class MapProvider extends ChangeNotifier {
  final Set<NPolylineOverlay> _lineOverlays = {};
  late NaverMapController _mapController;

  Set<NPolylineOverlay> get lineOverlays => _lineOverlays;
  NaverMapController get mapController => _mapController;

  void setController(NaverMapController controller) {
    _mapController = controller;
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
    _lineOverlays.clear();
    _mapController.clearOverlays(type: NOverlayType.polylineOverlay);
    notifyListeners();
  }

  void redrawLines() {
    _mapController.addOverlayAll(_lineOverlays);
    notifyListeners();
  }
}