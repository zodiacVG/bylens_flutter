import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bylens/model/popular_model.dart';
import 'package:bylens/model/home_page_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bylens/views/movie_list_view.dart';
import 'network/search_movie_request.dart';
import 'package:bylens/views/movie_list_view_lite.dart';
import 'package:bylens/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:bylens/network/populat_movie_request.dart';
import 'package:bylens/model/popular_model.dart';
import 'package:bylens/model/home_page_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bylens/views/movie_list_view.dart';
import 'package:bylens/search_page.dart';

class SearchResultPage extends StatefulWidget {
  var searchWords;
  var newSearchWords;
  bool noResult = false;

  SearchResultPage({Key key, this.searchWords}) : super(key: key);
  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  List<popularTmdb> movies = []; //搜索得到的电影结果
  SearchMoviesRequest searchMoviesRequest = SearchMoviesRequest();
  Future<String> futureMovies;

  @override
  void initState() {
    EasyLoading.init();
    // getSearchMovies(widget.searchWords);
    super.initState();
    futureMovies = getSearchMovies(widget.searchWords); //获取信息的future任务
  }

  Future<String> getSearchMovies(searchWords) async {
    print('现在的关键词');
    print(searchWords);
    //获取search
    var result = await searchMoviesRequest.getSearchResultList(searchWords);
    print('从函数获取信息');
    print(result);
    if(result.length==0){
      return 'no_result';
    }
    setState(() {
      movies = [];
      movies.addAll(result);
    });
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
                  getSearchBarUI(),
                  FutureBuilder(
                    future: futureMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('从data里获取数据');
                        print(snapshot.data);
                        if(snapshot.data=='have_result'){
                          return Container(
                              child: movieListViewLite(
                                onTapCallback: (movieID) {
                                  switchToMovieDetail(movieID);
                                },
                                movieData: movies[0],
                              ));
                        }else{
                          return Text('No Result, Please Search Again');
                        }

                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // By default, show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  )
                  // Container(
                  //     child: movieListViewLite(
                  //   callback: () {},
                  //   movieData: movies[0],
                  // )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                      widget.newSearchWords = txt;
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by the movie name',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HotelAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SearchResultPage(searchWords: widget.newSearchWords)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20,
                      color: HotelAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
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
                  'ByLens',
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
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.favorite_border),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        setState(() {
                          //todo
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search_rounded),
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
          builder: (BuildContext context) =>
              MovieDetailPage(movieID: movieID) ),
    );
  }
}
