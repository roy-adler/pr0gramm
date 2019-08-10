import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/pages/account_page.dart';
import 'package:pr0gramm_app/pages/mail_page.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  List<Pr0grammContent> pr0grammContentList;

  @override
  void initState() {
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
        middle: Pr0Text("Pr0gramm"),
        trailing: Row(
          children: <Widget>[
            CupertinoButton(
              child: Icon(
                Icons.supervisor_account,
                color: standardSchriftfarbe,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
            CupertinoButton(
              child: Icon(
                CupertinoIcons.mail,
                color: standardSchriftfarbe,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => MailPage()),
                );
              },
            ),
          ],
        ),
      ),
      child: Padding(
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
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 150),
                        itemCount: pr0grammContentList.length,
                        itemBuilder: (content, index) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: pr0grammContentList[index],
                          );
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  makeGetRequest() async {
    List<Pr0grammContent> pr0grammContentListRequest =
        await ResponseParser.getPr0grammContentList();
    setState(() {
      pr0grammContentList = pr0grammContentListRequest;
    });
  }
}
