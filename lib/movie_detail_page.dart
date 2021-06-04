import 'package:bylens/model/movie_detail_model.dart';
import 'package:bylens/network/movie_detail_request.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return 'get_success';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            FutureBuilder(
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
            )
          ],
        ),
      ),
    );
  }

  Widget buildDetailWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 40.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('data'),
          ],
        ),
      ),
    );
  }
}
