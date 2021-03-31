import 'package:flutter/material.dart';

class ContentPageViewBuilder extends StatefulWidget {
  final Widget newsPage;
  final Widget sFWPage;
  final Widget nSFWPage;
  final Widget nSFLPage;

  const ContentPageViewBuilder({
    Key key,
    this.newsPage,
    this.sFWPage,
    this.nSFWPage,
    this.nSFLPage,
  }) : super(key: key);

  @override
  _ContentPageViewBuilderState createState() => _ContentPageViewBuilderState();
}

class _ContentPageViewBuilderState extends State<ContentPageViewBuilder> {
  PageController controller = PageController(initialPage: 1);
  var currentPageValue = 0.0;
  List<Widget> pageList;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page;
        //print(currentPageValue);
      });
    });

    pageList = [
      widget.newsPage,
      widget.sFWPage,
      widget.nSFWPage,
      widget.nSFLPage,
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double op = currentPageValue - currentPageValue.floor();
    return PageView.builder(
      controller: controller,
      itemBuilder: (context, position) {
        if (position == currentPageValue.floor()) {
          return Opacity(
            opacity: 1 - op,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0010)
                ..rotateY(currentPageValue - position),
              child: pageList[currentPageValue.floor()],
            ),
          );
        } else if (position == currentPageValue.floor() + 1) {
          return Opacity(
            opacity: op,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0025)
                ..rotateY(currentPageValue - position),
              child: pageList[currentPageValue.floor() + 1],
            ),
          );
        } else {
          return Container(
            color: position % 2 == 0 ? Colors.blue : Colors.pink,
            child: Center(
              child: Text(
                "Page",
                style: TextStyle(color: Colors.white, fontSize: 22.0),
              ),
            ),
          );
        }
      },
      itemCount: 4,
    );
  }
}
