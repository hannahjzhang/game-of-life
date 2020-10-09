class Cell {
  public int col;
  public int row;
  
  private boolean amAlive = false;  // cell starts dead by default
  private int neighbors = 0;        // neighbors yet to be counted
  private final color DEAD_COLOR = color(#E8E8E8);
  private final color ALIVE_COLOR = color(#FF6600);
  
  public Cell(int row, int col) {
    this.col = col;
    this.row = row;
  }
  
  public void toggleAlive() { amAlive = !amAlive; }
  public void setAlive(boolean alive) { amAlive = alive; }
  public boolean isAlive() { return amAlive; }
  
  public void display(int xoffset, int yoffset, int w, int h) {
    xoffset += (w+1) * col;
    yoffset += (h+1) * row;
    color fillColor = amAlive ? ALIVE_COLOR : DEAD_COLOR;
    fill(fillColor);
    rect(xoffset, yoffset, w, h);
  }
    
  // Set this cell to alive or dead based on current state
  // of amAlive and the number of live neighbors
  public void updateAlive() {
    // Try to figure out an expression using Boolean operator(s) such
    // as && and || along with neighbor count and current alive/dead state
    // to solve this without using if/else
    
    setAlive((isAlive() && (neighbors == 2 || neighbors == 3)) ||
              (!isAlive() && neighbors == 3));
  }
  
  // Compute the number of live neighbors for this cell 
  // and return that number
  public int calculateNeighbors() {
    
    int total = 0;
    
    if (row - 1 >= 0)
    {
      if (col - 1 >= 0 && cell[row - 1][col - 1].isAlive())
        total += 1;

      if (cell[row - 1][col].isAlive())
        total += 1;
      
      if (col < COLS - 1 && cell[row - 1][col + 1].isAlive())
        total += 1;
    }
    
    if (col - 1 >= 0 && cell[row][col - 1].isAlive())
      total += 1;
    if (col < COLS - 1 && cell[row][col + 1].isAlive())
      total += 1;
     
    if (row < ROWS - 1)
    {
      if (col - 1 >= 0 && cell[row + 1][col - 1].isAlive())
        total += 1;
        
      if (cell[row + 1][col].isAlive())
         total += 1;
         
      if (col < COLS - 1 && cell[row + 1][col + 1].isAlive())
        total += 1;
    }
       
     neighbors = total;
     return neighbors;
    
  }
}
