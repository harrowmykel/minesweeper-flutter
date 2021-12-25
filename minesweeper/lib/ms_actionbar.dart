import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minesweeper/ms_actionbar_text.dart';
import 'package:minesweeper/ms_controller.dart';

class MSActionBar extends StatelessWidget {
  final MSController controller;
  const MSActionBar({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.purple,
      child: Row(
        children: [
          MSActionBarText(
            controller.timeFormatted,
            FontAwesomeIcons.clock,
          ),
          const SizedBox(
            width: 70,
          ),
          MSActionBarText(
            '${controller.flagCount}',
            FontAwesomeIcons.flag,
          ),
          const Expanded(
            child: SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.sync,
              color: Colors.white,
            ),
            onPressed: () => controller.reset(),
          ),
        ],
      ),
    );
  }
}
