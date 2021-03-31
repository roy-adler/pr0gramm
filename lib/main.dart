import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/pages/main_page.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';
import 'api/preferences.dart';
import 'api/response_parser.dart';
import 'content/is_loggedIn.dart';
import 'design/pr0gramm_colors.dart';
import 'pages/login_page.dart';

// Version 1.3.2

void main() => runApp(MainApp());

void initApp() {
  Preferences.saveMuted(true);
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    initApp();

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
