import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';

Widget bottomnavigator(BuildContext context, Key bottomnavigationkey, PageController controller){

  return(
      CurvedNavigationBar(
        index: 2,
        key: bottomnavigationkey,
        height: 50.0,
        items: <Widget>[
          Icon(Ionicons.ios_fitness, size: 30),
          Icon(Icons.search, size: 30),
          Icon(Icons.home, size: 30),
          Icon(MaterialCommunityIcons.chart_bar, size: 30),
          Icon(MaterialCommunityIcons.calendar, size: 30),
        ],
        color: Theme.of(context).brightness == Brightness.dark? Colors.black: Colors.white,
        backgroundColor: Theme.of(context).brightness == Brightness.dark? Colors.grey: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index){
          controller.jumpToPage(index);
        },
      )
  );
}