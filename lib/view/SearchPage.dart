import 'package:flutter/material.dart';
import 'package:mou/http/Http.dart';
import 'package:mou/http/api/Api.dart';
import 'package:mou/item/HotWordItem.dart';
import 'package:mou/utils/NavigatorUtils.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<SearchPage> {
  TextEditingController _searchController = new TextEditingController();
  List<Data> hotWordData = [];
  var _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextField searchField = new TextField(
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
          color: Colors.white
      ),
      decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: '发现更多干货',
          hintStyle: new TextStyle(
              color: Colors.white70
          )
      ),
      controller: _searchController,
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: searchField,
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                //搜索
                var content = _searchController.text;
                if (content.isEmpty) {
                  final snackBar = new SnackBar(content: new Text('请输入搜索内容!'),
                    backgroundColor: Colors.green,);
                  _scaffoldkey.currentState.showSnackBar(snackBar);
                } else {
                  NavigatorUtils.gotoSearchList(context, content);
                }
              }),
          new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });
              }),
        ],
      ),

      body: new ListView(
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.all(10.0),
              child: new Text('热搜',
                  style: new TextStyle(
                      color: Theme
                          .of(context)
                          .accentColor, fontSize: 20.0))),
          new Wrap(
              spacing: 5.0,
              runSpacing: 10.0,
              children: hotWordData.map((data) {
                return
                  new GestureDetector(
                    onTap: () {
                      NavigatorUtils.gotoSearchList(context, data.name);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Text(data.name,
                        style: new TextStyle(
                            color: Colors.white
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                          color: Colors.blue
                      ),
                    ),
                  );
              }).toList()),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.text="";
    getHotWord();
  }

  void getHotWord() async {
    var response = await HttpUtil().get(Api.HOT_WORD);
    var item = new HotWordItem.fromJson(response);
    setState(() {
      hotWordData = item.data;
    });
  }

}


