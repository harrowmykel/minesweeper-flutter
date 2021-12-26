enum MSBoxState { opened, flagged, unflagged }

enum MSDifficulty { beginner, intermediate, expert }
enum MSGameState { won, failed, ingame }

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
    if (hasMine) return 'B';
    if (hasNoNeighbourMine) return '';

    return '$neighbourMineCounts';
  }

  bool get hasNoNeighbourMine {
    return neighbourMineCounts == 0 && !hasMine;
  }

  bool get isOpened {
    return state == MSBoxState.opened;
  }

  bool get isFlagged {
    return state == MSBoxState.flagged;
  }

  void open() {
    state = MSBoxState.opened;
  }

  void close() {
    state = MSBoxState.unflagged;
  }

  void toggleFlag() {
    state = isFlagged ? MSBoxState.unflagged : MSBoxState.flagged;
  }
}

class MSBoxPosition {
  final int x;
  final int y;

  const MSBoxPosition(this.x, this.y);
}
