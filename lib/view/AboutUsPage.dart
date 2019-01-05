import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AboutUsPageState();
  }
}

class AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("关于我"),
        ),
        body: new Container(
          width: 500,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 60.0)),
              Image.asset("images/code.jpg", width: 200.0, height: 200.0,),
              Padding(
                padding: EdgeInsets.only(top: 10.0,left: 30.0,right: 30.0),
                child: Text("上面是我的公众号，花了几天写了练手的flutter版玩Android  ",
                  style: TextStyle(fontSize: 16.0),),),
            ],
          ),
        )
    );
  }
}