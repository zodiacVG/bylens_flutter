import 'dart:convert';

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
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _prefs;
  // 喜爱的电影id列表
  static List<String> favorMovieList;
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var movieList=_prefs.getString('favorMovieList');
    if (movieList != null) {
      try {
         favorMovieList= jsonDecode(movieList); //todo 不确定，因为movielist是json格式的，不知道能不能转换
      } catch (e) {
        print(e);
      }
    }
  }
}