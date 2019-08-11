import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/pr0gramm_comment.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_info.dart';
import 'package:pr0gramm_app/content/pr0gramm_tag.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class ItemPage extends StatefulWidget {
  Pr0grammContent pr0grammContent;

  ItemPage({@required this.pr0grammContent});

  @override
  ItemPageState createState() {
    return new ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  List<Pr0grammTag> pr0grammTagList = List<Pr0grammTag>();
  List<Pr0grammComment> pr0grammCommentList = List<Pr0grammComment>();
  Pr0grammContent pr0grammContent;

  @override
  void initState() {
    // TODO: implement initState
    pr0grammContent = widget.pr0grammContent;
    makeGetRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        middle: Pr0Text("Content"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: <Widget>[
          Center(child: pr0grammContent),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: pr0grammTagList),
          ),
          Column(children: pr0grammCommentList),
        ]),
      ),
    );
  }

  makeGetRequest() async {
    Pr0grammInfo PI = await ResponseParser.getPr0grammInfo(pr0grammContent.id);
    List<Pr0grammComment> pr0grammCommentListRequest =
        await ResponseParser.getComments(PI);
    List<Pr0grammTag> pr0grammTagListRequest = await ResponseParser.getTags(PI);
    setState(() {
      pr0grammCommentList = pr0grammCommentListRequest;
      pr0grammTagList = pr0grammTagListRequest;
    });
  }
}
