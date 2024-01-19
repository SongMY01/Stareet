import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';
import '../../utilities/custom_app_bar.dart';
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
    return Scaffold(
      backgroundColor: Color(0xFF1b1c1e),
      appBar: CustomAppBar(),
      body: body(),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
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
