import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0_comment.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class CommentPage extends StatefulWidget {
  final Pr0grammContent pr0grammContent;

  CommentPage({@required this.pr0grammContent});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  _emptyList() {
    return Text(
      "Noch keine Kommentare vorhanden.",
      style: TextStyle(color: iRGENDWASDOOFESISTPASSIERTFarbe),
    );
  }

  // TODO: sort comments for date
  List<ParCom> sortComments(List<Pr0Comment> commentList, id) {
    List<ParCom> parComList = [];
    List<Pr0Comment> children =
        commentList.where((element) => element.parent == id).toList();
    children
        .sort((Pr0Comment a, Pr0Comment b) => b.created.compareTo(a.created));

    for (var i = 0; i < children.length; i++) {
      parComList.add(ParCom(
        comment: children[i],
        commentList: sortComments(commentList, children[i].id),
      ));
    }
    return parComList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ResponseParser.getCommentsOverContent(widget.pr0grammContent),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0Comment> commentList = snapshot.data;
          if (commentList.isEmpty) {
            return _emptyList();
          }
          List<ParCom> l = sortComments(commentList, 0);
          return Column(children: l);
        }
        return Container();
      },
    );
  }
}

class ParCom extends StatelessWidget {
  final Pr0Comment comment;
  final List<ParCom> commentList;

  ParCom({this.comment, this.commentList});

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    String com = comment.toString();
    String li = commentList.isEmpty ? "" : commentList.toString();
    return com + "\n-" + li;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: standardSchriftfarbeAusgegraut),
                ),
              ),
              child: comment),
          Container(height: commentList.isEmpty ? 0 : 20),
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: standardSchriftfarbeAusgegraut),
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(children: commentList),
          ),
        ],
      ),
    );
  }
}
