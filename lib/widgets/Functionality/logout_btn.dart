import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_logout.dart';
import 'package:pr0gramm/pages/login_page.dart';

class LogoutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Icon(
        Icons.exit_to_app,
        color: Colors.white,
      ),
      onPressed: () async {
        Pr0grammLogout pr0grammLogout = await ResponseParser.logout();
        if (pr0grammLogout.success == true) {
          ResponseParser.setCookie("");
          return Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
    );
  }
}
