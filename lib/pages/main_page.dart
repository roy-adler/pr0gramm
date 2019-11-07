import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/pages/item_page.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/widgets/loadingIndicator.dart';

class MainPage extends StatefulWidget {
  final Pr0grammLogin pr0grammLogin;

  MainPage({this.pr0grammLogin});

  @override
  MainPageState createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  String sFail =
      "Ups, da ist wohl etwas schief gelaufen!\nZum neu laden clicken";
  int promoted;
  int sFW = 9;
  int nSFW = 2;
  int nSFL = 4;
  double navFontSize = 12;

  bool sFWbool = true;
  bool nSFWbool = false;
  bool isFullscreen = false;

  @override
  void initState() {
    promoted = 1;
    super.initState();
  }

  _buildTagButton(String s, int i) {
    return FlatButton(
      highlightColor: pr0grammOrange,
      onPressed: () {
        promoted = i;
        setState(() => null);
      },
      child: Text(
        s,
        style: TextStyle(
          color: (promoted == i) ? pr0grammOrange : standardSchriftfarbe,
          fontSize: navFontSize,
        ),
      ),
    );
  }

  _buildNavigatorButton(IconData iconData, Widget page) {
    return CupertinoButton(
      padding: EdgeInsets.all(0),
      child: Icon(
        iconData,
        color: standardSchriftfarbe,
      ),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _sFW() {
    return FlatButton(
      highlightColor: pr0grammOrange,
      onPressed: () {
        sFWbool = !sFWbool;
        setState(() => null);
      },
      child: Text(
        "SFW",
        style: TextStyle(
            color: (sFWbool) ? pr0grammOrange : standardSchriftfarbe,
            fontSize: navFontSize),
      ),
    );
  }

  Widget _nSFW() {
    return FlatButton(
      highlightColor: pr0grammOrange,
      onPressed: () {
        nSFWbool = !nSFWbool;
        setState(() => null);
      },
      child: Text(
        "NSFW",
        style: TextStyle(
            color: (nSFWbool) ? pr0grammOrange : standardSchriftfarbe,
            fontSize: navFontSize),
      ),
    );
  }

  int _createFlags() {
    int flags = 0;
    if (sFWbool) {
      flags += sFW;
    }
    if (nSFWbool) {
      flags += nSFW;
    }
    return flags;
  }

  List<ItemPage> _getItemPageList(
    List<Pr0grammContent> list,
    Function toggleFullscreen,
  ) {
    List<ItemPage> itemPageList = [];
    list.forEach(
      (Pr0grammContent element) => itemPageList.add(
        ItemPage(
          pr0grammContent: element,
          toggleFullscreen: toggleFullscreen,
        ),
      ),
    );
    return itemPageList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        actions: <Widget>[
          Flexible(child: _buildTagButton("neu", 0)),
          Flexible(child: _buildTagButton("beliebt", 1)),
          Flexible(child: _sFW()),
          Flexible(child: _nSFW()),
        ],
      ),
      backgroundColor: richtigesGrau,
      body: FutureBuilder(
        future: ResponseParser.getPr0grammContentList(promoted, _createFlags()),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Pr0grammContent> contentList = snapshot.data;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  // width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: isFullscreen
                            ? PageView.builder(
                                itemCount: contentList.length,
                                itemBuilder: (context, index) {
                                  return _getItemPageList(
                                      contentList, toggleFullscreen)[index];
                                },
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 150),
                                itemCount: contentList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isFullscreen = !isFullscreen;
                                          });
                                        },
                                        child: snapshot.data[index]),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return LoadingIndicator();
        },
      ),
    );
  }

  void toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
  }

  _retryButton() {
    return Center(
      child: CupertinoButton(
        padding: EdgeInsets.all(32),
        color: pr0grammOrange,
        child: Text(
          sFail,
          style: TextStyle(color: standardSchriftfarbe),
        ),
        onPressed: () => setState(() => null),
      ),
    );
  }
}
