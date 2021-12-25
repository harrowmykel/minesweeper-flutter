import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minesweeper/ms_controller.dart';

class MSBox extends StatelessWidget {
  final MSController controller;
  final int index;
  final double boxBlockSize;
  final double padding;

  const MSBox({
    required this.controller,
    required this.index,
    required this.boxBlockSize,
    required this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MSBoxItem box = controller.getBox(index);

    Widget child = const SizedBox.shrink();
    if (box.state == MSBoxState.Flagged) {
      child = const Icon(FontAwesomeIcons.flag);
    } else if (box.state == MSBoxState.Opened) {
      child = Text(
        box.value,
        style: TextStyle(fontSize: (boxBlockSize - 4)),
      );
    }

    return InkWell(
      child: Container(
        height: boxBlockSize,
        width: boxBlockSize,
        margin: EdgeInsets.all(padding),
        color: Colors.grey.shade300,
        child: Center(
          child: child,
        ),
      ),
      onTap: () => controller.onBoxClick(index),
      onLongPress: () => controller.toggleFlag(index),
    );
  }
}
