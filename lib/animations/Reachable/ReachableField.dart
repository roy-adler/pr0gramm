import 'package:flutter/material.dart';
import 'package:pull_to_reach/widgets/reachable.dart';

class ReachableField extends StatefulWidget {
  final Widget icon;
  final int index;
  final VoidCallback onSelect;

  final Duration duration;
  final EdgeInsets padding;
  final double scaleFactor;

  ReachableField({
    @required this.icon,
    @required this.index,
    @required this.onSelect,
    this.padding = const EdgeInsets.all(8),
    this.duration = const Duration(milliseconds: 100),
    this.scaleFactor = 1.25,
  });

  @override
  _ReachableFieldState createState() => _ReachableFieldState();
}

class _ReachableFieldState extends State<ReachableField>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _iconScaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Reachable(
      index: widget.index,
      onSelect: widget.onSelect,
      onFocusChanged: (isFocused) {
        if (isFocused) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      child: scaleTransition(),
    );
  }

  ScaleTransition scaleTransition() {
    return ScaleTransition(
      scale: _iconScaleAnimation.drive(Tween(
        begin: 1,
        end: widget.scaleFactor,
      )),
      child: InkResponse(
        onTap: widget.onSelect,
        child: Container(
          margin: widget.padding,
          child: widget.icon,
        ),
      ),
    );
  }
}
