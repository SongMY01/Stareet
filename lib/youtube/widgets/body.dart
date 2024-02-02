import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'video_widget.dart';

// ignore: must_be_immutable
class Body extends StatefulWidget {
  List<Video> contentList;

  Body({Key? key, required this.contentList}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(contentList);
}

class _BodyState extends State<Body> {
  List<Video> contentList;

  _BodyState(this.contentList);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          return video(contentList[index]);
        },
      ),
    );
  }

  Widget video(Video video) {
    return VideoWidget(
      video: video,
    );
  }
}
