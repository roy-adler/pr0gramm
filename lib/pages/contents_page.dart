import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/global_variables.dart';
import 'package:pr0gramm/widgets/Content/content_list.dart';
import 'package:pr0gramm/widgets/Content/content_page_view.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';
import 'package:pr0gramm/widgets/Functionality/filter_button.dart';

class ContentsPage extends StatefulWidget {
  // TODO: "Good" ScrollController Implementation
  final String tagSearch;
  final int filter;

  const ContentsPage({
    Key key,
    this.tagSearch,
    this.filter,
  }) : super(key: key);

  @override
  _ContentsPageState createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> {
  TextEditingController textEditingController;
  int _currentFilter;

  @override
  void initState() {
    textEditingController = TextEditingController();
    if (widget.tagSearch != null) {
      textEditingController.text = widget.tagSearch;
    }
    _currentFilter = widget.filter ?? sfw;
    super.initState();
  }

  void _changeTag(String s) {
    setState(() => null);
  }

  FilterButton getFilterButton() {
    return FilterButton(
      currentFilter: _currentFilter,
      filterChanger: (int filter) {
        setState(() {
          _currentFilter = filter;
        });
      },
    );
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
          getFilterButton(),
          Container(width: 10),
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

  Widget getContent() {
    return FutureBuilder(
      future: ContentList.getFilteredContentList(
          filter: _currentFilter, search: textEditingController.text),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0grammContent> contentList = snapshot.data
              //.where((element) => element.mediaType == MediaType.vid)
              .toList();
          return ContentPageView(
            contentList: contentList,
            controller: ScrollController(),
            appBar: _getAppBar(),
            filter: _currentFilter,
            key: Key(textEditingController.text),
          );
        }
        return LoadingIndicator();
      },
    );
  }

  // TODO: Check what usage could be
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
      body: getContent(),
    );
  }
}
