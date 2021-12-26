import 'package:flutter/material.dart';
import 'package:minesweeper/ms_actionbar.dart';
import 'package:minesweeper/ms_board.dart';
import 'package:minesweeper/ms_controller.dart';
import 'package:minesweeper/ms_models.dart';

class MSGameBody extends StatefulWidget {
  const MSGameBody({Key? key}) : super(key: key);

  @override
  State<MSGameBody> createState() => _MSGameBodyState();
}

class _MSGameBodyState extends State<MSGameBody> {
  late MSController controller;
  MSDifficulty difficulty = MSDifficulty.beginner;

  @override
  void initState() {
    controller = MSController(
      () {
        setState(() {});
      },
      difficulty: difficulty,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MSActionBar(
          controller: controller,
          reset: (MSDifficulty? _difficulty) {
            difficulty = _difficulty ?? difficulty;

            controller = MSController(
              () {
                setState(() {});
              },
              difficulty: difficulty,
            );

            setState(() {});
          },
        ),
        Expanded(
          child: MSBoard(controller: controller),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.stopTimer();
    super.dispose();
  }
}
