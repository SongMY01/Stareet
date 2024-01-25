import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';

import '../pages/home/body.dart';
import '/helpers/suggestion_history.dart';
import '/pages/search_page.dart';

class DataSearch extends SearchDelegate<String> {
  final YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  final list = SuggestionHistory.suggestions;
  @override
  InputDecorationTheme get searchFieldDecorationTheme =>
      const InputDecorationTheme(
        fillColor: Color.fromRGBO(255, 255, 255, 0.1),
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // 테두리 색상을 흰색으로 지정
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white, // 원하는 색상으로 변경
          ),
        ),
        hintStyle: TextStyle(
          color: Color.fromARGB(255, 6, 6, 6), // 텍스트 색상 설정
          fontSize: 16, // sub_text2의 폰트 사이즈에 맞게 설정하세요.
        ),
      );
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.white, // 원하는 색상으로 변경
      hintColor: Colors.white, // 원하는 색상으로 변경
      focusColor: Colors.white, // 원하는 색상으로 변경
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black, // AppBar 배경을 투명하게 설정합니다.
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff2d2d2d), // 상태 바 색상을 설정합니다.
          statusBarIconBrightness: Brightness.dark, // 상태 바 아이콘을 어둡게 설정합니다.
          statusBarBrightness: Brightness.dark, // 상태 바 밝기를 어둡게 설정합니다.
        ),
      ),
      inputDecorationTheme: searchFieldDecorationTheme,
      textTheme: TextTheme(subtitle1: searchFieldStyle),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            close(context, "");
          },
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchPage(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Video>? contentList;
    return Stack(
      children: [
        Positioned(
          top: 0, // 원하는 위치로 변경
          child: Container(
            width: MediaQuery.of(context).size.width, // 화면의 너비로 설정
            height: MediaQuery.of(context).size.height, // 화면의 높이로 설정
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        query.isEmpty
            ? SingleChildScrollView(
                child: FutureBuilder(
                  future: youtubeDataApi.fetchTrendingMusic(),
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
              )
            : FutureBuilder(
                future: youtubeDataApi.fetchSuggestions(query),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var snapshots = snapshot.data;
                    List<String> suggestions = query.isEmpty ? list : snapshots;
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            list.add(query);
                            query = suggestions[index];
                            showResults(context);
                          },
                          child: ListTile(
                            leading: const Icon(Icons.north_west),
                            title: Text(suggestions[index]),
                          ),
                        );
                      },
                      itemCount: suggestions.length,
                    );
                  }
                  return Container();
                },
              ),
      ],
    );
  }
}
