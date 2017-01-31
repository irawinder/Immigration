World synthetic;

void setup() {
  size(500,500);
  
  synthetic = new World();
  

}

void draw() {
  background(0);
  synthetic.display();
}

void keyPressed() {
  switch(key) {
    case 'r': // reset
      synthetic = new World();
      break;
  }  
}
