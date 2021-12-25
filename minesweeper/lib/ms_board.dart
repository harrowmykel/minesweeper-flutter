import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper/ms_box.dart';
import 'package:minesweeper/ms_controller.dart';
import 'package:minesweeper/ms_models.dart';

class MSBoard extends StatelessWidget {
  final MSController controller;

  const MSBoard({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int bHeight = controller.boardHeight;
    int bWidth = controller.boardWidth;
    int padding = 2;

    Size screenSize = MediaQuery.of(context).size;
    double sWidth = screenSize.width - (padding * bWidth);
    double sHeight = screenSize.height - 80 - (padding * bHeight);

    double width = sWidth / bWidth;
    double height = sHeight / bHeight;

    double boxBlockSize = min(height, width);

    return Container(
      alignment: Alignment.center,
      child: Center(
        child: IntrinsicHeight(
          child: Column(
            children: List.generate(bHeight, (y) {
              return Row(
                children: List.generate(bWidth, (x) {
                  return MSBox(
                    controller: controller,
                    index: MSBoxPosition(x, y),
                    boxBlockSize: boxBlockSize,
                    padding: padding / 2,
                  );
                }),
              );
            }),
          ),
        ),
      ),
    );
  }
}
