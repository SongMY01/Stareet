import 'package:flutter/material.dart';
import 'package:youtube_data_api/models/video.dart';
import 'package:youtube_data_api/youtube_data_api.dart';

import '../../pages/home/body.dart';
import '../utilities/color.dart';
import '../utilities/text_style.dart';
import '../youtube/helpers/suggestion_history.dart';
import '../youtube/widgets/video_widget.dart';

class DataSearchPage extends StatefulWidget {
  @override
  _DataSearchPageState createState() => _DataSearchPageState();
}

class _DataSearchPageState extends State<DataSearchPage> {
  final YoutubeDataApi youtubeDataApi = YoutubeDataApi();
  final list = SuggestionHistory.suggestions;
  final searchController = TextEditingController();
  String query = '';

  List? contentList;
  bool isLoading = false;
  bool firstLoad = true;
  String API_KEY = "";

  FocusNode textfieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/background.gif', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              '음악 검색',
              style: bold16,
            ),
            leading: const BackButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 25, top: 22, right: 25),
            child: Column(
              children: [
                TextField(
                  focusNode: textfieldFocusNode,
                  controller: searchController,
                  style: medium16,
                  decoration: InputDecoration(
                    fillColor: const Color.fromRGBO(255, 255, 255, 0.1),
                    filled: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                    border: OutlineInputBorder(
                      // 테두리 스타일 정의
                      borderRadius:
                          BorderRadius.circular(5.0), // border-radius: 5px
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(
                            255, 255, 255, 0.3), // border 색상과 투명도
                        width: 1.0, // border: 1px
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      // 기본 테두리 스타일
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // 포커스 시 테두리 스타일
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        width: 1.0,
                      ),
                    ),
                    hintStyle: medium14.copyWith(color: AppColor.subtext2),
                    hintText: '곡의 제목, 가수를 검색해주세요',
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          query = '';
                          setState(() {
                            contentList = null;
                          });
                          textfieldFocusNode.requestFocus(); // 이 부분을 추가하세요.
                        },
                        icon: const Icon(Icons.close, color: Colors.white)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                  },
                  onTap: () {
                    setState(() {
                      // 사용자가 텍스트 필드를 탭하면 contentList를 null로 설정
                      contentList = null;
                    });
                  },
                  onSubmitted: (value) {
                    _search(value);
                  },
                ),
                query.isNotEmpty && contentList != null
                    ? _buildSearchResultDetailBody()
                    : (query.isEmpty
                        ? _buildTrendingMusicBody()
                        : _buildSearchResultsBody()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _search(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      final results = await youtubeDataApi.fetchSearchVideo(query, API_KEY);
      setState(() {
        contentList = results;
        isLoading = false;
      });
      SuggestionHistory.store(query);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // 에러 처리 로직을 추가하세요.
    }
  }

// 검색 결과를 보여주는 본문 위젯
  Widget _buildSearchResultDetailBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contentList == null || contentList!.isEmpty) {
      return const Center(child: Text("검색 결과가 없습니다."));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: contentList!.length,
        itemBuilder: (context, index) {
          if (isLoading && index == contentList!.length - 1) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (contentList![index] is Video) {
              return video(contentList![index]);
            }
            return Container();
          }
        },
      ),
    );
  }

  Widget video(Video video) {
    return VideoWidget(
      video: video,
    );
  }

  Widget _buildTrendingMusicBody() {
    List<String> recently = list.reversed.toList(); // 최근 검색어 목록
    return Expanded(
      child: SingleChildScrollView(
        child: SizedBox(
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),
              const Text(
                "최근 검색한 음악",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                child: recently.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recently.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0
                                    ? 0
                                    : 15), // 첫 번째 칩을 제외하고 왼쪽 패딩 적용
                            child: Chip(
                              label: Text(recently[index]),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () {
                                setState(() {
                                  SuggestionHistory.remove(recently[index]);
                                });
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        },
                      )
                    : Chip(
                        label: Text(
                          "최근 검색 결과가 없습니다",
                          style: medium13.copyWith(color: AppColor.subtext2),
                        ),
                      ),
              ),
              const SizedBox(height: 18),
              const Text(
                "실시간 공감 많이 받은 별자국 음악",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              FutureBuilder(
                future: youtubeDataApi.fetchTrendingMusic(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    case ConnectionState.none:
                      return const Text("Connection None");
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Container(
                            child: Text(snapshot.error.toString()));
                      } else if (snapshot.hasData) {
                        List<Video> contentList = snapshot.data;
                        return Body(contentList: contentList);
                      } else {
                        return Center(
                            child: Container(child: const Text("No data")));
                      }
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
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
            var snapshots = snapshot.data;
            List<String> suggestions = query.isEmpty ? list : snapshots;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    setState(() {
                      searchController.text = suggestions[index];
                      query = suggestions[index];
                      _search(query);
                    });
                    FocusScope.of(context).unfocus();
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
