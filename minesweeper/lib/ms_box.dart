import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minesweeper/ms_controller.dart';
import 'package:minesweeper/ms_models.dart';

class MSBox extends StatelessWidget {
  final MSController controller;
  final MSBoxPosition index;
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
    MSBoxItem? box = controller.getBox(index);

    if (box == null) {
      return const SizedBox.shrink();
    }

    Widget child = const SizedBox.shrink();
    Widget boxWidget = Text(
      box.value,
      style: TextStyle(fontSize: (boxBlockSize - 4)),
    );

    bool revealed = box.isOpened;

    if (box.hasMine && !box.isFlagged && controller.openMines) {
      child = boxWidget;
      revealed = true;
    } else if (controller.openAll) {
      child = boxWidget;
      revealed = true;
    } else if (box.isFlagged) {
      child = const Icon(
        FontAwesomeIcons.flag,
        color: Colors.red,
      );
    } else if (box.isOpened) {
      child = boxWidget;
      revealed = true;
    }

    return InkWell(
      child: Container(
        height: boxBlockSize,
        width: boxBlockSize,
        margin: EdgeInsets.all(padding),
        color: revealed ? Colors.grey.shade300 : Colors.grey.shade500,
        child: Center(
          child: child,
        ),
      ),
      onTap: () => controller.onBoxClick(index),
      onLongPress: () => controller.toggleFlag(index),
    );
  }
}
