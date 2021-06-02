import 'dart:convert';
import 'package:bylens/model/popular_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class PopularRequest {
  Future<dynamic> getMoviePopularList(int page) async { //todo 格式原来是List<popularTmdb>
    String result;
    var httpClient = new HttpClient();
    print('开始');
    // 1.拼接URL
    final url = "https://api.themoviedb.org/3/movie/popular?api_key=3c4cb870e3f3c729ef1eb2d0538ba4f7&language=en-US?page=$page";

    // 2.发送请求
    try{
      final request = await httpClient.getUrl(Uri.parse(url));
      print(request);
      var response=await request.close();
      print(response);
      if (response.statusCode == HttpStatus.OK) {
        print('代码ok');
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        result = data.page.results; //不确定是不是这样
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
    // final subjects = result;
    // List<popularTmdb> movies = [];
    // for (var sub in subjects) {
    //   movies.add(popularTmdb.fromJson(sub));
    // }
    //todo 这里为了测试返回了result
    return result;
  }
}