import 'package:flutter/material.dart';

import '../utilities/text_theme.dart';

class CustomSnackbar extends StatefulWidget {
  final String message;
  const CustomSnackbar({super.key, required this.message});

  @override
  State<CustomSnackbar> createState() => _CustomSnackbarState();
}

class _CustomSnackbarState extends State<CustomSnackbar> {
  double opacityLevel = 1;

  void hideSnackbar() {
    setState(() {
      opacityLevel = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260, height: 45,
      child: Align(
        alignment: const Alignment(0, 0.55),
        child: AnimatedOpacity(
            opacity: opacityLevel,
            duration: const Duration(seconds: 1),
            child: Container(
                width: 256,
                height: 42,
                decoration: BoxDecoration(
                    color: const Color(0xffF4F4F4).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(32)),
                child: Center(
                  child: DefaultTextStyle(style: medium14.copyWith(color: Colors.black), child: Text(widget.message))
                ))),
      ),
    );
  }
}

void showCustomSnackbar(BuildContext context, String message) {
  GlobalKey<_CustomSnackbarState> snackbarKey =
      GlobalKey<_CustomSnackbarState>();

  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => CustomSnackbar(key: snackbarKey, message: message),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(const Duration(seconds: 1)).then((value) {
    snackbarKey.currentState?.hideSnackbar();
  });

  Future.delayed(const Duration(seconds: 2)).then((value) {
    overlayEntry.remove();
  });
}
