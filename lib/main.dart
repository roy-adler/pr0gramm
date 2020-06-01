import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/animations/cube_page_route.dart';
import 'package:pr0gramm/widgets/Content/content_page_view.dart';
import 'package:pr0gramm/api/preferences.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/is_loggedIn.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/main_page.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

import 'pages/login_page.dart';

// mainSave

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        home: LoadStart(),
      ),
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
    return Scaffold(
      backgroundColor: richtigesGrau,
      body: FutureBuilder(
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
