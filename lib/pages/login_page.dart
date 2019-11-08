import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm_app/api/debug.dart';
import 'package:pr0gramm_app/api/preferences.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/captchaContainer.dart';
import 'package:pr0gramm_app/content/is_loggedIn.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/pages/main_page.dart';

String sBenutzername = "Benutzername";
String sAnmelden = "Anmelden";
String sPasswort = "Passwort";
String sWrongLogin = "Falscher Benutzername oder Passwort";
String sNeuLaden = "Neu laden";

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController captchaController = TextEditingController();
  final FocusNode usernameFocusNode = FocusNode(debugLabel: "usrnmFocusNode");
  final FocusNode passwordFocusNode = FocusNode(debugLabel: "pwFocusNode");
  final FocusNode captchaFocusNode = FocusNode(debugLabel: "captchaFocusNode");

  String token = "";

  @override
  initState() {
    super.initState();
    _loadCache();
  }

  _usernameTextField() {
    return CupertinoTextField(
      controller: usernameController,
      placeholder: sBenutzername,
      cursorColor: pr0grammOrange,
      style: TextStyle(color: Colors.black),
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
        _fieldFocusChange(context, passwordFocusNode, captchaFocusNode);
      },
    );
  }

  _captchaTextField() {
    return CupertinoTextField(
      controller: captchaController,
      cursorColor: pr0grammOrange,
      style: TextStyle(color: standardSchriftfarbe),
      obscureText: false,
      focusNode: captchaFocusNode,
      onSubmitted: (String s) {
        captchaFocusNode.unfocus();
        _submit();
      },
    );
  }

  void _submit() async {
    usernameController.text = usernameController.text.trim();
    passwordController.text = passwordController.text.trim();
    Preferences.saveUsername(usernameController.text);
    Preferences.savePassword(passwordController.text);

    Pr0grammLogin pr0grammLogin = await ResponseParser.getPr0grammLogin(
        username: usernameController.text,
        password: passwordController.text,
        captcha: captchaController.text,
        token: token);

    print(pr0grammLogin.asString());
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
                pr0grammLogin.error,
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
                },
              )
            ],
          ),
        ),
      );
    }
  }

  _refreshButton() {
    return CupertinoButton(
      child: Text(sNeuLaden),
      onPressed: () => setState(() {}),
      color: pr0grammOrange,
    );
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

  Widget _buildCaptcha() {
    return FutureBuilder(
      future: ResponseParser.getCaptcha(),
      builder: (context, snapshot) {
        Image image;
        if (snapshot.hasData) {
          CaptchaContainer captchaContainer = snapshot.data;
          print(captchaContainer.asString());
          int position = captchaContainer.captcha.indexOf(',') + 1;
          Uint8List decoded =
              base64Decode(captchaContainer.captcha.substring(position));
          token = captchaContainer.token;
          image = Image.memory(decoded);
        }
        return Stack(
          children: <Widget>[
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: snapshot.hasData ? 1 : 0,
              child: image ?? Container(width: 360, height: 90),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            'https://media.giphy.com/media/3o84U78CXEB2opZd4I/giphy.gif',
            fit: BoxFit.fitHeight,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              //decoration: BoxDecoration(color: richtigesGrau.withOpacity(0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _usernameTextField(),
                  _passwordTextField(),
                  _buildCaptcha(),
                  _captchaTextField(),
                  CupertinoButton(
                    child: Text(sAnmelden),
                    onPressed: () => _submit(),
                    color: pr0grammOrange,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
