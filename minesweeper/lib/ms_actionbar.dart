import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minesweeper/ms_actionbar_text.dart';
import 'package:minesweeper/ms_controller.dart';
import 'package:minesweeper/ms_timer.dart';

class MSActionBar extends StatelessWidget {
  final MSController controller;
  final Function() reset;

  const MSActionBar({
    required this.controller,
    required this.reset,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Colors.purple,
      child: Row(
        children: [
          MSTimer(controller: controller),
          const SizedBox(
            width: 5,
          ),
          MSActionBarText(
            '${controller.flagCount}',
            FontAwesomeIcons.flag,
          ),
          const Expanded(
            child: SizedBox.shrink(),
          ),
          if (!controller.helpShown)
            GestureDetector(
              child: MSActionBarText(
                'Hint (${controller.remainingHelp})',
                FontAwesomeIcons.info,
              ),
              onTap: () => controller.help(),
            ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.sync,
              color: Colors.white,
            ),
            onPressed: reset,
          ),
        ],
      ),
    );
  }
}
