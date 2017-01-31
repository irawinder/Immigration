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
  
  World() {
    
    worldCultures = new ArrayList<Culture>();
    worldCultures.add( new Culture("Glorp", 0) );
    worldCultures.add( new Culture("Mogwop", 1) );
    worldCultures.add( new Culture("Nerb", 2) );
    
    worldNations = new ArrayList<Nation>();
    worldNations.add( new Nation("A") );
    worldNations.add( new Nation("B") );
    worldNations.add( new Nation("C") );
    worldNations.add( new Nation("D") );
    worldNations.add( new Nation("E") );
    
    for (int i=0; i<worldNations.size(); i++) {
      worldNations.get(i).randomSetup( int(random(1,100)) );
      worldNations.get(i).calculateStats();
    }
    
    culturePop = new ArrayList<Integer>();
    for (int i=0; i<worldCultures.size(); i++) {
      culturePop.add(0);
    }
    
    calculateStats();
  }
  
  void printSummary() {
    
    // World Cultures
    println("---World Cultures---");
    for (int i=0; i<worldCultures.size(); i++) {
      println("Culture " + i + ": " + worldCultures.get(i).name);
    }
    println("   ");
    
    // World Population Stats
    println("---World Population---");
    println("Total Population = " + totalPop);
    for (int j=0; j<worldCultures.size(); j++) {
      println( "  " + worldCultures.get(j).name + " Population = " + culturePop.get(j) );
    }
    println("  " + "Majority Culture: " + worldCultures.get(majorityCultureIndex).name);
    println("   ");
    
    // National Population Stats
    println("---World Nations---");
    for (int i=0; i<worldNations.size(); i++) {
      println( "Nation " + i + ": " + worldNations.get(i).name + " ; " + "Total Population = " + worldNations.get(i).citizens.size() );
      for (int j=0; j<worldCultures.size(); j++) {
        println( "  " + worldCultures.get(j).name + " Population = " + worldNations.get(i).culturePop.get(j) );
      }
      println("  " + "Majority Culture: " + worldCultures.get(worldNations.get(i).majorityCultureIndex).name);
    } 
    println("   ");
    
  }// End printSummary()
    
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

  //  A "Nation" is a collection of "Persons."
  //  A "Nation" is susceptable to domestic crime rates and nativism
  class Nation {
    ArrayList<Persons> citizens;
    String name;
    
    // Dynamic parameters
    int majorityCultureIndex;
    int nativePop, immigrantPop, totalPop;
    ArrayList<Integer> culturePop;
    
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
    Persons(boolean immigrant, Culture culture) {
      this.immigrant = immigrant;
      this.culture = culture;
    }
  } // End Persons

}
