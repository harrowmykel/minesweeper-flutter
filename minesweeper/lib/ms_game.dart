import 'package:flutter/material.dart';
import 'package:minesweeper/ms_actionbar.dart';
import 'package:minesweeper/ms_board.dart';
import 'package:minesweeper/ms_controller.dart';

class MSGame extends StatefulWidget {
  const MSGame({Key? key}) : super(key: key);

  @override
  State<MSGame> createState() => _MSGameState();
}

class _MSGameState extends State<MSGame> {
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            MSActionBar(controller: controller),
            Expanded(
              child: MSBoard(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}
