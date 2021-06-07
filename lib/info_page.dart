import 'package:bylens/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/home_page_theme.dart';
import 'my_favor_page.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bylens/model/home_page_theme.dart';

class InfoPage extends StatefulWidget{
  @override
  _InfoPageState createState() {
    return _InfoPageState();
  }

}

class _InfoPageState extends State<InfoPage>{
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
                   Container(
                     padding: EdgeInsets.only(left: 25,right: 25),
                     child: Column(
                       children: [
                         Container(
                           height: 30,
                         ),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               children: [
                                 Icon(
                                     Icons.lightbulb_outline,
                                   color: HotelAppTheme.buildLightTheme().accentColor,
                                 ),
                                 Text(
                                     'How to use BY LENS?',
                                   style: TextStyle(
                                     fontSize: 20,
                                     color:Colors.black26,
                                     fontWeight: FontWeight.w600
                                   ),
                                 )
                               ],
                             ),
                             Container(
                               height: 10,
                               width: MediaQuery.of(context).size.width-60,
                             ),
                             Row(
                               children: [
                                 Container(
                                   width: 25,
                                 ),
                                 Container(
                                   width: MediaQuery.of(context).size.width-100,
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Container(
                                         child: Text(
                                           '🎈 View home page to find what you like.',
                                           style: TextStyle(
                                               fontSize: 15,
                                               fontWeight: FontWeight.w500
                                           ),
                                         ),
                                       ),
                                       Text(
                                         '🎈 Tap ♥ on movie card to add it to favor list.',
                                         style: TextStyle(
                                             fontSize: 15,
                                             fontWeight: FontWeight.w500
                                         ),
                                       ),
                                       Text(
                                         '🎈 Tap 🔍 to search movies, and add them.',
                                         style: TextStyle(
                                             fontSize: 15,
                                             fontWeight: FontWeight.w500
                                         ),
                                       ),
                                       Text(
                                         '🎈 Tap ♥ on bar to view your favor list.',
                                         style: TextStyle(
                                             fontSize: 15,
                                             fontWeight: FontWeight.w500
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ],
                     ),
                   )
                 ],
               ),
             ),
             Positioned(
               bottom: 70,
                 child: Container(
                   padding: EdgeInsets.only(left: 25,right: 25),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
                       Text(
                           'By Lens is based on TheMovieDataBase API.'
                       ),
                       ElevatedButton(
                           onPressed:_launchURL,
                           child: Text(
                               'Visit TheMovieDB API'
                           )
                       ),
                       Container(
                         height: 50,
                       ),
                       Text(
                         'Developed by ZodiacVG',
                         style: TextStyle(
                             fontWeight: FontWeight.w700
                         ),
                       ),
                       ElevatedButton(
                           onPressed:_launchGithubURL,
                           child: Text(
                               'Contact me on Github'
                           )
                       )
                     ],
                   ),
                 )
             )
           ],
         ),
       ),
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
            Container(
              child: Center(
                child: Text(
                  'Help & Info',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
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
                        Navigator.pop(context); //点击应当能回到首页
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.home_outlined),
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

  void switchToFavorMovie() { //跳转至movie详情界面
    Navigator.push(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) =>
              MyFavorPage()),
    );
  }

  void _launchURL() async =>
      await canLaunch('https://developers.themoviedb.org/3') ? await launch('https://developers.themoviedb.org/3') : throw 'Could not launch https://developers.themoviedb.org/3';

  void _launchGithubURL() async =>
      await canLaunch('https://github.com/zodiacVG/bylens_flutter') ? await launch('https://github.com/zodiacVG/bylens_flutter') : throw 'Could not launch https://github.com/zodiacVG/bylens_flutter';

}