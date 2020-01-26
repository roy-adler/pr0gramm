import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_comment.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_info.dart';
import 'package:pr0gramm/content/pr0gramm_tag.dart';
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
  List<Pr0grammTag> pr0grammTagList = List<Pr0grammTag>();
  List<Pr0grammComment> pr0grammCommentList = List<Pr0grammComment>();
  Pr0grammContent pr0grammContent;
  bool b = false;

  @override
  void initState() {
    // TODO: implement initState
    pr0grammContent = widget.pr0grammContent;
    makeGetRequest();
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
            child: pr0Text(pr0grammContent.image, size: 12),
          )
        ],
      ),
    );
  }

  Widget pr0Text(String s, {double size = 32}) {
    return Text(s,
        style: TextStyle(color: standardSchriftfarbe, fontSize: size));
  }

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
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return wi()[index];
        },
      ),
    );
  }

  List<Widget> wi() {
    return [
      FittedBox(
        fit: BoxFit.fitWidth,
        child: pr0grammContent.bigPicture(),
      ),
      _buildVotes(),
      TagPage(tagList: pr0grammTagList),
      CommentPage(commentList: pr0grammCommentList),
    ];
  }

  makeGetRequest() async {
    Pr0grammInfo pr0grammInfo =
        await ResponseParser.getPr0grammInfo(pr0grammContent.id);
    List<Pr0grammComment> pr0grammCommentListRequest =
        await ResponseParser.getComments(pr0grammInfo);
    List<Pr0grammTag> pr0grammTagListRequest =
        await ResponseParser.getTags(pr0grammInfo);
    setState(() {
      pr0grammCommentList = pr0grammCommentListRequest;
      pr0grammTagList = pr0grammTagListRequest;
      b = true;
    });
  }
}
