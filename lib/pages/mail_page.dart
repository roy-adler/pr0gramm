import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/api/converter.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';


class Mail extends StatefulWidget {
  @override
  MailState createState() {
    return new MailState();
  }
}

class MailState extends State<Mail> {
  List<Pr0grammContent> pr0grammContentList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      navigationBar: CupertinoNavigationBar(
          backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
          middle: Pr0Text("Nachrichten"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(color: standardSchriftfarbe, child: Text("hello")),
      ),
    );
  }

  makeGetRequest() async {
    List<Pr0grammContent> pr0grammContentListRequest =
    await Converter.getPr0grammContentList();
    setState(() {
      pr0grammContentList = pr0grammContentListRequest;
    });
  }
}
