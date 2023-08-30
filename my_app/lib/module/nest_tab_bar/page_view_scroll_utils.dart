import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PageViewScrollUtils {
  PageController? pageController;
  TabController? tabController;
  Drag? _drag;

  PageViewScrollUtils(
    this.pageController,
    this.tabController,
  );

  /// 这个TabBar+PageView的时候可行
  bool handleNotification(ScrollNotification? notification) {
    if (pageController == null || tabController == null) {
      return false;
    }
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          tabController!.index == tabController!.length - 1) {
        _drag = pageController!.position.drag(DragStartDetails(), () {
          _drag = null;
        });
      } else if (notification.direction == ScrollDirection.forward &&
          tabController!.index == 0) {
        _drag = pageController!.position.drag(DragStartDetails(), () {
          _drag = null;
        });
      }
    }

    if (notification is OverscrollNotification) {
      if (notification.dragDetails != null && _drag != null) {
        _drag?.update(notification.dragDetails!);
      }
    }
    if (notification is ScrollEndNotification) {
      if (notification.dragDetails != null && _drag != null) {
        _drag?.end(notification.dragDetails!);
        _drag = null;
      }
    }
    return true;
  }
}
