import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'alert.dart';
import '../music/video_search_page.dart';

class VideoWidget extends StatelessWidget {
  final Video video;

  VideoWidget({
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
                Container(
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ), //video title
                    Text(
                      video.channelName ?? '',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ), //video channel
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  navigateToPlayer(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => VideoSearchPage(video: video)));

    // List<String> videoIds = [];
    // videoIds.add(video.videoId!);
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (_) => VideoDetailPage(videoIds: videoIds)));
  }
}
