import 'package:flutter/material.dart';

import '../utilities/color_scheme.dart';
import '../utilities/text_theme.dart';

class HomeBottomsheet extends StatefulWidget {
  const HomeBottomsheet({super.key});

  @override
  State<HomeBottomsheet> createState() => _HomeBottomsheetState();
}

class _HomeBottomsheetState extends State<HomeBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        height: 289,
        margin: const EdgeInsets.only(left: 25, right: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: const Color.fromRGBO(45, 45, 45, 0),
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
                              TextSpan(text: '나는 쿼카입니다님', style: semibold17),
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
                            style: regular13.copyWith(color: AppColor.sub1)),
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
                                    Object exception, StackTrace? stackTrace) {
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
                                style:
                                    regular13.copyWith(color: AppColor.sub1)),
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
                  borderRadius: BorderRadius.circular(12), // 테두리 반경 값을 12로 설정
                  border: Border.all(color: Colors.white), // 테두리 색상을 흰색으로 설정
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
  }
}
