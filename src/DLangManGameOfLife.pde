float CELL_SIZE = 20;
int DURATION_FRAME_COUNT = 40;

CellManager manager;

void setup() {
  size(600, 600);
  imageMode(CENTER);
  rectMode(CENTER);
  cellImage = loadImage("images/d-man.gif");
  manager = new CellManager(floor(width/CELL_SIZE), floor(width/CELL_SIZE), CELL_SIZE, DURATION_FRAME_COUNT);
  refresh();
}

void refresh() {
  manager.refresh();
}

void kill() {
  manager.kill();
}

void draw() {
  background(255);
  manager.update();
  manager.draw();
}

void flipActive() {
  if (!manager.isActive()) {
    manager.revive();
  }
  manager.flipActive();
}

void keyPressed() {
  if (key==' ') {
    flipActive();
  }
  if (keyCode == ENTER) {
    if (manager.isActive()) {
      kill();
    } else {
      refresh();
    }
  }
}

float mix(float x, float y, float t) {
  return x*(1-t) + y*t;
}
