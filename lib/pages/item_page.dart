import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/comment_page.dart';
import 'package:pr0gramm/pages/tag_page.dart';
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

  // TODO
  Widget fullscreenCloseButton(BuildContext context) {
    return FlatButton(
      onPressed: () => Navigator.pop(context),
      child: Icon(
        Icons.close,
        size: 32,
        color: pr0grammOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: richtigesGrau,
      body: Stack(
        children: <Widget>[
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
                    pr0grammContent.bigPicture(),
                    pr0grammContent.buildVotes(),
                    TagPage(pr0grammContentID: pr0grammContent.id),
                    CommentPage(pr0grammContentID: pr0grammContent.id),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: AlignmentDirectional.topEnd,
                child: fullscreenCloseButton(context)),
          ),
        ],
      ),
    );
  }
}
