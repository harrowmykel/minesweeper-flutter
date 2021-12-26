import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minesweeper/ms_actionbar_text.dart';
import 'package:minesweeper/ms_controller.dart';

class MSTimer extends StatefulWidget {
  final MSController controller;

  const MSTimer({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _MSTimerState createState() => _MSTimerState();
}

class _MSTimerState extends State<MSTimer> {
  @override
  void initState() {
    widget.controller.setTimerStateFn(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MSActionBarText(
      widget.controller.timeFormatted,
      FontAwesomeIcons.clock,
    );
  }
}
