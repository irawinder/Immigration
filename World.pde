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

String[] cultureNames = {
  "Glorp",
  "Mogwop",
  "Nerb",
  "Talax",
  "Xenu",
  "Delta",
  "Tribble",
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
  ArrayList<PVector> loc;
  ArrayList<Integer> hue;
  
  World() {
    setupWorld();
    setupCanvas();
    
    calculateStats();
  }
  
  void setupWorld() {
    int numCultures = int(random(1, cultureNames.length));
    int numNations = int(random(1, nationNames.length));
    
    worldCultures = new ArrayList<Culture>();
    for (int i=0; i<numCultures; i++) {
      worldCultures.add( new Culture(cultureNames[i], i) );
    }
    
    worldNations = new ArrayList<Nation>();
    for (int i=0; i<numNations; i++) {
      worldNations.add( new Nation(nationNames[i]) );
    }
    
    for (int i=0; i<worldNations.size(); i++) {
      worldNations.get(i).randomSetup( int(random(1,100)) );
      worldNations.get(i).calculateStats();
    }
    
    culturePop = new ArrayList<Integer>();
    for (int i=0; i<worldCultures.size(); i++) {
      culturePop.add(0);
    }
    
    printSummary();
  }
  
  void setupCanvas() {
    loc = new ArrayList<PVector>();
    for (int i=0; i<worldNations.size(); i++) {
      float angle = i*(2.0*PI)/worldNations.size();
      float x = 0.5*width + (0.3*width)*sin(angle);
      float y = 0.5*height - (0.3*height)*cos(angle);
      loc.add(new PVector(x, y));
      
      int area = 20;
      for(int j=0; j<worldNations.get(i).citizens.size(); j++) {
        worldNations.get(i).citizens.get(j).setLocation(int(x + random(-area, area)), int(y + random(-area, area)));
      }
    }
    
    hue = new ArrayList<Integer>();
    for (int i=0; i<worldCultures.size(); i++) {
      hue.add(new Integer(int(i*255.0/worldCultures.size())));
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
  
  void display() {
    colorMode(HSB);
    
    for (int i=0; i<worldNations.size(); i++) {
      
      float x, y;
      
      // Draw People
      noStroke();
      int cultureIndex;
      for (int j=0; j<worldNations.get(i).citizens.size(); j++) {
        worldNations.get(i).citizens.get(j).update(loc.get(i), worldNations.get(i).citizens);
        cultureIndex = worldNations.get(i).citizens.get(j).culture.index;
        fill(hue.get(cultureIndex), 255, 255, 150);
        x = worldNations.get(i).citizens.get(j).loc.x;
        y = worldNations.get(i).citizens.get(j).loc.y;
        ellipse(x, y, 8, 8);
      }
      
      // Draw Nation
      x = loc.get(i).x;
      y = loc.get(i).y;
      String name = worldNations.get(i).name;
      fill(255, 150);
      textAlign(CENTER, CENTER);
      textSize(16);
      text(name, x, y);
      
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
    float maxVel = 0.1;
    int repelDist = 10;
    float repelForce = 1;
    
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
      PVector sinkForce = new PVector(sink.x, sink.y);
      sinkForce.sub(loc);
      sinkForce.setMag(0.5);
      acc.set(sinkForce);
      
      // Apply Repel Force
      PVector dist = new PVector();
      for (int i=0; i<crowd.size(); i++) {
        dist.x = loc.x;
        dist.y = loc.y;
        dist.sub(crowd.get(i).loc);
        if (dist.mag() < repelDist && dist.mag() != 0) {
          dist.setMag(repelForce);
          acc.add(dist);
        }
      }
      
      // Update Velocity, Caps Speed
      vel.add(acc);
      if (vel.mag() > maxVel) {
        vel.setMag(maxVel);
      }
      
      // Updates Location
      loc.add(vel);
    }
    
  } // End Persons

}
