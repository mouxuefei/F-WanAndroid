import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mou/http/Http.dart';
import 'package:mou/http/api/Api.dart';
import 'package:mou/utils/CommonUtil.dart';
import 'package:mou/utils/NavigatorUtils.dart';
import 'package:mou/utils/Toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mou/item/ProjectTreeItem.dart';
import 'package:mou/item/ProjectListItem.dart' as list;

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => new _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  List<Data> data = [];

  @override
  void initState() {
    super.initState();
    _getTabList();
  }

  void _getTabList() async {
    var url = Api.PROJECT_TREE;
    var response = await HttpUtil().get(url);
    var item = ProjectTreeItem.fromJson(response);
    setState(() {
      data = item.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length == 0 ? SpinKitCircle(
      itemBuilder: (_, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey,
          ),
        );
      },
    ) : new DefaultTabController(
        length: data.length,
        child: new Scaffold(
          appBar: AppBar(
              title: Text("项目"),
              centerTitle: true,
              bottom: TabBar(
                  isScrollable: true, //可以滑动
                  tabs: data.map((item) {
                    return new Tab(
                      text: item.name,
                    );
                  }).toList()
              )
          ),
          body: new TabBarView(children: data.map((item) {
            return ProjectListContent(item.id);
          }).toList()),
        )
    );
  }
}

class ProjectListContent extends StatefulWidget {

  final int cid;

  ProjectListContent(this.cid, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProjectListState(cid);
  }
}

class ProjectListState extends State<ProjectListContent> {
  var pageSize = 15;
  var page = 0;

  //是否有更多数据
  bool isHasNoMore = false;
  List<list.Datas> data = [];
  final int cid;

  //这个key用来在不是手动下拉，而是点击某个button或其它操作时，代码直接触发下拉刷新
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();
  final ScrollController _scrollController = new ScrollController(
      keepScrollOffset: false);

  ProjectListState(this.cid);

  @override
  void initState() {
    super.initState();
    getProjectList(false);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page++;
        getProjectList(true);
      }
    });
  }

  void getProjectList(bool isLoadMore) async {
    var url = Api.PROJECT_LIST + "$page/json";
    var response = await HttpUtil().get(url, data: {"cid": cid});
    var item = list.ProjectListItem.fromJson(response);
    if (item.data.datas.length < pageSize) {
      isHasNoMore = true;
    } else {
      isHasNoMore = false;
    }
    if (isLoadMore) {
      data.addAll(item.data.datas);
      setState(() {});
    } else {
      setState(() {
        data = item.data.datas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.length == 0 ? SpinKitCircle(
      itemBuilder: (_, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey,
          ),
        );
      },
    ) : new ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      key: _refreshIndicatorKey,
      itemCount: data.length + 1,
      controller: _scrollController,
      itemBuilder: (context, index) {
        return getItem(index);
      },
    );
  }

  Widget getItem(int i) {
    if (i == data.length) {
      if (isHasNoMore) {
        return _buildNoMoreData();
      } else {
        return _buildLoadMoreLoading();
      }
    } else {
      var item = data[i];
      var date = DateTime.fromMillisecondsSinceEpoch(
          item.publishTime, isUtc: true);
      return _buildCardItem(item, date, i);
    }
  }

  Widget _buildCardItem(list.Datas item, DateTime date, int index) {
    return new GestureDetector(
      onTap: () {
        NavigatorUtils.gotoDetail(context, item.link, item.title);
      },
      child: new Card(
          child: new Padding(padding: EdgeInsets.all(10.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(item.envelopePic, fit: BoxFit.cover,
                  width: 80.0,
                  height: 120.0,
                ),
                new Container(
                  height: 120.0,
                  margin: EdgeInsets.only(left: 8.0),
                  width: CommonUtil.getScreenWidth(context) - 120.0,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(item.title, style: new TextStyle(
                          fontSize: 16.0, color: Colors.black87),maxLines: 2,),
                      new Text(item.desc, style: new TextStyle(
                          fontSize: 14.0, color: Colors.grey), maxLines: 3,),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(item.author, style: new TextStyle(
                              fontSize: 12.0, color: Colors.grey),),
                          new Text(
                            "${date.year}年${date.month}月${date.day}日 ${date
                                .hour}:${date.minute}", style: new TextStyle(
                              fontSize: 11.0, color: Colors.grey),),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget _buildLoadMoreLoading() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitFadingCircle(
              color: Colors.grey,
              size: 30.0,
            ),
            new Padding(padding: EdgeInsets.only(left: 10)),
            new Text("正在加载更多...")
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreData() {
    return new Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
      alignment: Alignment.center,
      child: new Text("没有更多数据了"),
    );
  }
}


