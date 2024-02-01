import 'package:flutter/material.dart';

// 카드 프레임
class StarCard extends StatelessWidget {
  const StarCard(
      {super.key, this.width = 237, this.height = 350, required this.child});
  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(72),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16)),
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff64FFEE), Color(0xffFFFFFF)]),
              color: Colors.white),
        ),
      ),
      Positioned(
        left: 5,
        top: 5,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(72),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16)),
          child: SizedBox(width: width - 10, height: height - 10, child: child),
        ),
      ),
    ]);
  }
}
