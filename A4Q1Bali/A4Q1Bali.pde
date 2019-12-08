// Jaivir Bali (7775370)
// A4Q1
float eyeX = 1, eyeY = 2, eyeZ = 0, centerX = 0, centerY = 1, centerZ = -2, upX = 0, upY = 1, upZ = 0;
boolean perspective = true;  //toggle between perspective 1 and 2

int currKey = 0;
int nextKey = 0;

boolean t0 = true;
float t = 0;
int t0time;
int pauseTime;
float tmod = 0;
  
float x, y, z, angle;
boolean currLerping = true;  //don't want to cancel animation while lerping

//CAMERA default translates
float defaultTranslateX = -0.70;
float defaultTranslateY = -0.5;
float defaultTranslateZ = -2.5;

//SHIP keys and curr bins/values
float[] shipXkeys = {-2.5, -1.5, -0.5};
int shipX = 1;
float shipY = 0.25;
int shipZ = 0;
float[] shipZkeys = {0.5, 1.5};

//{ -0.5,0.25,0.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special top right
//{ -1.5,0.25,0.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special top middle
//{ -2.5,0.25,0.5, PI/2, 0, 0, PI, PI },                    //***special top left
//{ -0.5,0.25,1.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom right
//{ -1.5,0.25,1.5, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom middle
//{ -2.5,0.25,1.5, PI/2, 0, 0, PI, PI },                    //***special bottom left
  
PImage floortext, tiletext, hardwoodtext, cosmictext; 
boolean jump = true;   //snowman
float bounceSnow = 0;  //snowman bounce var
int cosmicRotate = 0;  //cosmic triangle rotation angle

void setup() {
  size(640, 640, P3D);
  hint(DISABLE_OPTIMIZED_STROKE);
  setView0();
  textureMode(NORMAL);
  floortext = loadImage("assets/floor.jpg");
  tiletext = loadImage("assets/tile.jpg");
  hardwoodtext = loadImage("assets/hardwood.jpg");
  cosmictext = loadImage("assets/cosmic.jpg");
  textureWrap(REPEAT);
}

