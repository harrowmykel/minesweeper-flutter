import 'package:flutter/material.dart';

class MSController {
  int seconds = 0;
  int mineCount = 0;
  int _totalFlagCount = 0;
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
    if (difficulty == MSDifficulty.Intermediate) {
      return 16;
    }
    if (difficulty == MSDifficulty.Expert) {
      return 16;
    }
    return 10;
  }

  int get boardHeight {
    if (difficulty == MSDifficulty.Intermediate) {
      return 16;
    }
    if (difficulty == MSDifficulty.Expert) {
      return 30;
    }
    return 10;
  }

  int get flagCount {
    if (!_boardSetUp) _setUpBoard();
    int flaggedBox = 0;
    for (MSBoxItem element in _boxes) {
      if (element.state == MSBoxState.Flagged) {
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
    mineCount = 10;
    _totalFlagCount = 10;
    if (difficulty == MSDifficulty.Intermediate) {
      mineCount = 90;
      _totalFlagCount = 30;
    }
    if (difficulty == MSDifficulty.Expert) {
      mineCount = 40;
      _totalFlagCount = 20;
    }

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
    mineCount = 12;
    _minesSetUp = true;
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

  MSBoxItem({
    this.state = MSBoxState.Unflagged,
    required this.position,
    this.index = 0,
  });

  String get value {
    return '0';
  }
}

class MSBoxPosition {
  final int x;
  final int y;

  const MSBoxPosition(this.x, this.y);
}
