import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_api/utilities/info.dart';
import 'package:youtube_data_api/models/video.dart';
import '../utilities/color_scheme.dart';
import '../utilities/text_theme.dart';

class CommentPage extends StatefulWidget {
  Video video;
  CommentPage({super.key, required this.video});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _textFieldController = TextEditingController();
  Shader linearGradient = const LinearGradient(
    colors: [Color(0xFF64FFEE), Color(0xFFF0F2BD)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/fonts/images/background.gif'),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("발자국 남기기", style: bold16),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '포항시 양덕동',
                        style: bold20.copyWith(
                          foreground: Paint()..shader = linearGradient,
                        ),
                      ),
                      const TextSpan(text: '에 별자국을 남길게요', style: bold20),
                    ],
                  ),
                ),
                const SizedBox(height: 27),
                Row(
                  children: <Widget>[
                    Stack(
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: Image.network(
                            'https://i1.ytimg.com/vi/${widget.video.videoId}/maxresdefault.jpg',
                            fit: BoxFit.fitHeight,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.network(
                                'https://i1.ytimg.com/vi/${widget.video.videoId}/sddefault.jpg',
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
                            Text(
                              widget.video.title ?? '',
                              textAlign: TextAlign.left,
                              style: bold17,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ), //video title
                            Text(widget.video.channelName ?? '',
                                textAlign: TextAlign.left,
                                style: regular13.copyWith(
                                    color: AppColor.sub2)), //video channel
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 31),
                Text(
                  '코멘트를 남겨 보세요',
                  style: regular13.copyWith(color: AppColor.sub2),
                ),
                const SizedBox(height: 8),
                Center(
                  child: SizedBox(
                    height: 190,
                    child: TextField(
                        controller: _textFieldController,
                        maxLength: 150,
                        maxLines: 10,
                        cursorColor: Colors.blueAccent,
                        style: regular15.copyWith(color: AppColor.text2),
                        decoration: InputDecoration(
                          fillColor: AppColor.text,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // border-radius: 10px
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(
                                  255, 255, 255, 0.3), // border 색상과 투명도
                              width: 1.0, // border: 1px
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.3),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 0.3),
                              width: 1.0,
                            ),
                          ),
                          hintStyle: regular15.copyWith(color: AppColor.sub2),
                          hintText: '노래와 관련된 추억을 남겨보세요',
                        ),
                        onSubmitted: (text) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (text) {
                          setState(() {});
                        }),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () async {
                      final docRef =
                          FirebaseFirestore.instance.collection("Star").doc();
                      await docRef.set({
                        uidFieldName: docRef.id,
                        registerTimeFieldName: FieldValue.serverTimestamp(),
                        locationFieldName: [
                          36.084607301484596,
                          129.3957316179093
                        ],
                        songFieldName: widget.video,
                        commentFieldName: "코멘트",
                        ownerFieldName:
                            'FirebaseAuth.instance.currentUser!.uid',
                        addressFieldName: '포항시 북구 양덕동',
                        likeFieldName: 0
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        height: 48,
                        margin: const EdgeInsets.fromLTRB(25, 0, 25, 50),
                        decoration: _textFieldController.text.isEmpty
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColor.sub2,
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF64FFEE),
                                    Color(0xFFF0F2BD)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                        child: Center(
                            child: Text('남기기',
                                style:
                                    bold17.copyWith(color: AppColor.text2)))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
