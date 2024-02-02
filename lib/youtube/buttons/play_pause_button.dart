// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

///
class PlayPauseButton extends StatelessWidget {
  // final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(
      builder: (context, value) {
        return SizedBox(
          width: 30,
          child: IconButton(
            icon: value.playerState == PlayerState.playing
                ? Image.asset('assets/alert_stop.png')
                : Image.asset('assets/alert_play.png'),
            onPressed: () {
              value.playerState == PlayerState.playing
                  ? context.ytController.pauseVideo()
                  : context.ytController.playVideo();
            },
          ),
        );
      },
    );
  }
}
