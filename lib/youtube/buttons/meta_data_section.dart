// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../utilities/color_scheme.dart';
import '../../utilities/text_theme.dart';

///
class MetaDataSection extends StatelessWidget {
  const MetaDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return YoutubeValueBuilder(
      buildWhen: (o, n) {
        return o.metaData != n.metaData ||
            o.playbackQuality != n.playbackQuality;
      },
      builder: (context, value) {
        return Column(
          children: [
            Text(
              value.metaData.title,
              style: bold22,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              value.metaData.author,
              style: bold18.copyWith(color: AppColor.sub1),
              maxLines: 1,
            ),
          ],
        );
      },
    );
  }
}
