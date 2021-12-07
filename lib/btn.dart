import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppBtn extends StatelessWidget {
  final String title;
  final int size;
  final int column;
  final bool isExpanded;
  final GestureTapCallback? onTap;

  const AppBtn({
    Key? key,
    this.title = "",
    this.size = 1,
    this.column = 3,
    this.onTap,
    this.isExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 0.5)),
          child: Center(child: Text(title)),
        ),
      ),
    );
  }
}
