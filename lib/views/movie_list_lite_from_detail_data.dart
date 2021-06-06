import 'package:bylens/model/home_page_theme.dart';
import 'package:bylens/model/popular_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:bylens/model/movie_detail_model.dart';
import 'package:bylens/common/global_info.dart';

class movieListViewLiteFromDetailData extends StatefulWidget {
  const movieListViewLiteFromDetailData( //单条电影信息
          {
        Key key,
        this.onTapCallback,
        this.movieData, //单条电影信息
      }) : super(key: key);

  final ValueChanged onTapCallback;
  final MovieDetail movieData;
  @override
  _movieListViewLiteFromDetailDataState createState() => _movieListViewLiteFromDetailDataState();
}

class _movieListViewLiteFromDetailDataState extends State<movieListViewLiteFromDetailData> {
  bool favorButtonSelected=false;  //是否已经在列表里了

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Global.favorMovieList.contains(widget.movieData.id )){
      favorButtonSelected=true; //已经在收藏列表里面了
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          widget.onTapCallback(widget.movieData.id); //将触摸事件回调回去
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Container(
                child: Stack(
                  children:[
                  Column(children: <Widget>[
                    AspectRatio(
                      aspectRatio: 2,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/original' +
                            widget.movieData.backdropPath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: HotelAppTheme.buildLightTheme().backgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 8, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.movieData.title,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.movieData.releaseDate,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.withOpacity(0.8)),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Icon(FontAwesomeIcons.globe,
                                            size: 12, color: Colors.black26),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 4),
                                          child: Text(
                                            widget.movieData.originalLanguage,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 14,
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
                                  rating: widget.movieData.voteAverage / 2,
                                  size: 20,
                                  color: HotelAppTheme.buildLightTheme().primaryColor,
                                  borderColor:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                                ),
                                Text(
                                  widget.movieData.voteAverage.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.withOpacity(0.8)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: HotelAppTheme.buildLightTheme().backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 20, right: 20, bottom: 20),
                        child: Text(
                          widget.movieData.overview,
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    )
                  ]),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                          color: Colors.transparent,
                          child: favorButtonSelected? selectedFavor():unSelectedFavor()
                        //未被选择/选择的爱心
                      ),
                    )
                ]
                )
              // Positioned(
              //   top: 8,
              //   right: 8,
              //   child: Material(
              //     color: Colors.transparent,
              //     child: InkWell(
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(32.0),
              //       ),
              //       onTap: () {}, //todo 这里的方法应当能够记录id
              //       child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Icon(
              //           Icons.favorite_border,
              //           color: HotelAppTheme.buildLightTheme()
              //               .primaryColor,
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ),
          ),
        ),
      ),
    );
  }

  Widget unSelectedFavor() {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(32.0),
      ),
      onTap: () {
        print('movieID是：');
        print(widget.movieData.id);
        Global.favorMovieList.add(widget.movieData.id);
        Global.saveFavorList();//添加到喜爱列表,传递到上一层
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
        Global.favorMovieList.remove(widget.movieData.id);
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
        ),
      ),
    );
  }
}
