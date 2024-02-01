import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_api/pages/comment.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';
import '../buttons/play_pause_button.dart';

class CustomDialog extends StatefulWidget {
  Video video;

  CustomDialog({super.key, required this.video});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.video.videoId as String,
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

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        controller: _controller,
        builder: (context, player) {
          return Dialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(21), // border-radius: 21px;
            ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  width: 317, // width: 317px;
                  height: 333, // height: 333px;
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(23, 23, 23, 0.85),
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(
                      color: const Color(0xFFFEFEFE),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentPage(
                                      video: widget.video,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '선택',
                                style:
                                    semibold16.copyWith(color: AppColor.text),
                              ),
                            )
                          ]),
                      Stack(
                        children: [
                          Container(
                              width: 139,
                              height: 139,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(69.5),
                                child: player,
                              )),
                          Container(
                            width: 139,
                            height: 139,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(69.5),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://i1.ytimg.com/vi/${widget.video.videoId}/maxresdefault.jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11.9),
                      Text(
                        widget.video.title ?? '',
                        style: bold18,
                        maxLines: 1,
                      ),
                      Text(
                        widget.video.channelName ?? '',
                        style: regular15,
                        maxLines: 1,
                      ),
                      // const VideoPositionIndicator(),
                      const SizedBox(height: 29.9),
                      const Controls(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

class Controls extends StatelessWidget {
  ///
  const Controls({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VideoPositionSeeker(),
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

              return StatefulBuilder(
                builder: (context, setState) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: CustomSliderThumbCircle(
                          thumbRadius: 14.62 / 2, padding: (18 - 14.62) / 2),
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
              );
            },
          ),
        ),
        PlayPauseButton(),
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
