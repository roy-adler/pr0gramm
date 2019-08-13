import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/pages/account_page.dart';
import 'package:pr0gramm_app/pages/item_page.dart';
import 'package:pr0gramm_app/pages/login_page.dart';
import 'package:pr0gramm_app/pages/mail_page.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: LoginPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  Pr0grammLogin pr0grammLogin;

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
  int SFW = 9;
  int NSFW = 2;
  int NSFL = 4;
  double navFontSize = 12;

  bool SFWbool = true;
  bool NSFWbool = false;

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

  Widget _SFW() {
    return FlatButton(
      highlightColor: pr0grammOrange,
      onPressed: () {
        SFWbool = !SFWbool;
        setState(() => null);
      },
      child: Text(
        "SFW",
        style: TextStyle(
            color: (SFWbool) ? pr0grammOrange : standardSchriftfarbe,
            fontSize: navFontSize),
      ),
    );
  }

  Widget _NSFW() {
    return FlatButton(
      highlightColor: pr0grammOrange,
      onPressed: () {
        NSFWbool = !NSFWbool;
        setState(() => null);
      },
      child: Text(
        "NSFW",
        style: TextStyle(
            color: (NSFWbool) ? pr0grammOrange : standardSchriftfarbe,
            fontSize: navFontSize),
      ),
    );
  }

  int _createFlags() {
    int flags = 0;
    if (SFWbool) {
      flags += SFW;
    }
    if (NSFWbool) {
      flags += NSFW;
    }
    return flags;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        leading: Container(
          width: 0,
        ),
        middle: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(child: _buildTagButton("neu", 0)),
            Flexible(child: _buildTagButton("beliebt", 1)),
            Flexible(child: _SFW()),
            Flexible(child: _NSFW()),
            // Flexible(
            //    child:
            //        _buildNavigatorButton(Icons.account_circle, AccountPage())),
            // Flexible(child: _buildNavigatorButton(Icons.mail, MailPage())),
          ],
        ),
      ),
      child: FutureBuilder(
        future: ResponseParser.getPr0grammContentList(promoted, _createFlags()),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Padding(
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
                              itemCount: snapshot.data.length,
                              itemBuilder: (content, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GestureDetector(
                                      onTap: () => Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) => ItemPage(
                                                  pr0grammContent:
                                                      snapshot.data[index]),
                                            ),
                                          ),
                                      child: snapshot.data[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
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
        },
      ),
    );
  }
}
