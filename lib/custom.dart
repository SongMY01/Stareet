import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';

import '../pages/home/body.dart';
import '/helpers/suggestion_history.dart';
import '/pages/search_page.dart';

class CustomSearchPage extends StatefulWidget {
  @override
  _CustomSearchPageState createState() => _CustomSearchPageState();
}

class _CustomSearchPageState extends State<CustomSearchPage> {
  final YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  final list = SuggestionHistory.suggestions;
  final searchController = TextEditingController();
  String query = '';

  List? contentList;
  bool isLoading = false;
  bool firstLoad = true;
  String API_KEY = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background.gif', // 여기에 이미지 경로를 입력하세요.
            fit: BoxFit.cover, // 이미지가 화면 전체를 채우도록 설정
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('원하는 타이틀'),
            leading: const BackButton(),
          ),
          body: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 6, 6, 6),
                    fontSize: 16,
                  ),
                  // suffixIcon 매개변수 정의
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      query = '';
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
              query.isEmpty
                  ? _buildTrendingMusicBody()
                  : _buildSearchResultsBody(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingMusicBody() {
    return Expanded(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: youtubeDataApi.fetchTrendingMusic(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                return const Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.none:
                return const Text("Connection None");
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Container(child: Text(snapshot.error.toString()));
                } else if (snapshot.hasData) {
                  List<Video> contentList = snapshot.data;
                  return Body(contentList: contentList);
                } else {
                  return Center(child: Container(child: const Text("No data")));
                }
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchResultsBody() {
    return Expanded(
      child: FutureBuilder(
        future: youtubeDataApi.fetchSuggestions(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<String> suggestions = snapshot.data;
            return ListView.builder(
              shrinkWrap: true, // ListView가 차지할 수 있는 공간을 최소화

              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    setState(() {
                      searchController.text = suggestions[index];
                      query = suggestions[index];
                    });
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SearchPage(query)));
                  },
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
