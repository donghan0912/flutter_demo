import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef BackPressed = Function();
///
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool dark; //深色模式，控制状态栏字体颜色，和返回键颜色
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool centerTitle;
  final double titleSize; //字体大小
  final Color? titleColor; //字体颜色
  final FontWeight titleFontWeight;
  final double elevation;
  final double height; //控件高度
  final BackPressed? backPressed; //返回键监听
  final bool isScrollable; //标题是否可以滚动

  const CommonAppBar(
      {super.key,
      this.backgroundColor,
      required this.title,
      this.dark = false,
      this.actions,
      this.leading,
      this.centerTitle = true,
      this.bottom,
      this.titleSize = 20.0,
      this.titleColor,
      this.titleFontWeight = FontWeight.normal,
      this.elevation = 0,
      this.height = 50,
      this.backPressed,
      this.isScrollable = false});

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(
      title ?? '',
      style: TextStyle(
        fontSize: titleSize,
        color: titleColor ?? Colors.black,
        fontWeight: titleFontWeight,
      ),
    );
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
      ),
      elevation: elevation,
      centerTitle: centerTitle,
      // boolean 类型，表示标题是否居中显示
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.inversePrimary,
      actions: actions,
      title: titleWidget,
      // leading: leading ??
      //     IconButton(
      //         icon: Icon(
      //           Icons.arrow_back_ios,
      //           color: dark ? AppColors.appBarBgPrimary : AppColors.appBarBgSecondary,
      //           size: 22,
      //         ),
      //         onPressed: () {
      //           if (backPressed != null) {
      //             backPressed!();
      //           } else {
      //             BoostNavigator.instance.pop();
      //           }
      //         }),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
