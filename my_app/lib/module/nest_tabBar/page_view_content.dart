

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class PageViewContent extends StatefulWidget {
  int? parentIndex;
  late int index;

   PageViewContent({super.key, this.parentIndex = 0, required this.index});

  @override
  State<StatefulWidget> createState() => PageViewContentState();

}

class PageViewContentState extends State<PageViewContent> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // print('${widget.index} ===========');
    return Container(color: Colors.green, child: Center(child: Text('第${widget.parentIndex}  职业门${widget.index}')),);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}