void draw() {
  clear();
  resetMatrix();
  
  if (t0) {
    t0time = millis();
  }
  
  if(perspective){
    ortho(-1, 1, 1, -1, 1, 10);  //2.10
  }else{
    frustum(-1, 1, 1, -1, 1, 10);  //2.10
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
 
  //LEVEL
  pushMatrix();  //start level
  
  float tableHeight = 0.5;  //adjustment for boxes to shift to be above plane
  //max +3 in frustrum, need max +6 for ortho, need min 21 (42 middle. 40 test)

  
  
  if (t < 1.05) {
    //tmod = t - ((t*100.0 % 10.0) / 100.0);
    tmod = t - ((t*100.0 % 5.0) / 100.0);
  }
  //println("tmod = "+ tmod);
  //println("t = "+ t);
  
  z = lerp(keys[0][2], 20.0, tmod);
  //z = keys[0][2];
  
  //TABLE
  pushMatrix();  //start table
  
  translate(keys[0][0], keys[0][1] - tableHeight, z);  //table moves
  //box(tableWidth, tableHeight, tableLength);  //table
  
  //PLANE
  pushMatrix();  //start plane
  
  translate(0, 0.25, 0);  //plane
  

  //DRAWING TILES
  int swapTexture = 0;
  for (int i = 0; i < 66; i++) {
    beginShape(QUADS);      //LEFT TILES
    if (swapTexture == 0) {
      texture(floortext);
    } else if (swapTexture == 1) {
      texture(tiletext);
    } else {
      texture(hardwoodtext);
    }
    
    vertex(-1.5, 0, 5-i, 0, 1);
    vertex(-1.5, 0, 6-i, 1, 1);
    vertex(-0.5, 0, 6-i, 1, 0);
    vertex(-0.5, 0, 5-i, 0, 0);
    endShape();
    
    beginShape(QUADS);    //MIDDLE TILES
    if (swapTexture == 0) {
      texture(tiletext);
    } else if (swapTexture == 1) {
      texture(hardwoodtext);
    } else {
      texture(floortext);
    }
    vertex(-0.5, 0, 5-i, 0, 1);
    vertex(-0.5, 0, 6-i, 1, 1);
    vertex(0.5, 0, 6-i, 1, 0);
    vertex(0.5, 0, 5-i, 0, 0);
    endShape();
    
    beginShape(QUADS);    //RIGHT TILES
    if (swapTexture == 0) {
      texture(hardwoodtext);
    } else if (swapTexture == 1) {
      texture(tiletext);
    } else {
      texture(floortext);
    }
    vertex(0.5, 0, 5-i, 0, 1);
    vertex(0.5, 0, 6-i, 1, 1);
    vertex(1.5, 0, 6-i, 1, 0);
    vertex(1.5, 0, 5-i, 0, 0);
    endShape();
    
    swapTexture = (swapTexture+1) % 3;
  }
  
  popMatrix();  //end plane
  
  //OBJECTS
  for (int i = 1; i < keys.length-1; i++) {
    pushMatrix();  //start barrier
    fill(0,200,0);
    
    //x = keys[testKey][0];   //lerp(keys[currKey][0], keys[nextKey][0], t);
    //y = keys[testKey][1];   //lerp(keys[currKey][1], keys[nextKey][1], t);
    //z = keys[testKey][2];   //lerp(keys[currKey][2], keys[nextKey][2], t);
    
    x = keys[i][0];       //lerp(keys[currKey][0], keys[nextKey][0], t);
    y = keys[i][1];       //lerp(keys[currKey][1], keys[nextKey][1], t);
    z = keys[i][2];       //lerp(keys[currKey][2], keys[nextKey][2], t);
    translate(x, y, z);
    
    //angle = lerp(keys[currKey][3], keys[nextKey][3], t);
    //rotateY(angle);  //do Y axis rotation for base (***special default of 0) --> -PI (CW) to +PI (CCW)
  
    float barrierWidth = 0.9;
    float barrierHeight = 0.5;
    float barrierLength = 0.9;
    box(barrierWidth, barrierHeight, barrierLength);  //barrier itself
    popMatrix();  //end barrier
  }
  
  //SNOWMAN
  pushMatrix();  //SnowmanAll

  //jumping animation
  if (jump) {
    if (bounceSnow < 1) {
      bounceSnow += 0.05;
    } else {
      jump = !jump;
    }
  } else {
    if (bounceSnow > 0) {
      bounceSnow -= 0.05;
    } else {
      jump = !jump;
    }
  }
  
  //DRAW SNOMAN
  for (int i = 0; i < 3; i++) {
    pushMatrix();  //SnowmanDraw
    
    translate(1, bounceSnow, -6.5-(21.0*i));  //translate to grid locations
    noStroke();
    fill(230, 230, 230);  
    translate(0, 0.5, 0);   //base sphere
    sphere(0.5);
    translate(0, 0.75, 0);  //torso sphere
    sphere(0.3);
    translate(0, 0.45, 0);  //head sphere
    sphere(0.2);
    fill(255, 140, 0);
    translate(0, 0, 0.3);   //carrot nose
    box(0.05, 0.05, 0.25);
  
    popMatrix();  //endSnowmanDraw
  }
  popMatrix();  //endSnowmanAll
  
  
  //DRAW COSMIC TRIANGLE
  if (cosmicRotate > 360) {
    cosmicRotate = 0;
  } else {
    cosmicRotate += 3;
  }
  
  for (int i = 0; i < 3; i++) {
    pushMatrix();  //start cosmic triangle
    translate(-1, 0.75, -6.5-(21.0*i));
    rotateY(radians(cosmicRotate)); 
    
    beginShape(TRIANGLES);
    texture(cosmictext);
    shininess(1.0);
    ambient(150,150,150);
    vertex(0,0.5,0,1,1);
    vertex(0.5, -0.5, 0.5, 0, 0);
    vertex(-0.5, -0.5, 0.5, 0, 1);
    
    vertex(0,0.5,0,1,1);
    vertex(-0.5, -0.5, 0.5, 0, 0);
    vertex(-0.5, -0.5, -0.5, 0, 1);
    
    vertex(0,0.5,0,1,1);
    vertex(-0.5, -0.5, -0.5, 0, 0);
    vertex(0.5, -0.5, -0.5, 0, 1);
    
    vertex(0,0.5,0,1,1);
    vertex(0.5, -0.5, -0.5, 0, 0);
    vertex(0.5, -0.5, 0.5, 0, 1);
    endShape();
    
    beginShape(QUADS);
    texture(cosmictext);
    shininess(1.0);
    ambient(150,150,150);
    //bottom face
    vertex(0.5, -0.5, 0.5, 0, 1);
    vertex(-0.5, -0.5, 0.5, 1, 1);
    vertex(-0.5, -0.5, -0.5, 1, 0);
    vertex(0.5, -0.5, -0.5, 0, 0);
    endShape();
    
    popMatrix();  //end cosmic triangle
  }
  
  
  //SPECIAL END MARKER
  pushMatrix();  //start special end marker
  fill(200,0,0);
  
  x = keys[keys.length-1][0];       //lerp(keys[currKey][0], keys[nextKey][0], t);
  y = keys[keys.length-1][1];       //lerp(keys[currKey][1], keys[nextKey][1], t);
  z = keys[keys.length-1][2];       //lerp(keys[currKey][2], keys[nextKey][2], t);
  translate(0, y, z);
  
  //angle = lerp(keys[currKey][3], keys[nextKey][3], t);
  //rotateY(angle);  //do Y axis rotation for base (***special default of 0) --> -PI (CW) to +PI (CCW)

  float barrierWidth = 0.9;
  float barrierHeight = 0.5;
  float barrierLength = 0.9;
  box(barrierWidth, barrierHeight, barrierLength);  //special end marker
  popMatrix();  //end special end marker
  ///////////////////////////////////////  
    
    
  popMatrix();  //end table
  popMatrix();  //end level
  
  
  //SHIP
  pushMatrix();  //start ship
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
  box(baseWidth, baseHeight, baseLength);  //ship itself
  popMatrix();  //end ship
  
  
  
 
  
  //////////////////////////////////////////////////
  popMatrix();  //end scene stuff
  
  if (currLerping == true) {
    t  = (millis() - t0time) / 20000.0;
  }
  if (t >= 1.05) {
    t = 0;       //set to 0 to reset, set to 1 to make it stay at end
    tmod = 0;
    t0 = true;  //set to false to make it stop at end, normally set to true
  } else {
    t0 = false;
  }
} //<>//

//Everything must be repeated 3x
float[][] keys = {
  { -1.5, 0.25, 0 },           //TABLE -> middle of field (half height of base move up, Z always >= 0.25)
  { 0, 0.5, -2.5 },            //first square barrier
  { 1, 0.5, -10.5 },           //second square barrier
  { -1, 0.5, -16.5 },          //third square barrier
  { 0, 0.5, -23.5 },           //***special repeat first square barrier (-21.0)
  { 1, 0.5, -31.5 },           //***special repeat second square barrier (-21.0)
  { -1, 0.5, -37.5 },          //***special repeat third square barrier(-21.0)
  { 0, 0.5, -44.5 },           //***special repeat first square barrier (-42.0)
  { 1, 0.5, -52.5 },           //***special repeat second square barrier (-42.0)
  { -1, 0.5, -58.5 },          //***special repeat third square barrier(-42.0)
  { 0, 0.5, -20.5 },           //***special end value at 20 (used for testing)
};

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
        defaultTranslateX = 0.33;  //0.33
        defaultTranslateY = -0.1;
        defaultTranslateZ = -0.315;  //1.5
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
    case 'p':      //bottom left
      if (currLerping == true) {
        currLerping = false;
        pauseTime = millis();
        //println("T0 time = " + t0time + ", pauseTime = " + pauseTime);
      } else {
        t0time = t0time + (millis() - pauseTime);
        //println("T0 time = " + t0time + ", pauseTime = " + pauseTime);
        currLerping = true;
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
