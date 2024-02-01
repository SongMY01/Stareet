import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/switch_state.dart';
import '../utilities/color_scheme.dart';


// 커스텀 스위치
class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    bool switchMode = Provider.of<SwitchProvider>(context).switchMode;
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        border: Border.all(
          width: 2,
          color: switchMode ? AppColor.text : AppColor.sub2,
        ),
      ),
      width: 64.0,
      height: 36.0,
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Positioned(
            left: switchMode ? 30.0 : 2.0, // toggle 값에 따라 left 값을 변경합니다.
            top: 2,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
                color: Colors.transparent,
              ),
              width: 25.0,
              height: 25.0, // 높이 추가
              child: Image.asset(switchMode
                  ? "assets/images/switch_true.png"
                  : "assets/images/switch_false.png"),
            ),
          ),
        ],
      ),
    );
  }
}
