import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/info.dart';
import '../../utilities/text_theme.dart';
import '../buttons/meta_data_section.dart';
import '../buttons/play_pause_button_bar.dart';

class VideoDetailPage extends StatefulWidget {
  final String markerId;
  final String ownerId;
  final String videoId;
  final String nickName;
  final String profileImg;

  VideoDetailPage(
      {super.key,
      required this.markerId,
      required this.ownerId,
      required this.videoId,
      required this.nickName,
      required this.profileImg});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late YoutubePlayerController _controller;
  String loggedInUid = FirebaseAuth.instance.currentUser!.uid;
  late String profileImage;

  Future<StarInfo> fetchStarInfo(String markerId) async {
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.ownerId)
        .collection('Star')
        .doc(markerId)
        .get();

    // 가져온 문서를 StarInfo 객체로 변환하여 반환함
    return StarInfo.fromMap(doc.data()!);
  }

  @override
  void initState() {
    super.initState();
    loggedInUid = FirebaseAuth.instance.currentUser!.uid;

    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: false,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        log('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
  }

  bool heartCheck = false;
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return FutureBuilder(
            future: fetchStarInfo(widget.markerId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget(); // 로딩 중일 때 표시할 위젯
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // 에러 발생 시 표시할 위젯
              } else {
                StarInfo starInfo = snapshot.data!;
                if (starInfo.like?.contains(loggedInUid) ?? true) {
                  heartCheck = true;
                }
                return Scaffold(
                  backgroundColor: AppColor.background,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text('${starInfo.address}', style: bold16),
                    actions: <Widget>[
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.more_vert)),
                    ],
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 13),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                              text: widget.nickName,
                                              style: bold22.copyWith(
                                                  color: AppColor.primary)),
                                          const TextSpan(
                                              text: '님이 추천하는', style: bold22),
                                        ],
                                      ),
                                    ),
                                    const Text(
                                      '이곳에 어울리는 음악',
                                      style: bold22,
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(widget.ownerId)
                                          .collection('Star')
                                          .doc(widget.markerId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }

                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        }
                                        List<String> likes = List<String>.from(
                                            (snapshot.data?.data() as Map<
                                                    String,
                                                    dynamic>)?['like'] ??
                                                []);

                                        bool heartCheck =
                                            likes.contains(loggedInUid);

                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (heartCheck) {
                                                  likes.remove(loggedInUid);
                                                } else {
                                                  likes.add(loggedInUid);
                                                }

                                                await snapshot.data?.reference
                                                    .update({'like': likes});
                                              },
                                              child: (likes?.contains(
                                                          loggedInUid) ??
                                                      false)
                                                  ? Image.asset(
                                                      "assets/images/heart_yes.png",
                                                      width: 23,
                                                      height: 20,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/heart_not.png",
                                                      width: 23,
                                                      height: 20,
                                                    ),
                                            ),
                                            SizedBox(height: 4),
                                            Text('${likes.length}',
                                                textAlign: TextAlign.left,
                                                style: regular13.copyWith(
                                                    color: AppColor.sub1)),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 6),
                              ],
                            ),
                            const SizedBox(height: 7),
                            Row(
                              children: [
                                SizedBox(
                                  width: 33,
                                  height: 33,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      widget.profileImg,
                                    ),
                                    radius: 29, // 원의 반지름 설정
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.nickName,
                                  style: semibold14,
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  width: 65,
                                  height: 28,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: AppColor.primary),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '메이트️',
                                      style: bold13.copyWith(
                                          color: AppColor.primary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Stack(
                              children: [
                                SizedBox(
                                    width: 340,
                                    height: 340,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: player,
                                    )),
                                Container(
                                  width: 340,
                                  height: 340,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://i1.ytimg.com/vi/${widget.videoId}/maxresdefault.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                ClipRRect(
                                    child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: const SizedBox(
                                          width: 340,
                                          height: 340,
                                        ))),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 23, right: 23, top: 28),
                                  child: Text(
                                    '우끼끼,,,여기는 이 음악을 올린 사람이 쓴 코멘트가 있어요 우끼끼,,,여기는 이 음악을 올린 사람이 쓴 코멘트가 있어요 우끼끼,,,여기는 이 음악을 올린 사람이 쓴 코멘트가 있어요 우끼끼,,,여기는 이 음악을 올린 사람이 쓴 코멘트가 있어요 여기에는 사람이 쓴 코멘트',
                                    textAlign: TextAlign.justify,
                                    style: kimregular15,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              '${starInfo.title}',
                              style: bold22,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${starInfo.singer}',
                              style: bold18.copyWith(color: AppColor.sub1),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Controls(),
                      ),
                    ],
                  ),
                );
              }
            });
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VideoPositionSeeker(),
            SizedBox(height: 100),
          ],
        ),
        Center(
            child: Column(
          children: [
            SizedBox(height: 55),
            PlayPauseButtonBar(),
          ],
        )),
      ],
    );
  }
}

