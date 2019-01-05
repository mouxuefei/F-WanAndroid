import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class DetailsWidget extends StatefulWidget {
  final String url;
  final String title;

  DetailsWidget(this.url, this.title);

  @override
  State<StatefulWidget> createState() {
    return new DetailsState(this.url, this.title);
  }
}

class DetailsState extends State<DetailsWidget> {
  final String url;
  final String titleName;
  bool isLoad = true;
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  DetailsState(this.url, this.titleName);

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: url,
      appBar: new AppBar(
        title: new Text(titleName),
      ),
      withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        // 加载完成
        setState(() {
          isLoad = false;
        });
      } else if (state.type == WebViewState.startLoad) {
        setState(() {
          isLoad = true;
        });
      }
    });
  }
}