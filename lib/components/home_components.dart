import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../utilities/color_scheme.dart';
import '../utilities/text_theme.dart';

// 홈 화면 FAB
class PutStar extends StatelessWidget {
  final Function() putMarker;
  const PutStar({super.key, required this.putMarker});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => putMarker,
        child:
            Image.asset("assets/images/put_marker.png", width: 74, height: 74));
  }
}

// 별자리 공작소 완료 Disable
class CompleteButtonDisable extends StatelessWidget {
  const CompleteButtonDisable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 48,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColor.sub2),
      child: Center(
          child: Text("완료", style: bold17.copyWith(color: AppColor.text2))),
    );
  }
}

// 별자리 공작소 완료 Enable
class CompleteButtonEnable extends StatelessWidget {
  final Function() complete;
  const CompleteButtonEnable({super.key, required this.complete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: complete,
      child: Container(
        width: 340,
        height: 48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
                colors: [Color(0xff64FFEE), Color(0xffF0F2BD)])),
        child: Center(
            child: Text("완료", style: bold17.copyWith(color: AppColor.text2))),
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  final Function() goToLocation;
  const LocationButton({super.key, required this.goToLocation});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToLocation,
      child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(36)),
          child: const Center(
              child: Icon(Icons.my_location, size: 24, color: AppColor.text))),
    );
  }
}

// toolip
class CustomTooltip extends StatelessWidget {
  final SuperTooltipController controller;
  const CustomTooltip({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        controller.showTooltip();
      },
      // 말풍선 툴팁
      child: SuperTooltip(
        controller: controller,
        popupDirection: TooltipDirection.down,
        backgroundColor: AppColor.text,
        left: 100,
        arrowTipDistance: 20.0,
        arrowBaseWidth: 17.0,
        arrowLength: 16.0,
        showCloseButton: ShowCloseButton.none,
        touchThroughAreaShape: ClipAreaShape.rectangle,
        touchThroughAreaCornerRadius: 5,
        content: Text(
          "별과 별을 눌러서 이어요.\n플레이리스트를 만들 수 있어요\n이어진 선을 터치하면 삭제할 수 있어요.",
          // softWrap: true,
          textAlign: TextAlign.start,
          style: medium12.copyWith(color: AppColor.text2),
        ),
        child: const Icon(Icons.info_outline_rounded,
            color: AppColor.text, size: 22),
      ),
    );
  }
}

// Custom chip
class CustomChip extends StatelessWidget {
  final String name;
  final Function() function;
  final bool isSelected;
  const CustomChip(
      {super.key,
      required this.name,
      required this.function,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
          height: 26,
          padding: const EdgeInsets.fromLTRB(5.4, 5, 9, 5),
          decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xff64FFEE), Color(0xffF0F2BD)])
                  : null,
              color: isSelected ? null : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(90)),
          child: Center(
            child: Row(
              children: [
                Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white)),
                const SizedBox(width: 3.6),
                Text(name, style: semibold11.copyWith(color: AppColor.text2))
              ],
            ),
          )),
    );
  }
}
