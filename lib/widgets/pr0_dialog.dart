import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

pr0Dialog(String message, BuildContext context, {Function function}) async {
  return showDialog(
    context: context,
    builder: (context) => Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Material(
              color: richtigesGrau.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
              clipBehavior: Clip.antiAlias,
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      message ?? "",
                      style: TextStyle(color: iRGENDWASDOOFESISTPASSIERTFarbe),
                    ),
                    Container(height: 10),
                    CupertinoButton(
                      color: pr0grammOrange,
                      child: Text(
                        "Ok ",
                        style: TextStyle(color: standardSchriftfarbe),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (function != null) {
                          function();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
