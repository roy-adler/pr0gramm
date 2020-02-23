import 'package:flutter/material.dart';

class AnimatedTag extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  final Widget widget;

  AnimatedTag({this.widget, Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: widget,
    );
  }
}

class AnimatedWrap extends StatefulWidget {
  final List<Widget> children;

  AnimatedWrap({this.children});

  _AnimatedWrapState createState() => _AnimatedWrapState();
}

class _AnimatedWrapState extends State<AnimatedWrap>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tagList = [];
    widget.children.forEach((element) {
      tagList.add(AnimatedTag(
        widget: element,
        animation: animation,
      ));
    });
    return Wrap(children: tagList);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
