import 'dart:async';
import 'dart:math';

import 'package:minesweeper/ms_models.dart';

class MSController {
  int seconds = 0;
  List<List<MSBoxItem>> _boxes = [];
  bool _boardSetUp = false;
  bool _minesSetUp = false;
  int remainingHelp = 5;
  bool helpShown = false;

  bool openAll = false;
  bool openMines = false;
  MSGameState gamestate = MSGameState.ingame;
  int flaggedBox = 0;
  Timer? _timer;
  Function()? _timerFn;

  final Function() _setStateFn;
  MSDifficulty difficulty;

  MSController(
    this._setStateFn, {
    this.difficulty = MSDifficulty.expert,
  });

  String get timeFormatted {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final _seconds = seconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$_seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  int get boardItemsCount {
    return boardHeight * boardWidth;
  }

  int get boardWidth {
    if (difficulty == MSDifficulty.intermediate) return 16;
    if (difficulty == MSDifficulty.expert) return 16;
    return 10;
  }

  int get boardHeight {
    if (difficulty == MSDifficulty.intermediate) return 16;
    if (difficulty == MSDifficulty.expert) return 30;
    return 10;
  }

  int get mineCount {
    return (boardItemsCount ~/ 2) - 30;

    // if (difficulty == MSDifficulty.intermediate) return 90;
    // if (difficulty == MSDifficulty.expert) return 40;
    // return 10;
  }

  int get _totalFlagCount {
    return mineCount - 12;
    // if (difficulty == MSDifficulty.intermediate) return 30;
    // if (difficulty == MSDifficulty.expert) return 20;
    // return 10;
  }

  int get flagCount {
    if (!_boardSetUp) _setUpBoard();
    return (_totalFlagCount - flaggedBox);
  }

  MSBoxItem? getBox(MSBoxPosition position) {
    int x = position.x;
    int y = position.y;
    if (x < 0 || y < 0) {
      return null;
    }
    if (x >= boardWidth || y >= boardHeight) {
      return null;
    }
    return _boxes[y][x];
  }

  void onBoxClick(MSBoxPosition position) {
    if (!_boardSetUp) _setUpBoard();
    if (!_minesSetUp) _setUpMines(position);
    if (helpShown) return;

    MSBoxItem? box = getBox(position);
    if (box == null) return;
    if (box.hasMine) {
      //gameover
      _gameCompleted(MSGameState.failed);
      return;
    }
    int x = box.position.x;
    int y = box.position.y;
    openNeighboursWithNoMine(x, y);
    box.state = MSBoxState.opened;
    if (allBoxesExceptMinesOpened) {
      _gameCompleted(MSGameState.won);
    }
    _setStateFn();
  }

//check if boxes that are non mines are closed
  bool get allBoxesExceptMinesOpened {
    bool _isClosedBoxAndNotMine = false;

    for (int j = 0; j < boardHeight; j++) {
      if (_isClosedBoxAndNotMine) break;
      for (int i = 0; i < boardWidth; i++) {
        if (_isClosedBoxAndNotMine) break;
        MSBoxItem box = _boxes[j][i];
        if (!box.isOpened && !box.hasMine) {
          _isClosedBoxAndNotMine = true;
        }
      }
    }
    return !_isClosedBoxAndNotMine;
  }

  void _gameCompleted(MSGameState state) {
    helpShown = true;
    //open all
    openAll = true;
    gamestate = state;
    stopTimer();
    _setStateFn();
  }

  void help() async {
    if (remainingHelp == 0 || helpShown) return;
    if (!_boardSetUp) return;

    helpShown = true;

    openMines = true;
    remainingHelp--;
    _setStateFn();

    await Future.delayed(const Duration(seconds: 6));

    openMines = false;

    helpShown = false;
    _setStateFn();
  }

  void toggleFlag(MSBoxPosition position) {
    if (!_minesSetUp) {
      onBoxClick(position);
      return;
    }
    MSBoxItem? box = getBox(position);
    if (box == null) {
      return;
    }
    if (box.isOpened || flagCount == 0) {
      return;
    }
    if (box.isFlagged) {
      flaggedBox--;
    } else {
      flaggedBox++;
    }
    box.toggleFlag();
    _setStateFn();
  }

  void _setUpBoard() {
    if (_boardSetUp) return;
    _startTimer();

    print('board setup');
    _boxes = [];

    int index = 0;
    for (int j = 0; j < boardHeight; j++) {
      _boxes.add([]);
      for (int i = 0; i < boardWidth; i++) {
        _boxes[j].add(
          MSBoxItem(
            index: index,
            position: MSBoxPosition(i, j),
            // state: MSBoxState.opened,
          ),
        );
        index++;
      }
    }

    _boardSetUp = true;
  }

  void _setUpMines(MSBoxPosition position) {
    if (_minesSetUp) return;
    print('mine setup');

    int count = mineCount;
    int bCount = boardItemsCount;
    int exceptIndex = getBox(position)?.index ?? 0;

    Random random = Random();
    List<int> numberList = [];

    //generate rand numbers
    for (int i = 0; i < count; i++) {
      int rand = random.nextInt(bCount);
      while (numberList.contains(rand) || rand == exceptIndex) {
        rand = random.nextInt(bCount);
      }

      int y = (rand == 0) ? 0 : (rand ~/ boardWidth);
      int x = (rand == 0) ? 0 : rand % boardWidth;
      // print('$x , $y');
      _boxes[y][x].hasMine = true;
    }

    for (int j = 0; j < boardHeight; j++) {
      for (int i = 0; i < boardWidth; i++) {
        _boxes[j][i].neighbourMineCounts = _neighbourMineCounts(i, j);
      }
    }

    _minesSetUp = true;
  }

  int _neighbourMineCounts(int x, int y) {
    int _neighbourMineCounts = 0;
    List<bool> neighbors = [
      //top
      positionIsValidAndHasMine(x - 1, y - 1),
      positionIsValidAndHasMine(x, y - 1),
      positionIsValidAndHasMine(x + 1, y - 1),
      //same row
      positionIsValidAndHasMine(x - 1, y),
      positionIsValidAndHasMine(x + 1, y),
      //bottom
      positionIsValidAndHasMine(x - 1, y + 1),
      positionIsValidAndHasMine(x, y + 1),
      positionIsValidAndHasMine(x + 1, y + 1),
    ];
    for (int i = 0; i < neighbors.length; i++) {
      if (neighbors[i]) _neighbourMineCounts++;
    }
    return _neighbourMineCounts;
  }

  bool positionIsValidAndHasMine(int x, int y) {
    MSBoxItem? box = getBox(MSBoxPosition(x, y));
    return box != null && box.hasMine;
  }

  void openIfHasNoNeighbourMineAndNotFlagged(int x, int y) {
    MSBoxItem? box = getBox(MSBoxPosition(x, y));
    if (box == null) return;
    if (!box.hasNoNeighbourMine) return;
    if (box.isOpened || box.isFlagged) return;

    box.open();

    openNeighboursWithNoMine(box.position.x, box.position.y);
  }

  void openIfNotMine(int x, int y) {
    MSBoxItem? box = getBox(MSBoxPosition(x, y));
    if (box == null) return;
    if (box.hasMine) return;
    if (box.isOpened || box.isFlagged) return;
    box.open();
  }

  void openNeighboursWithNoMine(x, y) {
    //top
    openIfHasNoNeighbourMineAndNotFlagged(x - 1, y - 1);
    openIfHasNoNeighbourMineAndNotFlagged(x, y - 1);
    openIfHasNoNeighbourMineAndNotFlagged(x + 1, y - 1);
    //same row
    openIfHasNoNeighbourMineAndNotFlagged(x - 1, y);
    openIfHasNoNeighbourMineAndNotFlagged(x + 1, y);
    //bottom
    openIfHasNoNeighbourMineAndNotFlagged(x - 1, y + 1);
    openIfHasNoNeighbourMineAndNotFlagged(x, y + 1);
    openIfHasNoNeighbourMineAndNotFlagged(x + 1, y + 1);

    MSBoxItem? box = getBox(MSBoxPosition(x, y));
    if (box == null) return;
    if (!box.hasNoNeighbourMine) return;

    //top
    openIfNotMine(x - 1, y - 1);
    openIfNotMine(x, y - 1);
    openIfNotMine(x + 1, y - 1);
    //same row
    openIfNotMine(x - 1, y);
    openIfNotMine(x + 1, y);
    //bottom
    openIfNotMine(x - 1, y + 1);
    openIfNotMine(x, y + 1);
    openIfNotMine(x + 1, y + 1);
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(
        seconds: 1,
      ),
      (Timer timer) {
        seconds++;
        if (_timerFn != null) _timerFn!();
      },
    );
  }

  void setTimerStateFn(Function() timerFn) {
    _timerFn = timerFn;
  }
}
