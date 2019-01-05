import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mou/view/AboutUsPage.dart';
import 'package:mou/view/KnowledgeListPage.dart';
import 'package:mou/view/common/Details.dart';
import 'package:mou/view/SearchPage.dart';
import 'package:mou/view/SearchListPage.dart';
import 'package:mou/item/KnowledgeTreeItem.dart' as n;

class NavigatorUtils {
  ///替换
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  ///切换无参数页面
  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  ///去详情
  static gotoDetail(BuildContext context, String url, String title) {
    return Navigator.push(context,
        new CupertinoPageRoute(builder: (context) =>
        new DetailsWidget(url, title)));
  }

  ///去搜索界面
  static gotoSearch(BuildContext context) {
    return Navigator.push(context,
        new CupertinoPageRoute(builder: (context) =>
        new SearchPage()));
  }

  ///去搜索列表
  static gotoSearchList(BuildContext context, String content) {
    return Navigator.push(context,
        new CupertinoPageRoute(builder: (context) =>
        new SearchListPage(content)));
  }

  ///去知识详情界面
  static gotoKnowledgeList(BuildContext context, String name, n.Data data) {
    return Navigator.push(context,
        new CupertinoPageRoute(builder: (context) =>
        new KnowledgeListPage(name: name, data: data,)));
  }

  ///关于我界面
  static gotoAboutUs(BuildContext context) {
    return Navigator.push(context,
        new CupertinoPageRoute(builder: (context) =>
        new AboutUsPage()));
  }
}
