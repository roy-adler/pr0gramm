import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/preferences.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/is_loggedIn.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/pages/main_page.dart';
import 'package:pr0gramm_app/widgets/loadingIndicator.dart';

import 'pages/login_page.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: LoadStart(),
    );
  }
}

class LoadStart extends StatelessWidget {
  _loadLastLogin() async {
    String cookies = await Preferences.cookies();
    if (cookies != null) {
      await ResponseParser.setCookie(cookies);
      IsLoggedIn isLoggedIn = await ResponseParser.isLoggedIn();
      if (isLoggedIn.loggedIn) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      child: FutureBuilder(
        future: _loadLastLogin(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return MainPage();
            } else {
              return LoginPage();
            }
          }
          return LoadingIndicator();
        },
      ),
    );
  }
}