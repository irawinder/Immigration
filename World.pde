/*
  A synthetic world for experimenting with immigration
  Ira Winder, jiw@mit.edu
  
  "Among native-born men, 1.35 percent were institutionalized in 1980 and 2.16 percent in 1990. 
  By comparison, 0.7 percent of male immigrants were institutionalized in 1980 and 1.49 percent in 1990."
  
  http://www.nber.org/digest/jan98/w6067.html
  
*/

/*  Class Heirarchy and Structure:
 *
 *  World -> Nation,  Culture, Persons
 *
 */

float particleVelocity = 1;

String[] cultureNames = {
  "Xenu",
  "Delta",
  "Tribble",
  "Glorp",
  "Mogwop",
  "Nerb",
  "Talax",
  "Kletz",
  "Lazuli",
  "Muggle"
};

String[] nationNames = {
  "Alphax",
  "Betaburg",
  "Zetamon",
  "Bigmont",
  "Selion",
  "Kronos",
  "Xindi",
  "Helios",
  "Dacia",
  "Dovania"
};

import java.util.*;

class World {
  
  // Global constants:
  float NATIVE_CRIME_RATE_1980 = 1.35;
  float NATIVE_CRIME_RATE_1990 = 2.16;
  float IMMIGRANT_CRIME_RATE_1980 = 0.70;
  float IMMIGRANT_CRIME_RATE_1990 = 1.49;
  
  // Universe
  ArrayList<Culture> worldCultures;
  ArrayList<Nation> worldNations;
  
  // Dynamic parameters
  int majorityCultureIndex;
  int nativePop, immigrantPop, totalPop;
  ArrayList<Integer> culturePop;
  
  
  // Display Parameters
  ArrayList<PVector> loc, nameLoc;
  ArrayList<Integer> hue;
  float innerCircle, outerCircle;
  
  World() {
    setupWorld();
    setupCanvas();
  }
  
  void setupWorld() {
    int numCultures = int(random(3, 6));
    int numNations = int(random(3, nationNames.length+1));
    
    worldCultures = new ArrayList<Culture>();
    for (int i=0; i<numCultures; i++) {
      worldCultures.add( new Culture(cultureNames[i], i) );
    }
    
    worldNations = new ArrayList<Nation>();
    for (int i=0; i<numNations; i++) {
      worldNations.add( new Nation(nationNames[i]) );
    }
    
    for (int i=0; i<worldNations.size(); i++) {
      worldNations.get(i).randomSetup( int( sq( random(1,9) ) ) );
      worldNations.get(i).calculateStats();
    }
    
    culturePop = new ArrayList<Integer>();
    for (int i=0; i<worldCultures.size(); i++) {
      culturePop.add(0);
    }
    
    calculateStats();
    printSummary();
  }
  
  void setupCanvas() {
    innerCircle = 0.25;
    outerCircle = 0.32;
    
    loc = new ArrayList<PVector>();
    nameLoc = new ArrayList<PVector>();
    float x,y, angle;
    for (int i=0; i<worldNations.size(); i++) {
      angle = i*(2.0*PI)/worldNations.size();
      x = width - 0.5*height + (innerCircle*height)*sin(angle);
      y = 0.5*height - (innerCircle*height)*cos(angle);
      loc.add(new PVector(x, y));
      
      x = width - 0.5*height + (outerCircle*height)*sin(angle);
      y = 0.5*height - (outerCircle*height)*cos(angle);
      nameLoc.add(new PVector(x, y));
      
      int area = 100;
      for(int j=0; j<worldNations.get(i).citizens.size(); j++) {
        worldNations.get(i).citizens.get(j).setLocation(int(x + area*sin(random(0, 2*PI))), int(y + area*cos(random(0, 2*PI))));
      }
    }
    
    hue = new ArrayList<Integer>();
    for (int i=0; i<worldCultures.size(); i++) {
      hue.add(new Integer(int(i*200.0/worldCultures.size())));
    }
    
  }
    
  void calculateStats() {
    
    //Reset Parameters
    for (int i=0; i<culturePop.size(); i++) {
      culturePop.set(i, 0);
    }
    totalPop = 0;
    nativePop = 0;
    immigrantPop = 0;
    
    for(int i=0; i<worldNations.size(); i++) {
      totalPop += worldNations.get(i).totalPop;
      immigrantPop += worldNations.get(i).immigrantPop;
      nativePop += worldNations.get(i).nativePop;
      for(int j=0; j<worldCultures.size(); j++) {
        culturePop.set(j, culturePop.get(j) + worldNations.get(i).culturePop.get(j));
      }
    }
    
    // Calculates Majority Culture
    majorityCultureIndex = 0;
    for (int i=1; i<culturePop.size(); i++) {
      if (culturePop.get(i) > culturePop.get(majorityCultureIndex) ) {
        majorityCultureIndex = i;
      }
    }
    
  } // End CalculateStats()
  
