// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class NestTabBar extends StatefulWidget {
  TabController? tabController;
  int selectedIndex = 0;
  PageController? pageController;
  late List<String> tabTitles;
  late double labelPadding;
  final double textSize;
  final double selectTextSize;
  final Decoration indicator;
  final bool isParent;

  NestTabBar({
    super.key,
    this.tabController,
    this.pageController,
    required this.tabTitles,
    this.labelPadding = 8,
    required this.textSize,
    required this.selectTextSize,
    this.indicator = const BoxDecoration(),
    this.isParent = true,
  });

  @override
  State<StatefulWidget> createState() => NestTabBarState();
}

class NestTabBarState extends State<NestTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        indicator: widget.indicator,
        controller: widget.tabController,
        labelPadding: EdgeInsets.symmetric(horizontal: widget.labelPadding),
        onTap: (index) {
          ///以下切换方式：从tab1点击切换到tab6,会导致1-6所有PageView页面都加载
          /// widget.pageController?.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
          widget.pageController?.jumpToPage(index);
        },
        tabs: List<Widget>.generate(
            widget.tabTitles.length,
            (index) => MyTab(
                  widget.tabTitles[index],
                  widget.selectedIndex == index,
                  selectTextSize: widget.selectTextSize,
                  textSize: widget.textSize,
                  isParent: widget.isParent,
                )),
      ),
    );
  }

  void refresh() {
    setState(() {
      if (widget.tabController != null) {
        widget.selectedIndex = widget.tabController!.index;
      }
    }); // 触发局部刷新
  }
}

class MyTab extends StatelessWidget {
  final String text;
  final bool isSelected;
  final double textSize;
  final double selectTextSize;
  final bool isParent;

  const MyTab(this.text, this.isSelected,
      {super.key,
      required this.textSize,
      required this.selectTextSize,
      this.isParent = true});

  @override
  Widget build(BuildContext context) {
    if (isParent) {
      return Tab(
        child: Text(
          text,
          style: TextStyle(
              color: isSelected
                  ? const Color(0xFF262626)
                  : const Color(0xFF8D8D8D),
              fontSize: isSelected ? selectTextSize : textSize),
        ),
      );
    }

    return Tab(
      height: 40,
      child: Center(
        child: Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color:
                      isSelected ? const Color(0xFFFF4A34) : Colors.transparent,
                  width: 0.5),
              color: isSelected
                  ? const Color(0xFFFFF4F0)
                  : const Color(0xFFF7F7F7),
            ),
            child: Text(
              text,
              style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFFF4A34)
                      : const Color(0xFF8D8D8D),
                  fontSize: isSelected ? selectTextSize : textSize),
            )),
      ),
    );
  }
}
