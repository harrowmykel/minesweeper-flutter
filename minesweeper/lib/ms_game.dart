import 'package:flutter/material.dart';
import 'package:minesweeper/ms_game_body.dart';

class MSGame extends StatelessWidget {
  const MSGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: MSGameBody(),
      ),
    );
  }
}
