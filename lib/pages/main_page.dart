import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_login.dart';
import 'package:pr0gramm/content/pr0gramm_logout.dart';
import 'package:pr0gramm/pages/fullscreen_page.dart';
import 'package:pr0gramm/pages/item_page.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/login_page.dart';
import 'package:pr0gramm/widgets/loadingIndicator.dart';
import 'package:pr0gramm/widgets/logout_btn.dart';

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

  Widget sfwBtn() {
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

  Widget nsfwBtn() {
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

  List<Hero> _getItemPageList(
    List<Pr0grammContent> list,
    Function toggleFullscreen,
  ) {
    List<Hero> itemPageList = [];
    list.forEach(
      (Pr0grammContent element) => itemPageList.add(
        Hero(
          tag: element.id,
          child: ItemPage(
            pr0grammContent: element,
            toggleFullscreen: toggleFullscreen,
          ),
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
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150),
                          itemCount: contentList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) {
                                        return FullscreenPage(
                                          contentList: contentList,
                                          itemPos: index,
                                        );
                                      },
                                    ),
                                  );
                                },
                                // TODO: Hero Thing? With Fullscreen Page
                                child: Hero(
                                    tag: contentList[index].id,
                                    child: contentList[index]),
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
