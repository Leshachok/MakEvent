
import 'package:flutter/cupertino.dart';

class FlowMenuDelegate extends FlowDelegate{
  final Animation<double> menuAnimation;

  FlowMenuDelegate({required this.menuAnimation})
      : super(repaint: menuAnimation);

  List<int> horizontal = [0, -1, 1];
  List<double> sizes = [0, 86, 86];
  
  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; ++i) {
      var matrix = Matrix4.translationValues(
        horizontal[i]* sizes[i] * menuAnimation.value, 0 , 0,
      );
      context.paintChild(i, transform: matrix);
    }
  }

  @override
  bool shouldRepaint(covariant FlowMenuDelegate oldDelegate) {
    return menuAnimation != oldDelegate.menuAnimation;
  }



}