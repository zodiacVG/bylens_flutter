import 'package:bylens/model/movie_detail_model.dart';
import 'package:bylens/network/movie_detail_request.dart';
import 'package:bylens/model/home_page_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bylens/common/global_info.dart';

class MovieDetailPage extends StatefulWidget {
  var movieID;

  MovieDetailPage({Key key, this.movieID}) : super(key: key);
  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Future futureMovieDetail; //用于fturebuilder的future
  MovieDetail movieDetail; //存放moviedetail的对象
  MovieDetailRequest movieDetailRequest = MovieDetailRequest(); //http类
  bool favorButtonSelected=false;  //是否已经在列表里了

  void initState() {
    //初始化
    // getSearchMovies(widget.searchWords);
    super.initState();
    futureMovieDetail = getMovieDetail(widget.movieID);
  }

  Future<String> getMovieDetail(id) async {
    print('开始了');
    var result = await movieDetailRequest.getMovieDetail(id);
    print('result is:');
    print(result);
    setState(() {
      movieDetail = result;
    });
    if(Global.favorMovieList.contains(movieDetail.id)){
      favorButtonSelected=true; //已经在收藏列表里面了
    }
    return 'get_success';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          body: FutureBuilder(
        future: futureMovieDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('从data里获取数据');
            print(snapshot.data);
            if (snapshot.data == 'get_success') {
              // return Text(movieDetail.title);
              return buildDetailWidget(); //创建详情页面
            } else {
              return Text('No Result, Please Search Again');
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return CircularProgressIndicator();
        },
      )),
    );
  }

  Widget buildDetailWidget() {
    return ListView(
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
              'https://image.tmdb.org/t/p/original' + movieDetail.backdropPath,
            ),
              Positioned(
                    top: MediaQuery.of(context).size.width*(13/32),
                    right: 8,
                    child: Material(
                        color: Colors.transparent,
                        child: favorButtonSelected? selectedFavor():unSelectedFavor()
                      //未被选择/选择的爱心
                    ),
                  )
            ]
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            movieDetail.title,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                movieDetail.releaseDate,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey.withOpacity(0.8)),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Icon(FontAwesomeIcons.globe,
                                  size: 14, color: Colors.black26),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  movieDetail.originalLanguage,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      SmoothStarRating(
                        isReadOnly: true,
                        allowHalfRating: true,
                        starCount: 5,
                        rating: movieDetail.voteAverage / 2,
                        size: 30,
                        color: HotelAppTheme.buildLightTheme().primaryColor,
                        borderColor: HotelAppTheme.buildLightTheme().primaryColor,
                      ),
                      Text(
                        movieDetail.voteAverage.toString(),
                        style: TextStyle(
                            fontSize: 20, color: Colors.grey.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              movieDetail.overview,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ProductionCompuny',
                  style: TextStyle(
                    fontWeight: FontWeight.w800
                  ),
                ),
                Container( //占位用的
                  height: 5,
                ),
                Row(
                  children: [
                    if (movieDetail.productionCompanies[0].logoPath != null)
                      Container(
                        padding: EdgeInsets.only(left: 5,right: 15),
                        child: Image.network(
                          //logo图片可能是空的
                          'https://image.tmdb.org/t/p/original' +
                              movieDetail.productionCompanies[0].logoPath,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    Container(
                      child: Text(
                        movieDetail.productionCompanies[0].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Budget&Revenue',
                  style: TextStyle(
                      fontWeight: FontWeight.w800
                  ),
                ),
                Container( //占位用的
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      child: Text(
                        'Budget: \$'+movieDetail.budget.toString(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        'Revenue: \$'+movieDetail.revenue.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),]
    );
  }

  Widget unSelectedFavor() {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(32.0),
      ),
      onTap: () {
        print('movieID是：');
        print(movieDetail.id);
        Global.favorMovieList.add(movieDetail.id);
        Global.saveFavorList();
        setState(() {
          favorButtonSelected=true;  //这样点击了之后就会变成实心的形状
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.favorite_border,
          color: HotelAppTheme.buildLightTheme()
              .primaryColor,
          size: 40,
        ),
      ),
    );
  }

  Widget selectedFavor(){
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(32.0),
      ),
      onTap: () {
        print('点过了，没用~');
        Global.favorMovieList.remove(movieDetail.id);
        Global.saveFavorList();  //删除掉该收藏项
        setState(() {
          favorButtonSelected=false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.favorite_outlined,
          color: HotelAppTheme.buildLightTheme()
              .primaryColor,
          size: 40,
        ),
      ),
    );
  }
}