class VideoPositionIndicator extends StatelessWidget {
  const VideoPositionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.ytController;

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      initialData: const YoutubeVideoState(),
      builder: (context, snapshot) {
        final position = snapshot.data?.position.inMilliseconds ?? 0;
        final duration = controller.metadata.duration.inMilliseconds;

        return LinearProgressIndicator(
          value: duration == 0 ? 0 : position / duration,
          minHeight: 1,
        );
      },
    );
  }
}

///
class VideoPositionSeeker extends StatelessWidget {
  ///
  const VideoPositionSeeker({super.key});

  @override
  Widget build(BuildContext context) {
    var value = 0.0;

    return Row(
      children: [
        Expanded(
          child: StreamBuilder<YoutubeVideoState>(
            stream: context.ytController.videoStateStream,
            initialData: const YoutubeVideoState(),
            builder: (context, snapshot) {
              final position = snapshot.data?.position.inSeconds ?? 0;
              final duration = context.ytController.metadata.duration.inSeconds;
              value = position == 0 || duration == 0 ? 0 : position / duration;
              int minutes = position ~/ 60;
              int seconds = position % 60;
              String currentTime =
                  '$minutes:${seconds.toString().padLeft(2, '0')}';

              int totalMinutes = duration ~/ 60;
              int totalSeconds = duration % 60;
              String totalTime =
                  '$totalMinutes:${totalSeconds.toString().padLeft(2, '0')}';
              return Column(
                children: [
                  StatefulBuilder(
                    builder: (context, setState) {
                      return SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: CustomSliderThumbCircle(
                              thumbRadius: 14.62 / 2,
                              padding: (18 - 14.62) / 2),
                          trackHeight: 4.0,
                        ),
                        child: Slider(
                          activeColor: const Color(0xFF64FFED),
                          value: value,
                          onChanged: (positionFraction) {
                            value = positionFraction;
                            setState(() {});
                            context.ytController.seekTo(
                              seconds: (value * duration).toDouble(),
                              allowSeekAhead: true,
                            );
                          },
                          min: 0,
                          max: 1,
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 27),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(currentTime, style: bold13),
                        const SizedBox(width: 286),
                        Text(totalTime, style: bold13)
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final double padding;

  CustomSliderThumbCircle({required this.thumbRadius, required this.padding});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius + padding);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    // Outer white circle
    final Paint outerCirclePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, thumbRadius + padding, outerCirclePaint);

    // Inner gradient circle
    final Paint innerCirclePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment(1.00, 0.00),
        end: Alignment(-1, 0),
        colors: [Color(0xFF64FFED), Color(0xFFF0F2BD)],
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius));
    canvas.drawCircle(center, thumbRadius, innerCirclePaint);
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            width: 124,
            height: 6,
            decoration: BoxDecoration(
                color: AppColor.text, borderRadius: BorderRadius.circular(24)),
          ),
        ),
      ],
    );
  }
}
