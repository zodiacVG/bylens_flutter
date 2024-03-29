import 'package:flutter/material.dart';
import 'package:bylens/network/populat_movie_request.dart';
import 'package:bylens/model/popular_model.dart';
import 'package:bylens/model/home_page_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bylens/views/movie_list_view.dart';
import 'package:bylens/search_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bylens/movie_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bylens/common/global_info.dart';
import 'package:bylens/my_favor_page.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'info_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //一开始preference报错，这里是stackoverflow上的答案
  Global.init().then((e) => runApp(MyApp()));  //先初始化全局变量
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'By Lens',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'By Lens'),
        builder: EasyLoading.init());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  List<String> favorMovieID=[];
  //todo 一开始应当能够获得preference

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  bool _showSearchTab = false; //显示搜索框
  var searchWords = '';
  Map result = {};
  String text = '没被点';
  PopularRequest popularRequest = PopularRequest();
  List<popularTmdb> movies = [];

  //准备做美好的界面
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    EasyLoading.show(status: 'loading...');
    getPopularMovies();
  }

  void afterTap() {
    setState(() {
      text = 'aftertap';
    });
  }

  getPopularMovies() async {
    //获取pop榜单
    var result = await popularRequest.getMoviePopularList(1);
    print('从函数获取信息');
    print(result);
    setState(() {
      movies.addAll(result);
    });
    EasyLoading.dismiss();
  }

  switchToSearchPage(searchWords) async {
    await Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
              SearchResultPage(searchWords: searchWords)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
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
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Visibility(
                                  child: Column(
                                    children: <Widget>[
                                      getSearchBarUI(),
                                    ],
                                  ),
                                  visible: _showSearchTab,
                                );
                              }, childCount: 1),
                            ),
                            // SliverPersistentHeader(
                            //   pinned: true,
                            //   floating: true,
                            //   delegate: ContestTabHeader(
                            //     getFilterBarUI(),
                            //   ),
                            // ),
                          ];
                        },
                        body: Container(
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
                            itemCount: movies.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count =
                                  movies.length > 10 ? 10 : movies.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                              animationController.forward();
                              return movieListView(
                                onTapCallback: (movieID) {
                                  switchToMovieDetail(movieID);
                                },
                                onTapFavorCallback:(movieID){
                                  addFavorMovie(movieID);
                                },
                                movieData: movies[index],
                                animation: animation,
                                animationController: animationController,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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
                      searchWords = txt;
                      print(searchWords);
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
                  switchToSearchPage(searchWords);
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
            Row(
              children: [
                Container(
                  child: Center(
                      child: InkWell(
                        onTap: (){
                          switchToInfoPage();
                        },
                        child: Icon(
                            Icons.menu
                        ),
                      )
                  ),
                ),
                Container(
                  width: 5,
                ),
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

              ],
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
                        switchToFavorMovie();
                      },
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
                          _showSearchTab = !_showSearchTab;
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

  void switchToMovieDetail(movieID) { //跳转至movie详情界面
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
             MovieDetailPage(movieID: movieID) ),
    );
  }

  void switchToFavorMovie() { //跳转至movie详情界面
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
            MyFavorPage()),
    );
  }

  void addFavorMovie(movieID) async{ //添加喜爱的电影
    Global.favorMovieList.add(movieID); //添加id
    //todo 没有往reference里存
    Global.saveFavorList();
  }

  void switchToInfoPage() {
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
              InfoPage()),
    );
  }
}
