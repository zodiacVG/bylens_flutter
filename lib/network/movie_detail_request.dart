import 'dart:convert' as convert;
import 'package:bylens/model/movie_detail_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class MovieDetailRequest {
  Future<dynamic> getMovieDetail(int id) async {
    //todo 格式是MovieDetail
    var result;
    print('开始');
    // 1.拼接URL
    final url =
        "https://api.themoviedb.org/3/movie/+$id+?api_key=3c4cb870e3f3c729ef1eb2d0538ba4f7&language=en-US";
    // 2.发送请求
    try {
      var response = await http
          .get(Uri.parse(url), headers: {"Accept": "application/json"});
      print(response);
      if (response.statusCode == 200) {
        var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        result = json; //不确定是不是这样
      } else {
        print('不太行');
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (e) {
      print('e出错');
      print(e);
    }
    // 3.转成模型对象
    var movieDetail = MovieDetail.fromJson(result);
    return movieDetail;
  }
}
