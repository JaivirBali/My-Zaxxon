// Jaivir Bali (7775370)
// A3Q2
float eyeX = 1, eyeY = 2, eyeZ = 0, centerX = 0, centerY = 1, centerZ = -2, upX = 0, upY = 1, upZ = 0;
boolean perspective = true;  //toggle between perspective 1 and 2


int currKey = 0;
int nextKey = 0;
float t = 0;
float x, y, z, angle;
boolean currLerping = false;  //don't want to cancel animation while lerping

float defaultTranslateX = -0.75;
float defaultTranslateY = -0.5;
float defaultTranslateZ = -3.5;

int testKey = 1;

float[][] keys = {
  { -1.5,0.25,0, 0, 0, -PI/2, 0, 0 },    //***special middle of table (half height of base move up)
  { -0.5,0.25,1, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special top right
  { -1.5,0.25,1, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special top middle
  { -2.5,0.25,1, PI/2, 0, 0, PI, PI },                    //***special top left
  { -0.5,0.25,2, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom right
  { -1.5,0.25,2, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom middle
  { -2.5,0.25,2, PI/2, 0, 0, PI, PI },                    //***special bottom left
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
  float tableLength = 5.0;
  
  translate(keys[0][0], keys[0][1] - tableHeight, keys[0][2]);  //static middle location
  
  box(tableWidth, tableHeight, tableLength);  //table
  
  popMatrix();  //end table
  
  
  //BASE
  pushMatrix();  //start base
  fill(0,0,200);
  
  x = keys[testKey][0];   //lerp(keys[currKey][0], keys[nextKey][0], t);
  y = keys[testKey][1];   //lerp(keys[currKey][1], keys[nextKey][1], t);
  z = keys[testKey][2];   //lerp(keys[currKey][2], keys[nextKey][2], t);
  translate(x, y, z);
  
  //angle = lerp(keys[currKey][3], keys[nextKey][3], t);
  //rotateY(angle);  //do Y axis rotation for base (***special default of 0) --> -PI (CW) to +PI (CCW)

  float baseWidth = 1.0;
  float baseHeight = 0.5;
  float baseLength = 1.0;
  box(baseWidth, baseHeight, baseLength);  //base
  popMatrix();  //end base
  
  popMatrix();  //end scene stuff
} //<>//


void keyPressed() {
  switch(key) {
    case ' ':      //default perspective
      perspective = !perspective;
      
      if (perspective == true) {
        defaultTranslateX = -0.75;
        defaultTranslateY = -0.5;
        defaultTranslateZ = -1.5;
        setView0();
      } else {
        perspective = false;
        defaultTranslateX = 0.33;
        defaultTranslateY = -0.1;
        defaultTranslateZ = -1.5;
        setView1();
      }
      break;
    case '1':      //default, top right
      testKey = 1;
      break;
    case '2':      //top middle
      testKey = 2;
      break;
    case '3':      //top left
      testKey = 3;
      break;
    case '4':      //bottom right
      testKey = 4;
      break;
    case '5':      //bottom middle
      testKey = 5;
      break;
    case '6':      //bottom left
      testKey = 6;
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