import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mou/http/Http.dart';
import 'package:mou/http/api/Api.dart';
import 'package:mou/item/KnowledgeTreeItem.dart' as tree;
import 'package:mou/item/KnowledgeListItem.dart' as list;
import 'package:mou/utils/NavigatorUtils.dart';

class KnowledgeListPage extends StatefulWidget {
  final tree.Data data;
  final String name;

  const KnowledgeListPage({Key key, this.data, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return KnowledgeListState(data, name);
  }
}

class KnowledgeListState extends State<KnowledgeListPage> {
  final tree.Data data;
  final String name;

  KnowledgeListState(this.data, this.name);

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: data.children.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(name),
            bottom: new TabBar(
              isScrollable: true,
              tabs: data.children.map((tree.Children child) {
                return new Tab(
                  text: child.name,
                );
              }).toList(),
            ),
          ),
          body: new TabBarView(
            children: data.children.map((tree.Children child) {
              return ListPage(cid: child.id,);
            }).toList(),
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class ListPage extends StatefulWidget {
  final int cid;

  const ListPage({Key key, this.cid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListPageState(cid);
  }
}

class ListPageState extends State<ListPage> {
  bool isLoading = true;
  final int cid;
  List<list.Datas> data = [];

  ListPageState(this.cid);

  @override
  Widget build(BuildContext context) {
    return isLoading ? SpinKitCircle(
      itemBuilder: (_, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey,
          ),
        );
      },
    ) : data.length > 0 ? new ListView(
      children: data.map((item) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            item.publishTime, isUtc: true);
        return new GestureDetector(
          onTap: () {
            NavigatorUtils.gotoDetail(context, item.link, item.title);
          },
          child: new Card(
            child: Container(
              margin: EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(item.author, style: new TextStyle(
                          fontSize: 18.0, color: Colors.black87),),
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
                  new Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(item.title, style: new TextStyle(
                        color: Colors.black, fontSize: 18.0),),
                  ),
                  new Text("${item.author}/${item.chapterName}",
                    style: new TextStyle(fontSize: 14.0, color: Colors.grey),)
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ) : new Center(
      child: new Text(
        "没有更多数据哦", style: new TextStyle(fontSize: 20, color: Colors.grey),),
    );
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    getPageData();
  }

  void getPageData() async {
    var url = Api.KNOWLEDGE_LIST;
    var response = await HttpUtil().get(url, data: {"cid": cid});
    var item = new list.KnowledgeListItem.fromJson(response);
    setState(() {
      isLoading = false;
      data = item.data.datas;
    });
  }
}
