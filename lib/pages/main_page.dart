import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/animations/Reachable/ReachableField.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_login.dart';
import 'package:pr0gramm/pages/item_page.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';
import 'package:pull_to_reach/pull_to_reach.dart';

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
  PageController pageController;
  var currentPageValue = 0.0;

  @override
  void initState() {
    promoted = 1;
    PageController pageController = PageController();

    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
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

  Offset offsetStart;
  Offset offsetEnd;

  Widget _buildList() {
    List<Widget> list = [];
    for (int i = 0; i < 20; i++) {
      list.add(Container(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("Element")),
      ));
    }

    return ListView(children: list);
  }

  _showSearchBox() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ItemPage(
                  pr0grammContent: Pr0grammContent.dummy(),
                )));
  }

  Widget _getContentGrid() {
    return FutureBuilder(
      future: ResponseParser.getPr0grammContentList(promoted, _createFlags()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0grammContent> contentList = snapshot.data;

          SliverAppBar sliverAppBar = SliverAppBar(
            backgroundColor: richtigesGrau,
            pinned: false,
            stretch: true,
            expandedHeight: 0,
            centerTitle: true,
            onStretchTrigger: () async => print("Hellosk"),
            title: FlatButton(
              onPressed: _showSearchBox,
              color: pr0grammOrange,
              child: Icon(Icons.search),
            ),
          );

          SliverGrid sliverGrid = SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return contentList[index];
              },
              childCount: contentList.length,
            ),
          );

          return CustomScrollView(
            slivers: <Widget>[
              sliverAppBar,
              sliverGrid,
            ],
          );
        }

        return LoadingIndicator();
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return PageView.builder(
      controller: pageController,
      itemBuilder: (context, position) {
        if (position == currentPageValue.floor()) {
          return Transform(
            transform: Matrix4.identity()..rotateX(currentPageValue - position),
            child: Container(
              color: position % 2 == 0 ? Colors.blue : Colors.pink,
              child: Center(
                child: Text(
                  "Page ${position + 1}",
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
              ),
            ),
          );
        } else if (position == currentPageValue.floor() + 1) {
          return Transform(
            transform: Matrix4.identity()..rotateX(currentPageValue - position),
            child: Container(
              color: position % 2 == 0 ? Colors.blue : Colors.pink,
              child: Center(
                child: Text(
                  "Page ${position + 1}",
                  style: TextStyle(color: Colors.white, fontSize: 22.0),
                ),
              ),
            ),
          );
        } else {
          return Container(
            color: position % 2 == 0 ? Colors.blue : Colors.pink,
            child: Center(
              child: Text(
                "Page ${position + 1}",
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
            ),
          );
        }
      },
      itemCount: 4,
    );
  }
}
