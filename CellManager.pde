class CellManager {
  private float cellSize;
  private Cell[][] cellArray;
  private boolean active;
  private int duration;
  private int count;

  CellManager(int numX, int numY, float cellSize, int duration) {
    this.cellSize = cellSize;
    cellArray = new Cell[numX+2][numY+2];
    active = true;
    this.duration = duration;
    count = 0;
  }

  void refresh() {
    for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
      cellArray[i][j] = new Cell((i-1+0.5)*cellSize, (j-1+0.5)*cellSize, cellSize);
    }
    for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
      int[] dx = {-1, -1, -1, 0, 0, 0, 1, 1, 1};
      int[] dy = {-1, 0, 1, -1, 0, 1, -1, 0, 1};
      Cell[] neighbours = new Cell[9];
      for(int k=0; k<9; k++) {
        neighbours[k] = cellArray[(i+dx[k]+cellArray.length)%cellArray.length][(j+dy[k]+cellArray[0].length)%cellArray[0].length];
      }
      cellArray[i][j].setNeighbours(neighbours);
    }
  }

  void update() {
    updateInput();
    if (active && count>duration) {
      calcNextState();
      count = 0;
    }

    count++;
  }

  void calcNextState() {
    for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
      cellArray[i][j].updateState();
    }
    for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
      cellArray[i][j].calcNextState();
    }
  }

  void flipActive() {
    active = !active;
    if (active) {
      count = 0;
      calcNextState();
    }
  }

  int lastI = -1;
  int lastJ = -1;
  void updateInput() {
    if (mousePressed) {
      for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
        float x = cellArray[i][j].getX();
        float y = cellArray[i][j].getY();
        if (x-cellSize/2<=mouseX && mouseX<x+cellSize/2 && y-cellSize/2<=mouseY && mouseY<y+cellSize/2) {
          if (i==lastI && j==lastJ) return;
          lastI = i;
          lastJ = j;
          cellArray[i][j].flipState();
          return;
        }
      }
    } else {
      lastI = -1;
      lastJ = -1;
    }
  }

  void draw() {
    stroke(0);
    noFill();
    strokeWeight(1);
    for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
      Cell c = cellArray[i][j];
      rect(c.getX(), c.getY(), cellSize, cellSize);
    }
    float t = active ? count/float(duration) : 1.0;
    for(int i=0; i<cellArray.length; i++) for(int j=0; j<cellArray[0].length;  j++) {
      cellArray[i][j].draw(t);
    }
  }
}