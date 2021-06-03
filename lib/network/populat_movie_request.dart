import 'dart:convert' as convert;
import 'package:bylens/model/popular_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class PopularRequest {
  Future<dynamic> getMoviePopularList(int page) async { //todo 格式原来是List<popularTmdb>
    var result;
    print('开始');
    // 1.拼接URL
    final url = "https://api.themoviedb.org/3/movie/popular?api_key=3c4cb870e3f3c729ef1eb2d0538ba4f7&language=en-US?page=$page";
    // 2.发送请求
    try{
      var response = await http.get(Uri.parse(url),headers: {"Accept": "application/json"});
      print(response);
      if (response.statusCode == 200) {
        print('代码ok');
        var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
        print('json is:');
        print(json);
        result = json['results']; //不确定是不是这样
      } else {
        print('不太行');
        result =
        'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    }catch(e){
      print('e出错');
      print(e);
    }
    // 3.转成模型对象
    final subjects = result;
    List<popularTmdb> movies = [];
    for (var sub in subjects) {
      movies.add(popularTmdb.fromJson(sub));
    }
    print(movies);
    //todo 这里为了测试返回了result
    return result;
  }
}