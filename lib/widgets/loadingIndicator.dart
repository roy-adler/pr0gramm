import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: pr0grammOrange,
      ),
    );
  }
}
