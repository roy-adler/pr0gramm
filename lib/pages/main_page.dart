import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_login.dart';
import 'package:pr0gramm/content/pr0gramm_logout.dart';
import 'package:pr0gramm/pages/item_page.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/login_page.dart';
import 'package:pr0gramm/widgets/loadingIndicator.dart';

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
      "Ups, da ist wohl etwas schief gelaufen!\n"
      "Zum neu laden clicken";
  int promoted = 1;
  int sFW = 9;
  int nSFW = 2;
  int nSFL = 4;
  double navFontSize = 12;
  int itemPos = 0;
  bool sFWbool = true;
  bool nSFWbool = false;
  bool isFullscreen = false;

  @override
  void initState() {
    promoted = 1;
    super.initState();
  }

  _buildTagButton(String s, int i, int promoted) {
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

  void toggleFullscreen() {
    setState(() {
      isFullscreen = !isFullscreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 4,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () async {
              Pr0grammLogout pr0grammLogout = await ResponseParser.logout();
              if (pr0grammLogout.success == true) {
                ResponseParser.setCookie("");
                return Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              }
            },
          ),
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
                                controller:
                                    PageController(initialPage: itemPos),
                                scrollDirection: Axis.horizontal,
                                itemCount: contentList.length,
                                itemBuilder: (context, index) {
                                  List<ItemPage> itemPageList =
                                      _getItemPageList(
                                    contentList,
                                    toggleFullscreen,
                                  );
                                  return itemPageList[index];
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
                                          itemPos = index;
                                          toggleFullscreen();
                                        });
                                      },
                                      child: snapshot.data[index],
                                    ),
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
}
