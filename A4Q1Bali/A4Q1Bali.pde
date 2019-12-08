// Jaivir Bali (7775370)
// A3Q2
float eyeX = 1, eyeY = 2, eyeZ = 0, centerX = 0, centerY = 1, centerZ = -2, upX = 0, upY = 1, upZ = 0;
boolean perspective = true;  //toggle between perspective 1 and 2


int currKey = 0;
int nextKey = 0;

boolean t0 = true;
float t = 0;
int t0time;
float tmod = 0;
//float tdelta = 0;
  
float x, y, z, angle;
boolean currLerping = false;  //don't want to cancel animation while lerping



int testKey = 1;

float[] shipXkeys = {-2.5, -1.5, -0.5};
int shipX = 1;
float shipY = 0.25;
int shipZ = 0;
float[] shipZkeys = {0.5, 1.5};

float[][] keys = {
  { -1.5,0.25,0, 0, 0, -PI/2, 0, 0 },    //***special middle of table (half height of base move up)
  { -0.5,0.25,0.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special top right
  { -1.5,0.25,0.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special top middle
  { -2.5,0.25,0.5, PI/2, 0, 0, PI, PI },                    //***special top left
  { -0.5,0.25,1.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom right
  { -1.5,0.25,1.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom middle
  { -2.5,0.25,1.5, PI/2, 0, 0, PI, PI },                    //***special bottom left
  { -1,0.25,-5, (3*PI)/4, -PI/4, 0, PI/2, PI/3 },    //***special top right edge of table
  { -3,0.25,-5, PI, 0, -PI/4, 0, PI/4 },    //***special top left edge of table
};


void setup() {
  size(640, 640, P3D);
  hint(DISABLE_OPTIMIZED_STROKE);
  setView0();
}

void draw() {
  clear();
  resetMatrix();
  
  if (t0) {
    t0time = millis();
  }
  
  if(perspective){
    ortho(-1, 1, 1, -1, 2, 10);
  }else{
    frustum(-1, 1, 1, -1, 2, 10);
  }
  
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ); //set the camera position
  
  translate(defaultTranslateX, defaultTranslateY, defaultTranslateZ); //move everything back so its viewable
  
  //Axis for testing purposes (commented out)
  strokeWeight(1.0);
  beginShape(LINES);
  stroke(255,0,0);  //x
  vertex(-2,0,0);
  vertex(2,0,0);
  stroke(0,255,0);  //y
  vertex(0,-2,0);
  vertex(0,2,0);
  stroke(0,0,255);  //z
  vertex(0,0,-2);
  vertex(0,0,2);
  endShape();

  
  stroke(255);
  scale(0.2,0.2,0.2); //set the scene size
   
   //Origin for testing purposes (commented out)
  fill(255);  //origin
  sphere(0.1);
  
  
  //Drawing stuff now
  pushMatrix();  //start scene
  strokeWeight(2.5);
 
  //TABLE
  pushMatrix();  //start table
  
  fill(60);
  float tableWidth = 3.0;
  float tableHeight = 0.5;
  float tableLength = 40.0;  //max +3 in frustrum, need max +6 for ortho, need min 21 (42 middle. 40 test)

  
  if (t < 1.10) {
    tmod = t - ((t*100.0 % 10.0) / 100.0);
  }
  println("tmod = "+ tmod);
  println("t = "+ t);
  //println("tdelta = " + tdelta);
  
  z = lerp(keys[0][2], 10.0, tmod);
  //z = keys[0][2];
  translate(keys[0][0], keys[0][1] - tableHeight, z);  //table moves
  
  box(tableWidth, tableHeight, tableLength);  //table
  
  popMatrix();  //end table
  
  
  //BASE
  pushMatrix();  //start base
  fill(0,0,200);
  
  //x = keys[testKey][0];   //lerp(keys[currKey][0], keys[nextKey][0], t);
  //y = keys[testKey][1];   //lerp(keys[currKey][1], keys[nextKey][1], t);
  //z = keys[testKey][2];   //lerp(keys[currKey][2], keys[nextKey][2], t);
  
  x = shipXkeys[shipX];   //lerp(keys[currKey][0], keys[nextKey][0], t);
  y = shipY;              //lerp(keys[currKey][1], keys[nextKey][1], t);
  z = shipZkeys[shipZ];   //lerp(keys[currKey][2], keys[nextKey][2], t);
  translate(x, y, z);
  
  //angle = lerp(keys[currKey][3], keys[nextKey][3], t);
  //rotateY(angle);  //do Y axis rotation for base (***special default of 0) --> -PI (CW) to +PI (CCW)

  float baseWidth = 1.0;
  float baseHeight = 0.5;
  float baseLength = 1.0;
  box(baseWidth, baseHeight, baseLength);  //base
  popMatrix();  //end base
  
  popMatrix();  //end scene stuff
  
  
  t  = (millis() - t0time) / 10000.0;
  if (t >= 1.10) {
    t = 0;       //set to 0 to reset, set to 1 to make it stay at end
    tmod = 0;
    t0 = true;  //set to false to make it stop at end, normally set to true
  } else {
    t0 = false;
  }
} //<>//

float defaultTranslateX = -0.70;
float defaultTranslateY = -0.5;
float defaultTranslateZ = -2.5;

void keyPressed() {
  switch(key) {
    case ' ':      //default perspective
      perspective = !perspective;
      
      if (perspective == true) {
        defaultTranslateX = -0.70;
        defaultTranslateY = -0.5;
        defaultTranslateZ = -2.5;
        setView0();
      } else {
        perspective = false;
        defaultTranslateX = 0.33;
        defaultTranslateY = -0.1;
        defaultTranslateZ = -1.5;
        setView1();
      }
      break;
    case 'w':      //bottom left
      shipZ = 0;
      break;
    case 's':      //bottom left
      shipZ = 1;
      break;
    case 'a':      //bottom left
      if (shipX > 0) {
        shipX--;
      }
      break;
    case 'd':      //bottom left
      if (shipX < 2) {
        shipX++;
      }
      break;
  } //end switch statement
} //end keypressed function

  
void setView0() {
  eyeX = 2;
  eyeY = 4;
  eyeZ = 0;
  centerX = 0;
  centerY = 1;
  centerZ = -2;
  upX = 0; 
  upY = 1;
  upZ = 0;
}

void setView1() {
  eyeX = 0;
  eyeY = 1;
  eyeZ = 1;
  centerX = 0;
  centerY = 0;
  centerZ = -10;
  upX = 0; 
  upY = 1;
  upZ = 0;
}
