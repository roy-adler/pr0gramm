import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm/api/debug.dart';
import 'package:pr0gramm/api/preferences.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_login.dart';
import 'package:pr0gramm/widgets/thumb_widget.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/main_page.dart';
import 'package:pr0gramm/widgets/Design/Pr0Text.dart';
import 'package:pr0gramm/widgets/Functionality/pr0_captcha.dart';
import 'package:pr0gramm/widgets/Functionality/pr0_dialog.dart';

String sBenutzername = "Benutzername";
String sAnmelden = "Anmelden";
String sPasswort = "Passwort";
String sCaptcha = "Captcha";
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
  final Pr0Captcha pr0captcha = Pr0Captcha();

  @override
  initState() {
    super.initState();
    _loadCache();
  }

  _usernameTextField() {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Pr0Text(sBenutzername),
        ),
        CupertinoTextField(
          controller: usernameController,
          placeholder: sBenutzername,
          cursorColor: pr0grammOrange,
          style: TextStyle(color: Colors.black),
          focusNode: usernameFocusNode,
          onSubmitted: (String s) {
            _fieldFocusChange(context, usernameFocusNode, passwordFocusNode);
          },
        ),
      ],
    );
  }

  _passwordTextField() {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Pr0Text(sPasswort),
        ),
        CupertinoTextField(
          controller: passwordController,
          placeholder: sPasswort,
          cursorColor: pr0grammOrange,
          style: TextStyle(color: Colors.black),
          obscureText: true,
          focusNode: passwordFocusNode,
          onSubmitted: (String s) {
            _fieldFocusChange(context, passwordFocusNode, captchaFocusNode);
          },
        ),
      ],
    );
  }

  _captchaTextField() {
    return Column(
      children: <Widget>[
        pr0captcha,
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Pr0Text(sCaptcha),
        ),
        CupertinoTextField(
          controller: captchaController,
          cursorColor: pr0grammOrange,
          style: TextStyle(color: Colors.black),
          obscureText: false,
          focusNode: captchaFocusNode,
          onSubmitted: (String s) {
            captchaFocusNode.unfocus();
            _submit();
          },
        ),
      ],
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
      token: pr0captcha.token,
    );

    if (internetDEBUG) {
      print(pr0grammLogin.asString());
    }
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
      pr0Dialog(pr0grammLogin.userError(), context,
          function: pr0captcha.loadNewcaptcha);
      setState(() {
        captchaController.text = "";
        if (pr0grammLogin.loginError() == LoginError.userdata) {
          passwordController.text = "";
          _fieldFocusChange(context, captchaFocusNode, passwordFocusNode);
        } else if (pr0grammLogin.loginError() == LoginError.captcha) {
          _fieldFocusChange(context, captchaFocusNode, captchaFocusNode);
        }
      });
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

  Widget _buildBackground() {
    return Scaffold(
      backgroundColor: richtigesGrau,
      body: FutureBuilder(
        future: ResponseParser.getContentWithoutPermission(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Pr0grammContent> contentList = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  // width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 150),
                          itemCount: contentList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ThumbWidget(
                                  pr0grammContent: contentList[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _loginFields() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _usernameTextField(),
            Container(height: 10),
            _passwordTextField(),
            Container(height: 10),
            _captchaTextField(),
            Container(height: 10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBackground(),
          _loginFields(),
        ],
      ),
    );
  }
}
