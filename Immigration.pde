World synthetic;

void setup() {
  size(1200, 1000);
  synthetic = new World();
  
  background(0);
  synthetic.display();
  
  noLoop();
}

void draw() {
  
  background(0);
  synthetic.display();
  
  noLoop();
}

void keyPressed() {
  switch(key) {
    case 'r': // reset
      synthetic = new World();
      loop();
      break;
  }  
}
