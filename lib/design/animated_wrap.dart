import 'package:flutter/material.dart';

class AnimatedWrap extends StatefulWidget {
  final List<Widget> children;

  AnimatedWrap({this.children});

  @override
  _AnimatedWrapState createState() => _AnimatedWrapState();
}

class _AnimatedWrapState extends State<AnimatedWrap> {
  double opacity;

  @override
  void initState() {
    opacity = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = widget.children.map((item) {
      int i = widget.children.indexOf(item);
      final animated = AnimatedOpacity(
        duration: Duration(milliseconds: 200+i*50),
        opacity: opacity,
        child: item,
      );
      return animated;
    }).toList();
    opacity = 1.0;
    return Wrap(
      children: widgetList,
    );
  }
}
