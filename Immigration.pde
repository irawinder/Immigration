World synthetic;

void setup() {
  size(600, 500);
  
  initWorld();

}

void draw() {
  background(10);
  synthetic.update();
  synthetic.display();
}

void initWorld() {
  synthetic = new World();
  
  // Allows Agents to reach equilibrium before displaying
  for(int i=0; i<500; i++) {
    synthetic.update();
  }
}

void keyPressed() {
  switch(key) {
    case 'r': // reset
      initWorld();
      break;
  }  
}
