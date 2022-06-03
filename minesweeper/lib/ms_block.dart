import 'package:flutter/material.dart';
import 'package:minesweeper/ms_controller.dart';

class MSBlock extends StatefulWidget {
  final MSController controller;
  const MSBlock({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _MSBlockState createState() => _MSBlockState();
}

class _MSBlockState extends State<MSBlock> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
