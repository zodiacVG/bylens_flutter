import 'package:flutter/material.dart';
import 'package:bylens/network/populat_movie_request.dart';
import 'package:bylens/model/popular_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'By Lens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'By Lens'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Map result = {};
  String text = '没被点';
  PopularRequest popularRequest=PopularRequest();
  List<popularTmdb> movies =[];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void afterTap() {
    setState(() {
      text = 'aftertap';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$text',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('电解铝');
          afterTap();
          var result;
          print('开始');
          // 1.拼接URL
          final url = "https://api.themoviedb.org/3/movie/popular?api_key=3c4cb870e3f3c729ef1eb2d0538ba4f7&language=en-US?page=1";
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
          print('点完了');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
