int screen_width = 800;
int screen_length = 800;

float[] ball_space = {};
int[] red_col = {};
int[] green_col = {};
int[] blue_col = {};
float[] row_limits;

int height_from_top = 0;
int top_distance = 0;

int last_row;

float sectionWidth;
float sectionEnd;

int num_of_balls = 0;

void setup() {
  size(800, 800);
  String[] ballData = loadStrings("Ball_Info.txt");
  num_of_balls = int(ballData[0]);
  int[][] circleData = new int[4][num_of_balls];
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
  //sectionEnd = sectionWidth*(num_of_balls); //multiply by the amount of balls 

  // print the grid for the circles

  // extracted ball data already, that is why start is zero
  for (int row=0; row < circleData.length; row++) {
    red_col = append(red_col, circleData[row][0]);
    green_col = append(green_col, circleData[row][1]);
    blue_col = append(blue_col, circleData[row][2]);
    ball_space = append(ball_space, circleData[row][3]);
  }


/*
  // extracted ball data already
  int[][] possible_ranges = new int[4][4]; 
  // this sets the possible ranges for the x and y
  // x1, y1, x2, y2 for every row

  for (int row_in_grid = 0; row_in_grid < ball_space.length; row_in_grid++) {
    for (int element = 0; element < ball_space.length; element++) {
      if (element == 0) {
        sectionWidth
      } 
      else if () {
        height_from_top
      }
      
      else if () {

      }
      
      else if () {

      }sectionEnd, height_from_top};
      possible_ranges[row_in_grid] = append(possible_ranges, row_limits);
    } 
  }
  printArray(possible_ranges);
*/
  last_row = ball_space.length - 1;
}

void draw() {
  height_from_top = 0;
  top_distance = 0;
  
  for (int row = 0; row < ball_space.length; row++) {
    height_from_top += ball_space[row];

    // i is the number of balls in a row
    if (row < last_row) {
      for (int i = 1; i < (num_of_balls+1); i++) {
        for (int lower_row_col = 1; lower_row_col < (num_of_balls+1); lower_row_col++) {
        PVector coord_pair = new PVector(i*sectionWidth + dragged, height_from_top);
        strokeWeight(1);
        stroke(255);
        line(coord_pair.x, coord_pair.y, lower_row_col*sectionWidth, height_from_top + ball_space[row+1]);
        
        }
      }
    }

    else if (row == last_row) {
      for (int back_track = 0; back_track < ball_space.length; back_track++) {
      // back_track to create circles on the lines
      int currentRed = red_col[back_track];
      int currentGreen = green_col[back_track];
      int currentBlue = blue_col[back_track];
      top_distance += ball_space[back_track];

      for (int i = 1; i < (num_of_balls+1); i++) {
        fill(currentRed,currentGreen,currentBlue);
        strokeWeight(0);
        circle(i*sectionWidth, top_distance, 25.0);
        }
      }
    }
  }
}




void mouseDragged() {
  // a for loop that checks through the possible y-value ranges for the mouse
  // if the mouseY is within the range of one of the embedded arrays,
  // change height_from_top
  // and create an addition for the x coordinate of the lines and circles alike



}

