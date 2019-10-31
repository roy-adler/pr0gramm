import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/preferences.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/is_loggedIn.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/pages/main_page.dart';

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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode usernameFocusNode =
      FocusNode(debugLabel: "usernameFocusNode");
  final FocusNode passwordFocusNode =
      FocusNode(debugLabel: "passwordFocusNode", canRequestFocus: true);

  void _usernameInput() {
    String temp = usernameController.text.toString();
    if (temp.contains("\t")) {
      _fieldFocusChange(context, usernameFocusNode, passwordFocusNode);
      usernameController.text = temp.trim();
    }
  }

  void _passwordInput() {
    String temp = passwordController.text.toString();
    if (temp.contains("\t")) {
      passwordFocusNode.unfocus();
      passwordController.text = temp.trim();
      _submit();
    }
  }

  @override
  initState() {
    super.initState();
    _loadLastLogin();
    void Function() listener;
    usernameController.addListener(_usernameInput);
    passwordController.addListener(_passwordInput);
    _loadCache();
  }

  _usernameTextField() {
    return CupertinoTextField(
      controller: usernameController,
      placeholder: sBenutzername,
      cursorColor: pr0grammOrange,
      style: TextStyle(color: standardSchriftfarbe),
      focusNode: usernameFocusNode,
      onSubmitted: (String s) {
        _fieldFocusChange(context, usernameFocusNode, passwordFocusNode);
      },
    );
  }

  _passwordTextField() {
    return CupertinoTextField(
      controller: passwordController,
      placeholder: sPasswort,
      cursorColor: pr0grammOrange,
      style: TextStyle(color: standardSchriftfarbe),
      obscureText: true,
      focusNode: passwordFocusNode,
      onSubmitted: (String s) {
        passwordFocusNode.unfocus();
        _submit();
      },
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
            _buildCaptcha(),
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
    usernameController.text = usernameController.text.trim();
    passwordController.text = passwordController.text.trim();
    Preferences.saveUsername(usernameController.text);

    Pr0grammLogin pr0grammLogin = await ResponseParser.getPr0grammLogin(
        username: usernameController.text, password: passwordController.text);
    if (pr0grammLogin.success == true) {
      await _setCache();
      Navigator.push(
        context,
        CupertinoPageRoute(
          maintainState: false,
          builder: (context) => MainPage(
            pr0grammLogin: pr0grammLogin,
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
                style: TextStyle(color: iRGENDWASDOOFESISTPASSIERTFarbe),
              ),
              Container(height: 10),
              CupertinoButton(
                color: pr0grammOrange,
                child: Text(
                  "Ok",
                  style: TextStyle(color: standardSchriftfarbe),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  passwordController.text = "";
                },
              )
            ],
          ),
        ),
      );
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
      await ResponseParser.setCookie(cookies);
      IsLoggedIn isLoggedIn = await ResponseParser.isLoggedIn();
      if (isLoggedIn.loggedIn) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      }
    }
  }

  Widget _buildCaptcha() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
      ),
      child: Image.network("https://pr0gramm.com/api/user/captcha"),
    );
  }
}
