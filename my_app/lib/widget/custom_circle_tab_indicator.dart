import 'package:flutter/material.dart';

/// TabBar 圆角背景色，使用场景是只有选中状态，选中、未选中两种状态的不可用
class CustomCircleTabIndicator extends Decoration {
  final double tabTextHeight;
  final Color bgColor;
  final Color? borderColor;
  final double borderWidth;
  final double leftAndRightPadding;
  final double radius;

  const CustomCircleTabIndicator(
      {required this.tabTextHeight,
      required this.bgColor,
      this.borderColor,
      this.borderWidth = 1.0,
      this.leftAndRightPadding = 16.0,
      this.radius = 8.0});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomBoxPainter(this, onChanged);
  }
}

class _CustomBoxPainter extends BoxPainter {
  final CustomCircleTabIndicator decoration;

  _CustomBoxPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    var tabHeight = configuration.size?.height ?? 48;
    var dy = (tabHeight - decoration.tabTextHeight) / 2;

    var tabWidth = configuration.size?.width ?? 48;
    //矩形水平和垂直偏移量
    var offset2 = Offset(offset.dx - decoration.leftAndRightPadding / 2, dy);
    //矩形水平方向偏移量和高度
    var size = Size(
        tabWidth + decoration.leftAndRightPadding, decoration.tabTextHeight);
    Rect? rect = offset2 & size;

    final Paint paint = Paint();
    paint.color = decoration.bgColor;
    paint.style = PaintingStyle.fill;
    var borderRadius = BorderRadius.all(Radius.circular(decoration.radius));
    final rRect = RRect.fromRectAndCorners(
      rect,
      topRight: borderRadius.topRight,
      topLeft: borderRadius.topLeft,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
    canvas.drawRRect(rRect, paint);

    if (decoration.borderColor != null) {
      final borderPaint = Paint()
        ..color = decoration.borderColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = decoration.borderWidth;
      final borderPath = Path()..addRRect(rRect);
      canvas.drawPath(borderPath, borderPaint);
    }
  }
}
