import 'package:flutter/material.dart';
import 'package:mou/utils/Toast.dart';

class HomeGridItem extends StatelessWidget {
  HomeGridItem({this.title,
    this.position,
    this.content,
    this.time,
    this.coverUrl,
    this.callBack,})
      : super(key: new ObjectKey(position)); //ObjectKey唯一的标识位
  String title;
  int position;
  String content;
  String coverUrl;
  String time;
  CallBack callBack;

  @override
  Widget build(BuildContext context) {
    print('bookId:$position');
    Widget titleSection = new Container(
        padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 8.0),
        child:
        new Card(
          elevation: 5.0,
          child:new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  width: double.infinity,
                  height: 100.0,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                  child: new Image.network(coverUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                new Text(
                  title,
                  style: new TextStyle(
                      fontSize: 18,
                      color: Color(0xFF333333)
                  ),
                ),
              ],
            ),
          )
        )
    );
    return new GestureDetector(
      child: titleSection,
      onTap: () {
        callBack(position, this);
      },
    );
  }
}

typedef void CallBack(int position,
    HomeGridItem item,);