  void update() {
    // Draw Nations w/ People
    for (int i=0; i<worldNations.size(); i++) {
      for (int j=0; j<worldNations.get(i).citizens.size(); j++) {
        worldNations.get(i).citizens.get(j).update(loc.get(i), worldNations.get(i).citizens); 
      }
    } 
  }
  
  void display() {
    colorMode(HSB);
    
    // Title
    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    text("Synthetic Nations", 20, 20);
    text("With Sub-Populations", 20, 40);
    
    // Draw Culture Legend
    int margin = 20;
    int top = 70;
    int textSize = 16;
    int cultureIndex;
    int circleDim = 10;
    textSize(textSize);
    textAlign(LEFT, CENTER);
    
    fill(255);
    text("1 million people", 30 + margin, top + margin);
    fill(255);
    ellipse(margin + 4, top + margin + 1, circleDim, circleDim);
    
    fill(255);
    text("Immigrant", 30 + margin, 1.75*2*textSize + top + margin);
    noFill();
    stroke(255);
    strokeWeight(2);
    ellipse(margin + 4, 1.75*2*textSize + top + margin + 1, circleDim, circleDim);
    noStroke();
    
    fill(255);
    text("Native", 30 + margin, 1.75*3*textSize + top + margin);
    fill(150);
    ellipse(margin + 4, 1.75*3*textSize + top + margin + 1, circleDim, circleDim);
    
    for (int i=0; i<worldCultures.size(); i++) {
      fill(255);
      text(worldCultures.get(i).name, 30 + margin, 1.75*5*textSize + top + margin + 1.75*i*textSize);
      
      cultureIndex = worldCultures.get(i).index;
      fill(hue.get(cultureIndex), 200, 255, 255);
      ellipse(margin + 4, 1.75*5*textSize + top + margin + 1.75*i*textSize + 1, circleDim, circleDim);
    }

    // Draw Large Circle
    stroke(20);
    strokeWeight(50);
    noFill();
    ellipse(width - 0.5*height, 0.5*height, 2*innerCircle*height, 2*innerCircle*height);
    
    // Draw Nations w/ People
    for (int i=0; i<worldNations.size(); i++) {
      float x, y;

      // Draw People
      noStroke();
      for (int j=0; j<worldNations.get(i).citizens.size(); j++) {
        cultureIndex = worldNations.get(i).citizens.get(j).culture.index;
        if (worldNations.get(i).citizens.get(j).immigrant) {
          noFill();
          stroke(hue.get(cultureIndex), 200, 255, 255);
          strokeWeight(2);
        } else {
          noStroke();
          fill(hue.get(cultureIndex), 200, 255, 255);
        }
        
        x = worldNations.get(i).citizens.get(j).loc.x;
        y = worldNations.get(i).citizens.get(j).loc.y;
        ellipse(x, y, circleDim, circleDim);
      }
    
      // Draw Nation
      x = nameLoc.get(i).x;
      y = nameLoc.get(i).y;
      String name = worldNations.get(i).name;
      String majorityCulture = worldCultures.get(worldNations.get(i).majorityCultureIndex).name;
      
      textAlign(CENTER, CENTER);
      textSize(20);
      fill(0);
      text(name, x+1, y+1);
      text(name, x-1, y-1);
      text(name, x+1, y-1);
      text(name, x-1, y+1);
      fill(255);
      text(name, x, y);
//      text(name, x, y - 8);
//      textSize(12);
//      text(majorityCulture, x, y + 8);
    }
    
  } // End display()
  
  void printSummary() {
    
    // World Cultures
    println("--- World Cultures ---");
    println("  " );
    for (int i=0; i<worldCultures.size(); i++) {
      println("  " + "Culture " + i + ": " + worldCultures.get(i).name);
    }
    println("  " );
    
    // World Population Stats
    println("--- World Population ---");
    println("  " );
    println("  " + "Total Population = " + totalPop);
    for (int j=0; j<worldCultures.size(); j++) {
      println( "  " + worldCultures.get(j).name + " Population = " + culturePop.get(j) );
    }
    println("  " + "Majority Culture: " + worldCultures.get(majorityCultureIndex).name);
    println("  " );
    
    // National Population Stats
    for (int i=0; i<worldNations.size(); i++) {
      println( "--- Nation " + worldNations.get(i).name + " ---");
      println( "  " );
      println( "  " + "Total Population = " + worldNations.get(i).citizens.size() );
      for (int j=0; j<worldCultures.size(); j++) {
        println( "  " + worldCultures.get(j).name + " Population = " + worldNations.get(i).culturePop.get(j) );
      }
      println( "  " + "Majority Culture: " + worldCultures.get(worldNations.get(i).majorityCultureIndex).name);
      println( "  " );
    } 
    
  } // End printSummary()

  //  A "Nation" is a collection of "Persons."
  //  A "Nation" is susceptable to domestic crime rates and nativism
  class Nation {
    ArrayList<Persons> citizens;
    String name;
    
