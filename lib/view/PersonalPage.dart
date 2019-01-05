import 'package:flutter/material.dart';
import 'package:mou/utils/NavigatorUtils.dart';

class PersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PersonalState();
  }
}

class PersonalState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("个人中心"),
        centerTitle: true,
      ),
      body: new ListView(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        children: <Widget>[
          new Stack(
            children: <Widget>[
              Image.network(
                "http://pic170.nipic.com/file/20180629/24903911_111202018080_2.jpg",
                width: 500, height: 150.0, fit: BoxFit.cover,),
              Container(
                width: 60.0,
                height: 60.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  image: DecorationImage(image: NetworkImage(
                      "http://pic20.photophoto.cn/20110902/0020033018777780_b.jpg"),
                      fit: BoxFit.cover),
                ),
              )
            ],
            alignment: AlignmentDirectional.center,
          ),
          new ListTile(
              leading: const Icon(Icons.info),
              title: const Text('关于我'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                NavigatorUtils.gotoAboutUs(context);
              }),
          Container(
            height: 1.0,
            decoration: BoxDecoration(
                color: Colors.black12
            ),
          )
        ],
      ),
    );
  }
}