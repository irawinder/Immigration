World synthetic;

void setup() {
  size(1200, 1000);
  initWorld(500);
  
  background(0);
  synthetic.display();
  
  noLoop();
}

void draw() {
  
  background(0);
  synthetic.display();
  
  noLoop();
}

void initWorld(int iterations) {
  synthetic = new World();
  
  particleVelocity = 10.0;
  // Allows Agents to reach equilibrium before displaying
  for(int i=0; i<iterations; i++) {
    particleVelocity -= 9.9 / iterations;
    synthetic.update();
  }
  particleVelocity = 0.1;
}

void keyPressed() {
  switch(key) {
    case 'r': // reset
      initWorld(500);
      loop();
      break;
  }  
}
