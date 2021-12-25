import 'dart:math';

class MSController {
  int seconds = 0;
  List<List<MSBoxItem>> _boxes = [];
  bool _boardSetUp = false;
  bool _minesSetUp = false;

  final Function() _setStateFn;
  final MSDifficulty difficulty;

  MSController(
    this._setStateFn, {
    this.difficulty = MSDifficulty.beginner,
  });

  String get timeFormatted {
    return "00:00";
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
    if (difficulty == MSDifficulty.intermediate) return 90;
    if (difficulty == MSDifficulty.expert) return 40;
    return 10;
  }

  int get _totalFlagCount {
    if (difficulty == MSDifficulty.intermediate) return 30;
    if (difficulty == MSDifficulty.expert) return 20;
    return 10;
  }

  int get flagCount {
    if (!_boardSetUp) _setUpBoard();
    int flaggedBox = 0;
    for (int j = 0; j < boardHeight; j++) {
      for (int i = 0; i < boardWidth; i++) {
        if ((_boxes[j][i]).state == MSBoxState.flagged) {
          flaggedBox++;
        }
      }
    }
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

    MSBoxItem? box = getBox(position);
    if (box == null) {
      return;
    }
    if (box.hasMine) {
      //has mine @TODO
    }
    box.state = MSBoxState.opened;
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
    if (box.state == MSBoxState.opened || flagCount == 0) {
      return;
    }
    box.state = box.state == MSBoxState.flagged
        ? MSBoxState.unflagged
        : MSBoxState.flagged;
    _setStateFn();
  }

  void _setUpBoard() {
    if (_boardSetUp) return;
    _boxes = [];
    int index = 0;
    for (int j = 0; j < boardHeight; j++) {
      _boxes.add([]);
      for (int i = 0; i < boardWidth; i++) {
        _boxes[j].add(
          MSBoxItem(
            index: index,
            position: MSBoxPosition(i, j),
            state: MSBoxState.opened,
          ),
        );
        index++;
      }
    }

    _boardSetUp = true;
  }

  void _setUpMines(MSBoxPosition position) {
    if (_minesSetUp) return;

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

  void reset() {
    _boxes = [];
    _boardSetUp = false;
    _minesSetUp = false;
    _setStateFn();
  }
}

enum MSBoxState { opened, flagged, unflagged }

enum MSDifficulty { beginner, intermediate, expert }

class MSBoxItem {
  MSBoxState state;
  bool hasMine = false;
  MSBoxPosition position;
  int index;
  int neighbourMineCounts = 0;

  MSBoxItem({
    this.state = MSBoxState.unflagged,
    required this.position,
    this.index = 0,
  });

  String get value {
    return hasMine ? 'B' : '$neighbourMineCounts';
  }
}

class MSBoxPosition {
  final int x;
  final int y;

  const MSBoxPosition(this.x, this.y);
}
