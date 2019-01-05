import 'package:flutter/material.dart';
import 'package:mou/view/KnowledgePage.dart';
import 'package:mou/view/HomePage.dart';
import 'package:mou/view/PersonalPage.dart';
import 'package:mou/view/ProjectPage.dart';

class NavigationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NavigationState();
  }
}

class NavigationState extends State<NavigationPage>
    with TickerProviderStateMixin {
  List<Widget> pageData;

  //当前页面
  int currentPosition = 0;

  // 两种动画类型
  BottomNavigationBarType animType = BottomNavigationBarType.fixed;

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.home,
              color: currentPosition == 0 ? Colors.green : Colors.black87,),
            title: new Text(
              "主页",
              style: new TextStyle(
                color: currentPosition == 0 ? Colors.green : Colors.black87,
              ),
            ),
          ),

          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.widgets,
              color: currentPosition == 1 ? Colors.green : Colors.black87,),
            title: new Text("知识体系",
              style: new TextStyle(
                color: currentPosition == 1 ? Colors.green : Colors.black87,
              ),
            ),
          ),

          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.work,
              color: currentPosition == 2 ? Colors.green : Colors.black87,),
            title: new Text(
              "项目",
              style: new TextStyle(
                color: currentPosition == 2 ? Colors.green : Colors.black87,
              ),
            ),
          ),


          new BottomNavigationBarItem(
            icon: new Icon(
              Icons.person,
              color: currentPosition == 3 ? Colors.green : Colors.black87,),
            title: new Text(
              "个人中心",
              style: new TextStyle(
                color: currentPosition == 3 ? Colors.green : Colors.black87,
              ),
            ),
          ),
        ],
        currentIndex: currentPosition,
        type: animType,
        onTap: (index) {
          setState(() {
            currentPosition = index;
          });
        }
    );
    return new Scaffold(

      body: pageData[currentPosition],
      bottomNavigationBar: botNavBar,
    );
  }

  @override
  void initState() {
    super.initState();
    pageData = new List();
    pageData..add(HomePage())..add(KnowledgePage())..add(ProjectPage())..add(
        PersonalPage());
  }
}

void main() {
  runApp(new MaterialApp(
    home: NavigationPage(),
  ));
}
