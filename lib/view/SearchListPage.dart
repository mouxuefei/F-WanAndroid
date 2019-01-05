import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mou/http/Http.dart';
import 'package:mou/http/api/Api.dart';
import 'package:mou/item/SearchListItem.dart';
import 'package:mou/utils/CommonUtil.dart';
import 'package:mou/utils/NavigatorUtils.dart';

class SearchListPage extends StatefulWidget {
  final String searchContent;

  SearchListPage(this.searchContent);

  @override
  State<StatefulWidget> createState() {
    return SearchListState(searchContent);
  }
}

class SearchListState extends State<SearchListPage> {
  int currentPage = 0;
  String searchContent;
  List<Datas> datas = [];
  bool isLoading = true;

  SearchListState(this.searchContent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(searchContent),
      ),

      body: isLoading ?
      new Container(
        child: SpinKitCircle(
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.grey,
              ),
            );
          },
        ),
      ) : new Container(
          child: datas.length > 0 ?
          new ListView(
            children: datas.map((data) {
              var date = DateTime.fromMillisecondsSinceEpoch(
                  data.publishTime, isUtc: true);
              return buildCardItem(data, date, datas.indexOf(data));
            }).toList(),
          ) : new Center(
            child: new Text("没有更多数据哦",style: new TextStyle(fontSize: 20,color: Colors.grey),),
          )
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchData();
  }


  Card buildCardItem(Datas item, DateTime date, int index) {
    return new Card(
        child: new InkWell(
          onTap: () {
            var url = item.link;
            var title = item.title;
            NavigatorUtils.gotoDetail(context, url, title);
          },
          child: new Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10.0),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(3.0),
                          border: new Border.all(
                              color: Colors.blue
                          )
                      ),
                      child: new Text(item.superChapterName,
                        style: new TextStyle(
                            color: Colors.blue
                        ),
                      ),
                    ),

                    new Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: new Text(item.author),

                    ),

                    new Expanded(child: new Container()),

                    new Text(
                      "${date.year}年${date.month}月${date.day}日 ${date
                          .hour}:${date.minute}",
                      style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      height: 80.0,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            width: CommonUtil.getScreenWidth(context) - 100,
                            child: new Text(item.title,
                              softWrap: true, //换行
                              maxLines: 2,
                              style: new TextStyle(fontSize: 16.0),
                            ),
                            margin: EdgeInsets.only(top: 10.0),
                          ),
                          new Container(
                            child: new Text(
                              item.superChapterName + "/" + item.author,
                              style: new TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),

                    item.envelopePic.isEmpty ? new Container(
                      width: 60.0,
                      height: 60.0,)
                        : new Image.network(
                      item.envelopePic,
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  void _searchData() async {
    String url = Api.SEARCH_WORD + "$currentPage/json";
    FormData formData = new FormData.from({
      'k': searchContent
    });
    var response = await HttpUtil().post(url, data: formData);
    var item = new SearchListItem.fromJson(response);
    setState(() {
      isLoading = false;
      datas = item.data.datas;
    });
  }

}