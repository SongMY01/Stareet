// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
class PlayPauseButtonBar extends StatelessWidget {
  // final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 45,
          child: IconButton(
            icon: Image.asset('assets/10back.png'),
            onPressed: () async {
              final double current = await context.ytController.currentTime;
              final double newTime = (current - 10).clamp(0, current);
              context.ytController
                  .seekTo(seconds: newTime, allowSeekAhead: true);
              await context.ytController.playVideo();
            },
          ),
        ),
        const SizedBox(width: 15),
        YoutubeValueBuilder(
          builder: (context, value) {
            return SizedBox(
              width: 80,
              child: IconButton(
                icon: value.playerState == PlayerState.playing
                    ? Image.asset('assets/stopButton.png')
                    : Image.asset('assets/playButton.png'),
                onPressed: () {
                  value.playerState == PlayerState.playing
                      ? context.ytController.pauseVideo()
                      : context.ytController.playVideo();
                },
              ),
            );
          },
        ),
        const SizedBox(width: 15),
        SizedBox(
          width: 45,
          child: IconButton(
            icon: Image.asset('assets/10go.png'),
            onPressed: () async {
              final double current = await context.ytController.currentTime;
              final double newTime = current + 10;
              context.ytController
                  .seekTo(seconds: newTime, allowSeekAhead: true);
              await context.ytController.playVideo();
            },
          ),
        ),
      ],
    );
  }
}