    // Dynamic Numerical Variable
    int majorityCultureIndex;
    int nativePop, immigrantPop, totalPop;
    ArrayList<Integer> culturePop;
    
    // Display Variables
    PVector loc; // Centroid of nation on draw canvas
    
    Nation(String name) {
      this.name = name;
      citizens = new ArrayList<Persons>();
      culturePop = new ArrayList<Integer>();
      for (int i=0; i<worldCultures.size(); i++) {
        culturePop.add(0);
      }
    } // End Nation()
    
    void randomSetup(int numPersons) {
      
      // Generates and sorts a random distribution of cultures
      ArrayList<Float> distribution = new ArrayList<Float>();
      for (int i=0; i<worldCultures.size()-1; i++) {
        distribution.add(random(0,1));
      }
      Collections.sort(distribution);
      
      // Based on Random Culture Distribution Curve, allocates Culture to People
      int randomCulture;
      float random;
      for (int i=0; i<numPersons; i++) {
        random = random(0,1);
        randomCulture = worldCultures.size() - 1;
        for (int j=0; j<distribution.size(); j++) {
          if (random < distribution.get(j)) {
            randomCulture = j;
            break;
          }
        }
        citizens.add( new Persons(false, worldCultures.get(randomCulture) ) );
      }
    } // End randomSetup()
    
    void calculateStats() {
      
      //Reset Parameters
      for (int i=0; i<culturePop.size(); i++) {
        culturePop.set(i, 0);
      }
      totalPop = 0;
      nativePop = 0;
      immigrantPop = 0;
      
      // helper variables
      int cultureIndex;
      int currentPop; 
      
      for(int p=0; p<citizens.size(); p++) {
        
        // Re-Calculate Culture Populations (ArrayIndex of Integers)
        cultureIndex = citizens.get(p).culture.index;
        currentPop = culturePop.get(cultureIndex);
        culturePop.set(cultureIndex, currentPop + 1);
        
        // Re-Calculate Native/Immigrant Populations
        if (citizens.get(p).immigrant) {
          immigrantPop++;
        } else {
          nativePop++;
        }
      }
      
      // Calculate Total Population
      totalPop = immigrantPop + nativePop;
      
      // Calculates Majority Culture
      majorityCultureIndex = 0;
      for (int i=1; i<culturePop.size(); i++) {
        if (culturePop.get(i) > culturePop.get(majorityCultureIndex) ) {
          majorityCultureIndex = i;
        }
      }
      
    } // End calculateStats()
    
  } // End Nation()
  
  // A "Culture" is the self-identified in-group of a group of "Persons."  
  // Persons with the same culture identify each other to be in the same in-group, 
  // Persons with different cultures identify each other as outgroups.
  class Culture {
    String name;
    int index;
    Culture(String name, int index) {
      this.name = name;
      this.index = index;
    }  
  } // End Culture()
  
  //  A "Persons" is not neccessarly an individual actor, but a unit that contains essential characteristics of individuals.  
  //  Conceptually, a "Person" object might actually represent a small group of people all with similar characteristics.  
  //  If a Persons has "recently" moved from one nation to another, their immigrant status is set to true.
  //  After a Persons resides in a nation for a 'defined duration of time', their immigrant status is set to false.
  //  A culture integer specifies a group to which a Persons may belong.  This is purposefully ambiguous. 
  class Persons {
    boolean immigrant;
    Culture culture;
    
    //Graphics/Display Parameters
    PVector acc, vel, loc;
    int repelDist = 12;
    float sinkForce = 0.5;
    float repelForce = 10;
    float attractForce = 0.1;
    
    Persons(boolean immigrant, Culture culture) {
      this.immigrant = immigrant;
      this.culture = culture;
      
      acc = new PVector(0,0);
      vel = new PVector(0,0);
      loc = new PVector(0,0);
    }
    
    void setLocation(int x, int y) {
      loc.x = x;
      loc.y = y;
    }
    
    void update(PVector sink, ArrayList<Persons> crowd) {
      
      // Apply Sink Force
      PVector sinkVector = new PVector(sink.x, sink.y);
      sinkVector.sub(loc);
      sinkVector.setMag(sinkForce);
      acc.set(sinkVector);
      
      // Apply Attract and Repel Force
      PVector dist = new PVector();
      for (int i=0; i<crowd.size(); i++) {
        dist.x = loc.x;
        dist.y = loc.y;
        dist.sub(crowd.get(i).loc);
        if (dist.mag() < repelDist) {
          dist.setMag(repelForce);
          acc.add(dist);
        }
        if(culture.index == crowd.get(i).culture.index) {
          dist.setMag(attractForce);
          acc.sub(dist);
        }
      }
      

      
      // Update Velocity, Caps Speed
      vel.add(acc);
      if (vel.mag() > particleVelocity) {
        vel.setMag(particleVelocity);
      }
      
      // Updates Location
      loc.add(vel);
      
    }
    
  } // End Persons

}
