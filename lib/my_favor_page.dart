import 'dart:ui';

import 'package:bylens/network/movie_detail_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bylens/model/popular_model.dart';
import 'package:bylens/model/home_page_theme.dart';
import 'package:bylens/common/global_info.dart';
import 'package:bylens/views/movie_list_view_lite.dart';
import 'package:bylens/model/movie_detail_model.dart';
import 'package:bylens/movie_detail_page.dart';
import 'package:bylens/views/movie_list_lite_from_detail_data.dart';


class MyFavorPage extends StatefulWidget {
  List<int> favorMivieIDList; //喜爱电影的ID的list

  MyFavorPage({Key key}) : super(key: key);
  @override
  _MyFavorPageState createState() => _MyFavorPageState();
}

class _MyFavorPageState extends State<MyFavorPage>
    with TickerProviderStateMixin {
  List<MovieDetail> favorMiviesList = []; //搜索得到的电影结果
  MovieDetailRequest _movieDetailRequest=MovieDetailRequest();
  Future<String> futureMovies;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    EasyLoading.init();
    // getFavorMovieListFromRequest(widget.searchWords);
    super.initState();
    widget.favorMivieIDList=Global.favorMovieList;
    futureMovies = getFavorMovieListFromRequest(widget.favorMivieIDList); //获取信息的future任务
  }

  Future<String> getFavorMovieListFromRequest(favorMovieIDList) async {
    print('现在的movieIDList');
    print(favorMovieIDList);
    //获取search
    for (var oneMovieID in favorMovieIDList){
      var result = await _movieDetailRequest.getMovieDetail(oneMovieID);
      favorMiviesList.add(result); //挨个获取电影细节并且添加进列表
    }
    print('从函数获取信息');
    print(favorMiviesList);
    if (favorMiviesList.length == 0) {
      return 'no_result';
    }
    return 'have_result';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  getAppBarUI(),
                  FutureBuilder(
                    future: futureMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('从data里获取数据');
                        print(snapshot.data);
                        if (snapshot.data == 'have_result') {
                          return Expanded(child: getMovieResultList());
                        } else {
                          return Text('No Favor Movies, go and add one!');
                        }
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Center(
                child: Text(
                  'MyFavor',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        Navigator.pop(context); //点击应当能回到首页
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.home_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void switchToMovieDetail(movieID) {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => MovieDetailPage(movieID: movieID)),
    );
  }

  Widget getMovieResultList() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: favorMiviesList.length,
        itemBuilder: (context, i) => movieListViewLiteFromDetailData(
          onTapCallback: (movieID) {
            switchToMovieDetail(movieID);
          },
          movieData: favorMiviesList[i],
        )
    );
  }
}
