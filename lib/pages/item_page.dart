import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/comment_page.dart';
import 'package:pr0gramm/pages/tag_page.dart';
import 'package:pr0gramm/pages/votes_page.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

class ItemPage extends StatefulWidget {
  final Pr0grammContent pr0grammContent;
  final Function toggleFullscreen;

  ItemPage({@required this.pr0grammContent, this.toggleFullscreen});

  @override
  ItemPageState createState() {
    return new ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  Pr0grammContent pr0grammContent;

  @override
  void initState() {
    // TODO: implement initState
    // TODO: Janky code with the gift
    pr0grammContent = widget.pr0grammContent.copy(gift: "");
    super.initState();
  }

  // TODO Check this shit out?!
  Widget pr0Text(String s, {double size = 32}) {
    return Text(
      s,
      style: TextStyle(color: standardSchriftfarbe, fontSize: size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: richtigesGrau,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: ResponseParser.getPr0grammInfo(pr0grammContent.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoadingIndicator();
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Hero(
                          tag: pr0grammContent.id,
                          child: pr0grammContent.bigPicture()),
                      VotesPage(pr0grammContent: pr0grammContent),
                      TagPage(pr0grammContent: pr0grammContent),
                      CommentPage(pr0grammContentID: pr0grammContent.id),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Container(
            decoration: BoxDecoration(
              color: richtigesGrau.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
