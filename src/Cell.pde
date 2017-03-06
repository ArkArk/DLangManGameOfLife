PImage cellImage;

class Cell {
  private float x;
  private float y;
  private float cellSize;
  private boolean state;
  private boolean nextState;
  private Cell[] neighbours;
  private boolean killedFlg;

  Cell(float x, float y, float cellSize) {
    this.x = x;
    this.y = y;
    this.cellSize = cellSize;

    nextState = false;
  }

  void setNeighbours(Cell[] neighbours) {
    this.neighbours = neighbours;
  }

  void updateState() {
    state = nextState;
  }

  void calcNextState() {
    int cnt = 0;
    for(int i=0; i<neighbours.length; i++) {
      if (neighbours[i].getState()) cnt++;
    }
    if (state) {
      nextState = (cnt==3 || cnt==4);
    } else {
      nextState = (cnt==3);
    }
    if (killedFlg) {
      nextState = false;
      killedFlg = false;
    }
  }

  void draw(float t) {
    if (state) {
      int cnt = 0;
      for(int i=0; i<neighbours.length; i++) {
        if ((this==neighbours[i] || !neighbours[i].getState()) && neighbours[i].getNextState()) {
          if (abs(x-neighbours[i].x)>width/2 || abs(y-neighbours[i].y)>height/2) continue;
          float _x = mix(x, neighbours[i].x, t);
          float _y = mix(y, neighbours[i].y, t);
          image(cellImage, _x, _y, cellSize, cellSize);
          cnt++;
        }
      }
      if (cnt == 0) {
        pushMatrix();
        translate(x, y);
        rotate(t*360);
        translate(-x, -y);
        image(cellImage, x, y, cellSize*(1-t*t*t*t)+0.1, cellSize*(1-t*t*t*t)+0.1);
        popMatrix();
      }
    } else if (nextState) {
      int cnt=0;
      for(int i=0; i<neighbours.length; i++) {
        if (neighbours[i].getState()) {
          cnt++;
        }
      }
      if (cnt==0) {
        image(cellImage, x, y, cellSize*t, cellSize*t);
      }
    }
  }

  void flipState() {
    updateState();
    nextState = !nextState;

    stroke(0);
    fill(150, 200, 255, 100);
    rect(x, y, cellSize, cellSize);
  }

  void kill() {
    killedFlg = true;
  }

  void revive() {
    killedFlg = false;
  }

  boolean getState() {
    return state;
  }
  boolean getNextState() {
    return nextState;
  }
  float getX() {
    return x;
  }
  float getY() {
    return y;
  }
}
