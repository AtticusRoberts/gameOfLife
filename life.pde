Cell[][] grid;
Boolean[][] tempGrid;
int gridSize;
Boolean globalState, debug;
void setup() {
  size(1000,1000);
  background(255);
  
  globalState = false;
  debug = false; 
  
  gridSize = 50;
  grid = new Cell[gridSize][gridSize];
  tempGrid = new Boolean[gridSize][gridSize];
  for (int i=0;i<gridSize;i++) {
    for (int j=0;j<gridSize;j++) {
      grid[i][j] = new Cell(false, i, j);
      tempGrid[i][j] = false;
      stroke(0);
      fill(255);
      rect(i*width/gridSize,j*width/gridSize,width/gridSize,height/gridSize);
    }
  }
  
  println("Space to toggle editing mode (turned on initially)");
  println("Any other key to toggle debug mode (turned off initially)");
}
void draw() {
  background(255);
  updateTemp();
  for (int i=0;i<gridSize;i++) {
    for (int j=0;j<gridSize;j++) {
      if (globalState==true ) grid[i][j].update();
      else grid[i][j].display();
    }
  }
  if (globalState==true) delay(100);
}

void keyPressed() {
  if (key==32) { //Space
    globalState=!globalState;
    if (globalState) println("Editing mode off");
    else print ("Editing mode on");
  }
  else {
    debug=!debug;
    if (debug) println("Debug mode on");
    else println ("Debug mode off");
  } //d
}

void mouseClicked() {
  int x = int(mouseX/(width/gridSize));
  int y = int(mouseY/(height/gridSize));
  if (globalState == false && debug == false) {
    grid[x][y].overwrite(!grid[x][y].state);
    updateTemp();
  }
  else if (globalState == false && debug == true) 
  {
    println(grid[x][y].census());
  }
}

void updateTemp() {
  for (int i=0;i<gridSize;i++) {
    for (int j=0;j<gridSize;j++) {
      tempGrid[i][j]=grid[i][j].state;
    }
  }
}

class Cell {
  Boolean state;
  int x, y;
  Cell(Boolean initial, int a, int b) {
    this.state = initial;
    this.x = a;
    this.y = b;
  }
  
  void update() {
    int census = this.census();

    if (census<2) this.state = false;
    else if (census == 3) this.state = true;
    else if (census > 3) this.state = false;
    
    this.display();
  }
  
  void display() {
    fill(255,0,0);
    if (this.state==true) fill(0);
    else fill(255);
    rect(x*width/gridSize,y*height/gridSize,width/gridSize,height/gridSize);
  }
  
  void overwrite(Boolean s) {
    this.state = s;
  }
  
  int census() {
    int census = 0;
    for (int i=-1;i<2;i++) {
      for (int j=-1;j<2;j++) {
        if (this.x+i>-1 && this.y+j>-1 && this.x+i<gridSize && this.y+j<gridSize) {
          if (tempGrid[this.x+i][this.y+j]) {
            census++;
          }
        }
      } 
    }
    if (this.state==true) census--;
    return(census);
  }
}
