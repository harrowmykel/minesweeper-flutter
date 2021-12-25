import 'dart:math';

import 'package:flutter/material.dart';

class MSController {
  int seconds = 0;
  List<MSBoxItem> _boxes = [];
  bool _boardSetUp = false;
  bool _minesSetUp = false;

  final Function() _setStateFn;
  final MSDifficulty difficulty;

  MSController(
    this._setStateFn, {
    this.difficulty = MSDifficulty.Beginner,
  });

  String get timeFormatted {
    return "00:00";
  }

  int get boardItemsCount {
    return boardHeight * boardWidth;
  }

  int get boardWidth {
    if (difficulty == MSDifficulty.Intermediate) return 16;
    if (difficulty == MSDifficulty.Expert) return 16;
    return 10;
  }

  int get boardHeight {
    if (difficulty == MSDifficulty.Intermediate) return 16;
    if (difficulty == MSDifficulty.Expert) return 30;
    return 10;
  }

  int get mineCount {
    if (difficulty == MSDifficulty.Intermediate) return 90;
    if (difficulty == MSDifficulty.Expert) return 40;
    return 10;
  }

  int get _totalFlagCount {
    if (difficulty == MSDifficulty.Intermediate) return 30;
    if (difficulty == MSDifficulty.Expert) return 20;
    return 10;
  }

  int get flagCount {
    if (!_boardSetUp) _setUpBoard();
    int flaggedBox = 0;
    for (var i = 0; i < boardItemsCount; i++) {
      if ((_boxes[i]).state == MSBoxState.Flagged) {
        flaggedBox++;
      }
    }
    return (_totalFlagCount - flaggedBox);
  }

  MSBoxItem getBox(int boxIndex) {
    if (boxIndex < _boxes.length) return _boxes[boxIndex];

    return MSBoxItem(
      position: const MSBoxPosition(0, 0),
    );
  }

  void onBoxClick(int boxIndex) {
    if (!_minesSetUp) _setUpMines(boxIndex);
    MSBoxItem box = getBox(boxIndex);
    if (box.hasMine) {
      //has mine @TODO
    }
    box.state = MSBoxState.Opened;
    _setStateFn();
  }

  void toggleFlag(int boxIndex) {
    if (!_minesSetUp) {
      onBoxClick(boxIndex);
      return;
    }
    MSBoxItem box = getBox(boxIndex);
    if (box.state == MSBoxState.Opened || flagCount == 0) {
      return;
    }
    box.state = box.state == MSBoxState.Flagged
        ? MSBoxState.Unflagged
        : MSBoxState.Flagged;
    _setStateFn();
  }

  void _setUpBoard() {
    if (_boardSetUp) return;
    _boxes = [];
    int index = 0;
    for (int i = 0; i < boardWidth; i++) {
      for (int j = 0; j < boardHeight; j++) {
        _boxes.add(
          MSBoxItem(
            index: index,
            position: MSBoxPosition(i, j),
          ),
        );
        index++;
      }
    }

    _boardSetUp = true;
  }

  void _setUpMines(int exceptIndex) {
    int count = mineCount;
    int bCount = boardItemsCount;

    Random random = Random();
    List<int> numberList = [];

    for (int i = 0; i == count; i++) {
      int rand = random.nextInt(bCount);
      while (numberList.contains(rand) || rand == exceptIndex) {
        rand = random.nextInt(bCount);
      }
      _boxes[rand].hasMine = true;
    }

    for (int i = 0; i == bCount; i++) {
      int neighbourMineCounts = 0;
      MSBoxItem box = getBox(i);
      int boxX = box.position.x;
      int boxY = box.position.y;
      for (int x = boxX - 1; x < boxX + 2; x++) {
        if (x < 0 || x > boardWidth) {
          continue;
        }
        for (int y = boxY - 1; y < boxY + 2; y++) {
          if (y < 0 || y > boardHeight) {
            continue;
          }
          if (posHasMine(x, y)) {
            neighbourMineCounts++;
            _boxes[bCount].neighbourMineCounts = neighbourMineCounts;
          }
        }
      }
    }

    _minesSetUp = true;
  }

  bool posHasMine(int x, int y) {
    return false;
  }

  void reset() {
    _boxes = [];
    _boardSetUp = false;
    _minesSetUp = false;
    _setStateFn();
  }
}

enum MSBoxState { Opened, Flagged, Unflagged }

enum MSDifficulty { Beginner, Intermediate, Expert }

class MSBoxItem {
  MSBoxState state;
  bool hasMine = false;
  MSBoxPosition position;
  int index;
  int neighbourMineCounts = 0;

  MSBoxItem({
    this.state = MSBoxState.Unflagged,
    required this.position,
    this.index = 0,
  });

  String get value {
    return '$neighbourMineCounts';
  }
}

class MSBoxPosition {
  final int x;
  final int y;

  const MSBoxPosition(this.x, this.y);
}
