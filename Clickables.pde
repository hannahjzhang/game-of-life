// GENERAL NOTES
// The purpose of using mousePressed() and mouseReleased() instead of
// mouseClicked() is to adhere to the idea that confirmation of a clicked
// button should include a release over the button as well. This is fairly
// standard in the behavior of SUBMIT buttons in web browsers.
//
// The strategy for handling button events is to gather information about
// where a mouse was pressed and released and only if the two align is a
// button action actually taken.

// When a non-button is clicked, use -1 to indicate none selected
int mousex = -1;
int mousey = -1;
// clickedRow and clickedCol are an integrity check to make sure that
// the user truly intends to toggle a particular cell.  The cell where
// the mouse was pressed needs to be the same as the cell where the
// mouse was released in order for a toggle to happen.
int clickedRow = -1;
int clickedCol = -1;
// Grid constants for figuring out which cell has been clicked
int GRID_X_MIN = LEFT_OFFSET;
int GRID_Y_MIN = TOP_OFFSET;
int GRID_X_MAX = GRID_X_MIN + COLS*(CELL_WIDTH+1);
int GRID_Y_MAX = GRID_Y_MIN + ROWS*(CELL_HEIGHT+1);

// buttonPressed, buttonReleased:
//   -1 -> None
//    0 -> Start/Stop
//    1 -> Step
//    2 -> Clear
int buttonSelected = -1;
int buttonReleased = -1;

// mousePressed() is being used to store information about the location of
// the mouse click.  If it is in the grid, then the cell being selected is stored.
// If it is on a button, then the button selected is being stored.
void mousePressed() {
  // If click was on grid, collect the cell coordinates within the grid
  if (between(mouseX, GRID_X_MIN, GRID_X_MAX) && between(mouseY, GRID_Y_MIN, GRID_Y_MAX)) {
    // Identify cell to toggle
    clickedRow = (mouseY-GRID_Y_MIN) / (CELL_HEIGHT+1);
    clickedCol = (mouseX-GRID_X_MIN) / (CELL_WIDTH+1);
  } else {
    buttonSelected = -1;
    for (int i = 0; i < 4; i++) {
      if (between(mouseX, LEFT_OFFSET+i*(BUTTON_WIDTH+12), LEFT_OFFSET+i*(BUTTON_WIDTH+12) + BUTTON_WIDTH) &&
          between(mouseY, BUTTON_Y_OFFSET, BUTTON_Y_OFFSET+BUTTON_HEIGHT)) {
            mousex = mouseX;
            mousey = mouseY;
            // 0: Start/Stop, 1: Step, 2: Clear
            buttonSelected = i;
          } 
    }
  }
  // println("Pressed: (" + mouseX + ", " + mouseY + "), " + buttonSelected);
}

void mouseReleased() {
  // buttonReleased determines if a button was clicked
  // Must set to -1 here as if not, do not want state change
  buttonReleased = -1;

  // If the click was on the grid, toggle the appropriate cell
  if (between(mouseX, GRID_X_MIN, GRID_X_MAX) && between(mouseY, GRID_Y_MIN, GRID_Y_MAX)) {
    // Identify cell to toggle
    int row = (mouseY-GRID_Y_MIN) / (CELL_HEIGHT+1);
    int col = (mouseX-GRID_X_MIN) / (CELL_WIDTH+1);
    if (row == clickedRow && col == clickedCol) {
      cell[row][col].toggleAlive();
    }
  } else {  // Figure out if a button was clicked and, if so, which one
    int x = -1;
    int y = -1;
    for (int i = 0; i < 4; i++) {
      if (between(mouseX, LEFT_OFFSET+i*(BUTTON_WIDTH+12), LEFT_OFFSET+i*(BUTTON_WIDTH+12) + BUTTON_WIDTH) &&
          between(mouseY, BUTTON_Y_OFFSET, BUTTON_Y_OFFSET+BUTTON_HEIGHT)) {
            x = mouseX;
            y = mouseY;
            buttonReleased = i;
          } 
    }
    println("Released: (" + x + ", " + y + "), " + buttonReleased);
  }

  if (buttonSelected == buttonReleased && buttonReleased >= 0) {
    switch (buttonSelected) {
      // Button 0: Start/Stop
      case 0: 
        // If state is RUNNING, then the animation is active and the button says Stop.
        // Otherwise it is inactive and the button says Start.  Swap states.
        state = (state == STATE.RUNNING) ? STATE.STOPPED : STATE.RUNNING;
        break;
      // Button 1: Step
      case 1: 
        state = STATE.STEPPING;
        break;
      // Button 2: Clear
      case 2:
        state = STATE.STOPPED;
        clear();
        break;
      // EXTRA EXTENSION: Button 3: Switch (switches starting pattern)
      case 3:
        state = STATE.STOPPED;
        clear();
        randomize();
        break;
      // This line of code should not be reached as only states 0, 1, and 2 exist
      default: 
        state = STATE.STOPPED;
        break;
    }
  }    
}

// Clears all cells (sets them to dead state)
void clear() {
  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      cell[r][c].setAlive(false);
    }
  }
}
