import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/widgets/media_widget.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/comment_page.dart';
import 'package:pr0gramm/pages/tag_page.dart';
import 'package:pr0gramm/pages/votes_page.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

class ItemPage extends StatefulWidget {
  final Pr0grammContent pr0grammContent;

  ItemPage({@required this.pr0grammContent, Key key}) : super(key: key);

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

  Widget backButton() {
    return IconButton(
      onPressed: () => Navigator.maybePop(context),
      icon: Container(
        decoration: BoxDecoration(
          color: richtigesGrau.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.arrow_downward, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: richtigesGrau,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
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
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: MediaWidget(pr0grammContent: pr0grammContent),
                      ),
                      VotesPage(pr0grammContent: pr0grammContent),
                      TagPage(pr0grammContent: pr0grammContent),
                      CommentPage(pr0grammContentID: pr0grammContent.id),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: backButton(),
            ),
          ],
        ),
      ),
    );
  }
}
