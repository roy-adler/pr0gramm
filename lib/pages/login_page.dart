import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/preferences.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/is_loggedIn.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/pages/main_page.dart';
import 'package:pr0gramm_app/api/response_parser.dart';

String sBenutzername = "Benutzername";
String sAnmelden = "Anmelden";
String sPasswort = "Passwort";
String sWrongLogin = "Falscher Benutzername oder Passwort";

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  TextEditingController usernameController;
  TextEditingController passwordController;

  @override
  initState() {
    _loadLastLogin();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    _loadCache();
  }

  _usernameTextField() {
    return CupertinoTextField(
      controller: usernameController,
      placeholder: sBenutzername,
      cursorColor: pr0grammOrange,
      style: TextStyle(color: standardSchriftfarbe),
    );
  }

  _passwordTextField() {
    return CupertinoTextField(
      controller: passwordController,
      placeholder: sPasswort,
      cursorColor: pr0grammOrange,
      style: TextStyle(color: standardSchriftfarbe),
      obscureText: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: richtigesGrau,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: ehemaligeHintergrundFarbeDerKommentare,
        middle: Pr0Text("Login"),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _usernameTextField(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _passwordTextField(),
            ),
            CupertinoButton(
              child: Text(sAnmelden),
              onPressed: () => _submit(),
              color: pr0grammOrange,
            )
          ],
        ),
      ),
    );
  }

  void _submit() async {
    await _setCache();
    Pr0grammLogin PL = await ResponseParser.getPr0grammLogin(
        username: usernameController.text, password: passwordController.text);
    if (PL.success == true) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          maintainState: false,
          builder: (context) => MainPage(
            pr0grammLogin: PL,
          ),
        ),
      );
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => Container(
          color: richtigesGrau.withAlpha(170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                sWrongLogin,
                style: TextStyle(color: IRGENDWASDOOFESISTPASSIERTFarbe),
              ),
              Container(height: 10),
              CupertinoButton(
                color: pr0grammOrange,
                child: Text(
                  "Ok",
                  style: TextStyle(color: standardSchriftfarbe),
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      );
    }
  }

  _setCache() {
    Preferences.saveUsername(usernameController.text);
    Preferences.savePassword(passwordController.text);
  }

  _loadCache() async {
    String userName = await Preferences.username();
    if (userName != null) {
      usernameController.text = userName;
    }
    String passWord = await Preferences.password();
    if (passWord != null) {
      passwordController.text = passWord;
    }
//    setState(() {});
  }

  void _loadLastLogin() async {
    String cookies = await Preferences.cookies();
    if (cookies != null) {
      ResponseParser.setCookie(cookies);
      IsLoggedIn isLoggedIn = await ResponseParser.isLoggedIn();
      print(isLoggedIn.asString());
      if (isLoggedIn.loggedIn) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            maintainState: false,
            builder: (context) => MainPage(),
          ),
        );
      }
    }
  }
}
