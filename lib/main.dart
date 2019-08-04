import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:pr0gramm_app/converter.dart';
import 'package:pr0gramm_app/pr0_text.dart';
import 'package:pr0gramm_app/pr0gramm_content.dart';

import 'pr0gramm_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: BodyWidget(),
    );
  }
}

class BodyWidget extends StatefulWidget {
  @override
  BodyWidgetState createState() {
    return new BodyWidgetState();
  }
}

class BodyWidgetState extends State<BodyWidget> {
  List<Pr0grammContent> pr0grammContentList;

  @override
  void initState() {
    // TODO: implement initState
    pr0grammContentList = List<Pr0grammContent>();
    makeGetRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        middle: Pr0Text(text: "Pr0gramm"),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.refresh),
          onPressed: () {
            makeGetRequest();
          },
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 100),
                        itemCount: pr0grammContentList.length,
                        itemBuilder: (content, index) {
                          return pr0grammContentList[index];
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  makeGetRequest() async {
    Response response = await get("https://pr0gramm.com/api/items/get");
    var pr0grammContentListRequest = await Converter.getPr0grammContentList();
    setState(() {
      pr0grammContentList = pr0grammContentListRequest;
    });
  }

  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000';
    else // for iOS simulator
      return 'http://localhost:3000';
  }
}
