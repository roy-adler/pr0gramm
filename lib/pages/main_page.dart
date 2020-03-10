import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_login.dart';
import 'package:pr0gramm/pages/item_page.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/widgets/Content/contents_page.dart';
import 'package:pr0gramm/widgets/Content/content_sliver.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

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

  PageController pageController;
  var currentPageValue = 0.0;

  @override
  void initState() {
    PageController pageController = PageController();

    pageController.addListener(() {
      setState(() {
        currentPageValue = pageController.page;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ContentsPage();
  }
}
