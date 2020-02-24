import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class MailPage extends StatefulWidget {
  @override
  MailPageState createState() {
    return new MailPageState();
  }
}

class MailPageState extends State<MailPage> {
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
    setState(() {});
  }
}
