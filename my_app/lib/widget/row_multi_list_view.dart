import 'package:flutter/material.dart';

/// [isRepeatedClick] 是否重复点击
/// [listViewIndex] ListViw索引，从0开始
/// [clickedIndexes] 每个ListView点击的index，注意：默认初始值为-1；
typedef OnItemClick = Function(
    bool isRepeatedClick, int listViewIndex, List<int> clickedIndexes);

/// [isSelected] 是否选中
/// [listViewIndex] ListViw索引，从0开始
/// [index] ListViw item索引，从0开始
typedef ListViewsItemBuilder = Widget Function(
    bool isSelected, int listViewIndex, int index);

/// 水平，多列选择器
class RowMultiListView extends StatefulWidget {
  /// listView 数量
  final int listViewCount;

  /// listViw 列表长度集合
  final List<int?> listViewItemCounts;

  /// listView itemBuilder集合
  final ListViewsItemBuilder listViewItemBuilders;

  /// listView宽度集合，null表示均分屏幕宽度，也可指定宽度值.
  ///   例3个列表：[null, null, null]、[100, null, null]、[100, 100, 120]
  final List<double?>? listViewWidths;

  /// 点击事件
  final OnItemClick? onItemClick;

  RowMultiListView({
    Key? key,
    required this.listViewCount,
    this.listViewWidths,
    required this.listViewItemCounts,
    required this.listViewItemBuilders,
    this.onItemClick,
  }) : super(key: key) {
    if (listViewWidths != null && (listViewWidths?.length != listViewCount)) {
      throw ArgumentError(
          'The listViewWidths length should match the value of listViewCount.');
    }
  }

  @override
  State<StatefulWidget> createState() => RowMultiListViewState();
}

class RowMultiListViewState extends State<RowMultiListView> {
  /// 每个ListView点击索引，默认值为-1
  late List<int> _clickedIndexes;

  /// 屏幕宽度
  late double _screenWidth;

  /// 平均宽度
  double _listViewWidth = 0;

  @override
  void initState() {
    super.initState();
    _clickedIndexes = List.generate(widget.listViewCount, (index) => -1);
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    _getListViewWidth();
    return Row(
      children: List.generate(
          widget.listViewCount, (index) => _getListViewWidget(index)),
    );
  }

  /// 第 [listViewIndex] 个ListView
  Widget _getListViewWidget(int listViewIndex) {
    var isLast = listViewIndex == widget.listViewCount - 1;
    var isFixedWidth = widget.listViewWidths?[listViewIndex] != null;
    return (isLast && !isFixedWidth)
        ? Expanded(child: _getListView(listViewIndex))
        : SizedBox(
            width: widget.listViewWidths?[listViewIndex] ?? _listViewWidth,
            child: _getListView(listViewIndex),
          );
  }

  Widget _getListView(int listViewIndex) => ListView.builder(
        itemCount: _getItemCount(listViewIndex),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                if (widget.onItemClick != null) {
                  var isRepeatedClick = _clickedIndexes[listViewIndex] == index;
                  if (!isRepeatedClick) {
                    resetClickedIndexes(listViewIndex);
                  }
                  _clickedIndexes[listViewIndex] = index;
                  widget.onItemClick!(
                      isRepeatedClick, listViewIndex, _clickedIndexes);
                }
              },
              child: _getItemBuilder(listViewIndex, index));
        },
      );

  /// 每个ListView的长度
  int _getItemCount(int listViewIndex) {
    if (listViewIndex < widget.listViewItemCounts.length) {
      return widget.listViewItemCounts[listViewIndex] ?? 0;
    }
    return 0;
  }

  /// 每个ListView的布局
  Widget _getItemBuilder(int listViewIndex, int index) {
    bool isSelected = index == _clickedIndexes[listViewIndex];
    return widget.listViewItemBuilders(isSelected, listViewIndex, index);
  }

  /// 获取平均宽度
  void _getListViewWidth() {
    var length = widget.listViewWidths?.length;
    if (length == null) {
      _listViewWidth = _screenWidth / widget.listViewCount;
      return;
    }
    for (int i = 0; i < length; i++) {
      var width = widget.listViewWidths![i];
      if (width == null) {
        _listViewWidth = _screenWidth / (widget.listViewCount - i);
        break;
      } else {
        _screenWidth -= width;
      }
    }
  }

  /// 点击时，重置后续保存的ListView的点击索引
  void resetClickedIndexes(int listViewIndex) {
    var start = listViewIndex + 1;
    var length = _clickedIndexes.length;
    for (int i = start; i < length; i++) {
      _clickedIndexes[i] = -1;
    }
  }
}
