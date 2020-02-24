import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/is_loggedIn.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class AccountPage extends StatefulWidget {
  @override
  AccountPageState createState() {
    return new AccountPageState();
  }
}

class AccountPageState extends State<AccountPage> {
  Widget pr0grammLogin;

  @override
  void initState() {
    super.initState();
    pr0grammLogin = CircularProgressIndicator(
      backgroundColor: standardSchriftfarbe,
    );
    makeGetRequest();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        middle: Pr0Text("Account"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: pr0grammLogin,
      ),
    );
  }

  makeGetRequest() async {
    IsLoggedIn isLoggedIn = await ResponseParser.isLoggedIn();
    setState(() {
      pr0grammLogin = isLoggedIn;
    });
  }
}
