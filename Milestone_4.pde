int screen_width = 800;
int screen_length = 800;

float[] ball_space = {};
int[] red_col = {};
int[] green_col = {};
int[] blue_col = {};
float[] row_limits;

float height_from_top = 0.0;
float top_distance = 0.0;

int CIRCLE_WIDTH = 50;
int PIXEL_RANGE = 2*CIRCLE_WIDTH;

int last_row;

float sectionWidth;
float sectionEnd;

int num_of_balls = 0;

int row_to_change = 0;

float[][] possible_ranges;
int row_num;

float dragged_x = 0.0;
float dragged_y = 0.0;

PVector[][] coord_circle_pairs; // nested array containing the coordinate information for the circles

void setup() {
  size(800, 800);
  String[] ballData = loadStrings("Ball_Info.txt");
  num_of_balls = int(ballData[0]);
  row_num = (ballData.length - 1);
  int[][] circleData = new int[row_num][num_of_balls];
  for (int row_num=1; row_num < (ballData.length); row_num++) {
    // make an array of the data
    String thisRow = ballData[row_num];
    for (int col = 0; col < 4; col++) {
      int[] col_vals = int(split(thisRow, " "));
      //printArray(col_vals);
      circleData[row_num-1][col] = int(col_vals[col]);
    }
  }
  
  sectionWidth = (screen_width/(num_of_balls+1));
  sectionEnd = sectionWidth*(num_of_balls); //multiply by the amount of balls 

  possible_ranges = new float[row_num][4];

  // print the grid for the circles

  // extracted ball data already, that is why start is zero
  for (int row=0; row < circleData.length; row++) {
    red_col = append(red_col, circleData[row][0]);
    green_col = append(green_col, circleData[row][1]);
    blue_col = append(blue_col, circleData[row][2]);
    ball_space = append(ball_space, circleData[row][3]);
  }


  // extracted ball data already 
  // this sets the possible ranges for the x and y
  // x1, y1, x2, y2 for every row

  for (int row_in_grid = 0; row_in_grid < row_num; row_in_grid++) {
    height_from_top += ball_space[row_in_grid];
    for (int element = 0; element < 4; element++) {
      if (element == 0) {
        possible_ranges[row_in_grid][element] = sectionWidth;
      } 
      else if (element == 1) {
        possible_ranges[row_in_grid][element] = height_from_top - CIRCLE_WIDTH;
      }
      
      else if (element == 2) {
        possible_ranges[row_in_grid][element] = sectionEnd;
      }
      
      else if (element == 3) {
        possible_ranges[row_in_grid][element] = height_from_top;
      }
    }
    printArray(possible_ranges[row_in_grid]);
  }
  last_row = ball_space.length - 1;

  coord_circle_pairs = new PVector[row_num][num_of_balls];
  printArray(coord_circle_pairs[1]);


  for (int row = 0; row < ball_space.length; row++) {
    // back_track to create circles on the lines
    top_distance += ball_space[row];
    for (int column_multiplier = 1; column_multiplier < (num_of_balls+1); column_multiplier++) {
      coord_circle_pairs[row][column_multiplier - 1] = new PVector(column_multiplier*sectionWidth, top_distance);
    }
    printArray(coord_circle_pairs[row]);
  }
}


void draw() {
  background(255);
  height_from_top = 0.0;
  top_distance = 0.0;
  
  for (int row = 0; row < row_num; row++) {
    height_from_top += ball_space[row];
    stroke(0);

    // i is the number of balls in a row
    if (row < last_row) {
      for (int upper_col = 0; upper_col < num_of_balls; upper_col++) {
        PVector first_coord = coord_circle_pairs[row][upper_col];
        for (int lower_row_col = 0; lower_row_col < num_of_balls; lower_row_col++) {
          PVector second_coord = coord_circle_pairs[row+1][lower_row_col];
          stroke(0);
          strokeWeight(2);
          line(first_coord.x, first_coord.y, second_coord.x, second_coord.y);
        }
      }
    }

    else if (row == last_row) {
      for (int back_track = 0; back_track < row_num; back_track++) {
      // back_track to create circles on the lines
      int currentRed = red_col[back_track];
      int currentGreen = green_col[back_track];
      int currentBlue = blue_col[back_track];

        for (int i = 0; i < (num_of_balls); i++) {
          PVector first_coord = coord_circle_pairs[back_track][i];
          fill(currentRed,currentGreen,currentBlue);
          strokeWeight(0);
          circle(first_coord.x, first_coord.y, CIRCLE_WIDTH);
        }
      }
    }
  }
}

boolean proper_clicked = false;

float original_mouse_x;
float original_mouse_y;

void mousePressed() {
  original_mouse_x = mouseX;
  original_mouse_y = mouseY;
  println("original_mouse_x", original_mouse_x);
  println("original_mouse_y", original_mouse_y);

  for (int row = 0; row < (last_row + 1); row++) {
    println("x1", possible_ranges[row][0]);
    println("y1", possible_ranges[row][1]);
    println("x2", possible_ranges[row][2]);
    println("y2", possible_ranges[row][3]);
    if (((possible_ranges[row][0] < original_mouse_x) && (original_mouse_x < possible_ranges[row][2])) && ((possible_ranges[row][1] < original_mouse_y) && (original_mouse_y < possible_ranges[row][3]))) {
      row_to_change = row;
      println("this is row_to_change: ", row_to_change);
      println("we are here");
      proper_clicked = true;
      break;
    }
  }
}


void mouseDragged() {
  // a for loop that checks through the possible y-value ranges for the mouse
  // if the mouseY is within the range of one of the embedded arrays,
  // change height_from_top
  // and create an addition for the x coordinate of the lines and circles alike
  if (proper_clicked) {
    dragged_x = mouseX - pmouseX;
    dragged_y = mouseY - pmouseY;
    //println(coord_circle_pairs[row_to_change]);
    for (int index = 0; index < (num_of_balls); index++) {
      coord_circle_pairs[row_to_change][index] = new PVector(coord_circle_pairs[row_to_change][index].x+dragged_x, coord_circle_pairs[row_to_change][index].y+dragged_y);
    }
  }
  else {}
} 

void mouseReleased() {
  proper_clicked = false;
}
