import 'package:flutter/material.dart';

import '../../widget/custom_circle_tab_indicator.dart';
import 'page_view_content.dart';
import 'page_view_scroll_utils.dart';
import '../../widget/custom_tab_indicator.dart';
import '../../widget/nest_tab_bar.dart';

/// TabBar + PageView + TabBar + TabBarView，这个有bug，第二层TabBar，tab背景色移动比较慢
class NestTabBarDemo2 extends StatefulWidget {
  const NestTabBarDemo2({super.key});

  @override
  State<StatefulWidget> createState() => _NestTabBarDemo2PageState();
}

class _NestTabBarDemo2PageState extends State<NestTabBarDemo2>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;

  final GlobalKey<NestTabBarState> _firstTabBarKey = GlobalKey();
  List<String> tabTitles = [
    '公共课',
    '统考专业课',
    '主3',
    '第三方极乐空间乐山大佛',
    'sldjfkkjsdfDFSlkjDSF水电费',
    '主4',
    '555',
    '666'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: tabTitles.length, vsync: this);
    _tabController.addListener(() {
      _firstTabBarKey.currentState?.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageView嵌套滑动测试'),
      ),
      body: Column(
        children: [
          NestTabBar(
            key: _firstTabBarKey,
            tabController: _tabController,
            pageController: _pageController,
            tabTitles: tabTitles,
            textSize: 14,
            selectTextSize: 17,
            indicator: CustomTabIndicator(width: 15, borderSide: BorderSide(width: 4.0, color: const Color(0xFFFF4A34))),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                _tabController.animateTo(index);
                // TODO 重点解决快速滑动，产生的内外滑动冲突，参考（https://juejin.cn/post/6944724773452644366）
                _pageController.position.context.setIgnorePointer(false);
              },
              children: List<Widget>.generate(tabTitles.length,
                  (index) => HomePage(_pageController, index)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    print('最外层dispose被调用');
    _tabController.dispose();
    super.dispose();
  }
}

class HomePage extends StatefulWidget {
  final PageController pageController;
  int? tabId;

  HomePage(this.pageController, this.tabId);

  @override
  _HomePageState createState() => _HomePageState();
}

/// AutomaticKeepAliveClientMixin保留(Widget build(BuildContext context)中带上super.build(context);)，否则PageView切换的时候，会调用上一个PageView页面dispose()
class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController? _tabController;
  PageController? _pageController;
  PageViewScrollUtils? _pageViewScrollUtils;

  List<String> tabTitles = [];
  List<Widget> pages = [];

  bool hasLoadData = false;

  final GlobalKey<NestTabBarState> _tabBarKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      hasLoadData = true;
      setState(() {
        if (widget.tabId == 0) {
          tabTitles = [
            '第0主页1',
            '第0主页1',
            '第0主页2',
          ];
        } else if (widget.tabId == 1 || widget.tabId == 2) {
          tabTitles = [
            '第2主页1',
            '第2主页1',
            '第2主页2',
          ];
        } else if (widget.tabId == 4) {
          tabTitles = [
            '第4主页1',
            '第4主页1',
            '第4主页2',
          ];
        }

        if (widget.tabId == 3) {
          // 没有二层TabBar的时候，肯定只有一个子页面
          pages = List<Widget>.generate(
              1,
              (index) => PageViewContent(
                    parentIndex: widget.tabId,
                    index: index,
                  ));
        } else {
          pages = List<Widget>.generate(
              tabTitles.length,
              (index) => PageViewContent(
                    parentIndex: widget.tabId,
                    index: index,
                  ));
        }

        _tabController = TabController(length: tabTitles.length, vsync: this);
        _pageController = PageController();
        _pageViewScrollUtils = PageViewScrollUtils(
          widget.pageController,
          _tabController,
        );
        _tabController?.addListener(() {
          _tabBarKey.currentState?.refresh();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO 测试打印
    print('主${widget.tabId}================');
    return !hasLoadData
        ? Container()
        : tabTitles.isEmpty && pages.isEmpty
            ? Center(
                child: Text('数据为空'),
              )
            : Column(
                children: [
                  Visibility(
                      visible: tabTitles.isNotEmpty,
                      child: NestTabBar(
                        key: _tabBarKey,
                        tabController: _tabController,
                        pageController: _pageController,
                        tabTitles: tabTitles,
                        textSize: 14,
                        selectTextSize: 14,
                        isParent: false,
                      )),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      child: TabBarView(
                        controller: _tabController,
                        children: pages,
                      ),
                      onNotification: _pageViewScrollUtils?.handleNotification,
                    ),
                  ),
                ],
              );
  }

  @override
  void dispose() {
    print('主${widget.tabId}================dispose被调用');
    _tabController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}


