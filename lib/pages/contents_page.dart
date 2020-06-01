import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/widgets/Content/content_list.dart';
import 'package:pr0gramm/widgets/Content/content_page_view.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

class ContentsPage extends StatefulWidget {
  // TODO: "Good" ScrollController Implementation
  final String tagSearch;
  final Widget shellWidget;

  const ContentsPage({Key key, this.tagSearch, this.shellWidget})
      : super(key: key);

  @override
  _ContentsPageState createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> {
  TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    if (widget.tagSearch != null) {
      textEditingController.text = widget.tagSearch;
    }
    super.initState();
  }

  void _changeTag(String s) {
    setState(() => null);
  }

  SliverAppBar _getAppBar() {
    return SliverAppBar(
      backgroundColor: richtigesGrau.withOpacity(0.5),
      pinned: false,
      snap: false,
      floating: true,
      centerTitle: true,
      // expandedHeight: 200,
      title: Row(
        children: <Widget>[
          Flexible(
            child: CupertinoTextField(
              controller: textEditingController,
            ),
          ),
          Container(width: 10),
          FlatButton(
            onPressed: () => _changeTag(textEditingController.text),
            color: pr0grammOrange,
            child: Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget getSfw() {
    return FutureBuilder(
        future:
            ContentList.getSFWContentList(search: textEditingController.text),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ContentPageView(
              contentList: snapshot.data,
              controller: ScrollController(),
              appBar: _getAppBar(),
              key: Key(textEditingController.text),
            );
          }
          return LoadingIndicator();
        });
  }

  Widget getNsfw() {
    return FutureBuilder(
        future:
            ContentList.getNSFWContentList(search: textEditingController.text),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ContentPageView(
              contentList: snapshot.data,
              controller: ScrollController(),
              appBar: _getAppBar(),
              key: Key(textEditingController.text),
            );
          }
          return LoadingIndicator();
        });
  }

  Widget backButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: richtigesGrau.withOpacity(0.5),
      ),
      child: BackButton(
        onPressed: () => Navigator.pop(context),
        color: pr0grammOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: MessagesPage Implementation

    return Scaffold(
      backgroundColor: richtigesGrau,
      body: getSfw(),
    );
  }
}
