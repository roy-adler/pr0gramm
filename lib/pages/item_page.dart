import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/comment_page.dart';
import 'package:pr0gramm/pages/tag_page.dart';

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

  Widget _buildVotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.add_circled, color: standardSchriftfarbe),
                  Container(
                    width: 4,
                  ),
                  Icon(CupertinoIcons.minus_circled,
                      color: standardSchriftfarbe),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: pr0Text(
                    (pr0grammContent.up - pr0grammContent.down).toString()),
              ),
              Icon(CupertinoIcons.heart_solid, color: standardSchriftfarbe),
            ],
          ),
          Container(
            child: pr0Text("OCname"),
          )
        ],
      ),
    );
  }

  Widget pr0Text(String s, {double size = 32}) {
    return Text(s,
        style: TextStyle(color: standardSchriftfarbe, fontSize: size));
  }

  // TODO
  Widget fullscreenCloseButton() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: FlatButton(
        color: Colors.white,
        onPressed: widget.toggleFullscreen,
        child: Icon(Icons.fullscreen_exit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: richtigesGrau,
      body: FutureBuilder(
        future: ResponseParser.getPr0grammInfo(pr0grammContent.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingIndicator();
          }

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                pr0grammContent.bigPicture(),
                pr0grammContent.buildVotes(),
                TagPage(pr0grammContentID: pr0grammContent.id),
                CommentPage(pr0grammContentID: pr0grammContent.id),
              ],
            ),
          );
        },
      ),
    );
  }
}
