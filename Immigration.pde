World synthetic;

void setup() {
  size(1200, 1000);
  synthetic = new World();
  runTime = 1000;
}

// Amount of frmes to run draw() function when graphics need to be refreshed
// Set to a number as high as needed when updating visuals that need to be animated
int runTime = 0;

void draw() {
  
  background(0);
  synthetic.update();
  synthetic.display();
  
  if (runTime > 0) {
    runTime--;
  } else {
    noLoop();
  }
}

void keyPressed() {
  switch(key) {
    case 'r': // reset
      synthetic = new World();
      runTime = 1000;
      loop();
      break;
    case 'm': // migrate
      int origin, destination;
      for (int i=0; i<25; i++) {
        origin = int(random(0,10));
        destination = int(random(0,10));
        synthetic.migrate(0, origin, destination);
      }
      runTime = 1000;
      loop();
      break;
  }  
}
