import 'package:bylens/model/home_page_theme.dart';
import 'package:bylens/model/popular_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class movieListViewLite extends StatelessWidget {
  const movieListViewLite( //单条电影信息
      {
    Key key,
    this.onTapCallback,
    this.movieData, //单条电影信息
  }) : super(key: key);

  final ValueChanged onTapCallback;
  final popularTmdb movieData; //单条数据,model对象形式

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          onTapCallback(movieData.id); //将触摸事件回调回去
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
                child: Column(children: <Widget>[
              AspectRatio(
                aspectRatio: 2,
                child: Image.network(
                  'https://image.tmdb.org/t/p/original' +
                      movieData.backdropPath,
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
                                movieData.title,
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
                                    movieData.releaseDate,
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
                                      movieData.originalLanguage,
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
                            allowHalfRating: true,
                            starCount: 5,
                            rating: movieData.voteAverage / 2,
                            size: 20,
                            color: HotelAppTheme.buildLightTheme().primaryColor,
                            borderColor:
                                HotelAppTheme.buildLightTheme().primaryColor,
                          ),
                          Text(
                            movieData.voteAverage.toString(),
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
                    movieData.overview,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                  ),
                ),
              )
            ])
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
}
