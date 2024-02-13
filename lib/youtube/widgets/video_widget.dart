import 'package:flutter/material.dart';
import 'package:music_api/utilities/color_scheme.dart';
import 'package:music_api/utilities/text_theme.dart';
import 'package:youtube_data_api/models/video.dart';
import '../music/video_detail_page.dart';
import 'alert.dart';

class VideoWidget extends StatelessWidget {
  final Video video;

  const VideoWidget({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialog(
              video: video,
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, top: 10),
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  height: 51,
                  width: 51,
                  child: Image.network(
                    'https://i1.ytimg.com/vi/${video.videoId}/maxresdefault.jpg',
                    fit: BoxFit.fitHeight,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.network(
                        'https://i1.ytimg.com/vi/${video.videoId}/sddefault.jpg',
                        fit: BoxFit.fitHeight,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
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
                    Text(
                      video.title ?? '',
                      textAlign: TextAlign.left,
                      style: bold15.copyWith(color: AppColor.sub1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ), //video title
                    const SizedBox(height: 3),
                    Text(
                      video.channelName ?? '',
                      textAlign: TextAlign.left,
                      style: regular13.copyWith(color: AppColor.sub2),
                      maxLines: 1,
                    ), //video channel
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
            Column(children: [
              const SizedBox(height: 22),
              Text(video.duration ?? '',
                  textAlign: TextAlign.left,
                  style: regular13.copyWith(color: AppColor.sub2)),
            ]),
          ],
        ),
      ),
    );
  }

  navigateToPlayer(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => VideoDetailPage(video: video)));

    // List<String> videoIds = [];
    // videoIds.add(video.videoId!);
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (_) => VideoDetailPage(videoIds: videoIds)));
  }
}
