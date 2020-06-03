import 'package:flutter/material.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/global_variables.dart';

class FilterButton extends StatefulWidget {
  final Null Function(int filter) filterChanger;
  final int currentFilter;

  FilterButton({this.currentFilter, this.filterChanger});

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        int _filter = sfw;
        if (widget.currentFilter == sfw) {
          _filter = nsfw;
        }
        widget.filterChanger(_filter);
      },
      color: pr0grammOrange,
      focusColor: Colors.red,
      child: Text(
        widget.currentFilter == sfw ? "sfw" : "nsfw",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
