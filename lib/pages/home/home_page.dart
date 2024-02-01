import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import '../../utilities/custom_app_bar.dart';
import '../music/videoList_detail_page.dart';
import '/pages/home/body.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  List<Video>? contentList;
  late Future trending;
  late double progressPosition;

  @override
  void initState() {
    super.initState();
    trending = youtubeDataApi
        .fetchTrendingMusic(); // Fetch trending music videos initially
    contentList = [];
  }

  @override
  Widget build(BuildContext context) {
    progressPosition = MediaQuery.of(context).size.height / 0.5;
    return Stack(
      children: <Widget>[
        // 배경 이미지를 위한 Positioned.fill 위젯
        Positioned.fill(
          child: Image.asset(
            'assets/background.gif', // 여기에 이미지 경로를 입력하세요.
            fit: BoxFit.cover, // 이미지가 화면 전체를 채우도록 설정
          ),
        ),
        // Scaffold 위젯을 배경 이미지 위에 배치
        Scaffold(
          appBar: CustomAppBar(),
          body: body(),
          backgroundColor: Colors.transparent, // Scaffold의 배경색을 투명으로 설정
        ),
      ],
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // InkWell(
            //   onTap: () {
            //     const List<String> _videoIds = [
            //       '7HDeem-JaSY',
            //       'D8VEhcPeSlc',
            //       '6ZUIwj3FgUY',
            //       'zSQ48zyWZrY',
            //       'Os_heh8vPfs',
            //       'YBzJ0jmHv-4',
            //       'siF3GM68IDE',
            //       'p2lYr3vM_1w',
            //       'Y-AGAc5oigU',
            //       'eB6txyhHFG4'
            //     ];
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (_) => VideoListDetailPage(
            //                   videoIds: _videoIds,
            //                 )));
            //   },
            //   child: Container(
            //     alignment: Alignment.center,
            //     width: 170,
            //     height: 70,
            //     color: Colors.white,
            //     child: const Text(
            //       '게시판 별자리 음악 재생버튼',
            //       maxLines: 1,
            //       style: TextStyle(
            //         color: Color(0xFF1b1c1e),
            //       ),
            //     ),
            //   ),
            // ),
            FutureBuilder(
              future: trending,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                    return const Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.none:
                    return const Text("Connection None");
                  case ConnectionState.done:
                    if (snapshot.error != null) {
                      return Container(
                          child: Text(snapshot.stackTrace.toString()));
                    } else {
                      if (snapshot.hasData) {
                        contentList = snapshot.data;
                        return Body(contentList: contentList!);
                      } else {
                        return Center(
                            child: Container(child: const Text("No data")));
                      }
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _refresh() async {
    List<Video> newList = await youtubeDataApi.fetchTrendingMusic();
    // print("Number of Videos in New List: ${newList.length}"); // 추가된 라인
    if (newList.isNotEmpty) {
      setState(() {
        contentList = newList;
      });
      return true;
    }
    return false;
  }
}
