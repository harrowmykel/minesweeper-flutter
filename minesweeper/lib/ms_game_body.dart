import 'package:flutter/material.dart';
import 'package:minesweeper/ms_actionbar.dart';
import 'package:minesweeper/ms_board.dart';
import 'package:minesweeper/ms_controller.dart';

class MSGameBody extends StatefulWidget {
  const MSGameBody({Key? key}) : super(key: key);

  @override
  State<MSGameBody> createState() => _MSGameBodyState();
}

class _MSGameBodyState extends State<MSGameBody> {
  late MSController controller;
  @override
  void initState() {
    controller = MSController(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MSActionBar(
          controller: controller,
          reset: () {
            controller = MSController(() {
              setState(() {});
            });
            setState(() {});
          },
        ),
        Expanded(
          child: MSBoard(controller: controller),
        ),
      ],
    );
  }
}
