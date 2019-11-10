import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pr0gramm_app/api/preferences.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/captchaContainer.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/content/pr0gramm_login.dart';
import 'package:pr0gramm_app/design/pr0_text.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:pr0gramm_app/pages/main_page.dart';
import 'package:giphy_client/giphy_client.dart';
import 'package:pr0gramm_app/widgets/loadingIndicator.dart';
import 'package:pr0gramm_app/widgets/pr0_dialog.dart';
import 'package:pr0gramm_app/widgets/giphy.dart';

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

  String token = "";

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
          child: Pr0Text(
            sBenutzername,
            textAlign: TextAlign.start,
            heading: true,
          ),
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
          child: Pr0Text(
            sPasswort,
            textAlign: TextAlign.start,
            heading: true,
          ),
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
        _buildCaptcha(),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Pr0Text(
            sCaptcha,
            textAlign: TextAlign.start,
            heading: true,
          ),
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
      Pr0Dialog(pr0grammLogin.userError(), context);
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

  Widget _buildCaptcha() {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder(
        future: ResponseParser.getCaptcha(),
        builder: (context, snapshot) {
          Image image;
          if (snapshot.hasData) {
            CaptchaContainer captchaContainer = snapshot.data;
            print(captchaContainer.asString());
            int position = captchaContainer.captcha.indexOf(',') + 1;
            if (captchaContainer.captcha.length > position) {
              Uint8List decoded =
                  base64Decode(captchaContainer.captcha.substring(position));
              token = captchaContainer.token;
              image = Image.memory(decoded);
            }
          }
          return Stack(
            children: <Widget>[
              AnimatedOpacity(
                curve: Curves.easeOut,
                duration: Duration(milliseconds: 400),
                opacity: snapshot.hasData ? 1 : 0,
                child: image ?? Container(width: 360, height: 90),
              ),
            ],
          );
        },
      ),
    );
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
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150),
                          itemCount: contentList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: contentList[index],
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
          return Container(color: Colors.red, height: 800, width: 200,);
        },
      ),
    );

    return FutureBuilder(
      future: giphy(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.network(
            snapshot.data,
            fit: BoxFit.fitHeight,
          );
        }
        return Image.network(
          'https://media.giphy.com/media/3o84U78CXEB2opZd4I/giphy.gif',
          fit: BoxFit.fitHeight,
        );
      },
    );
  }

  Widget _loginFields() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
