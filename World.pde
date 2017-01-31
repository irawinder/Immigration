/*

  "Among native-born men, 1.35 percent were institutionalized in 1980 and 2.16 percent in 1990. 
  By comparison, 0.7 percent of male immigrants were institutionalized in 1980 and 1.49 percent in 1990."
  
  http://www.nber.org/digest/jan98/w6067.html
  
*/

/*  Class Heirarchy and Structure:
 *
 *  World -> Nation,  Culture, Persons
 *
 */

class World {
  
  // Global constants:
  float NATIVE_CRIME_RATE_1980 = 1.35;
  float NATIVE_CRIME_RATE_1990 = 2.16;
  float IMMIGRANT_CRIME_RATE_1980 = 0.70;
  float IMMIGRANT_CRIME_RATE_1990 = 1.49;
  
  // Universe
  ArrayList<Culture> worldCultures;
  ArrayList<Nation> worldNations;

  World() {
    
    worldCultures = new ArrayList<Culture>();
    worldCultures.add( new Culture("Glorp", 0) );
    worldCultures.add( new Culture("Mogwop", 1) );
    
    worldNations = new ArrayList<Nation>();
    worldNations.add( new Nation("A") );
    worldNations.add( new Nation("B") );
    worldNations.add( new Nation("C") );
    worldNations.add( new Nation("D") );
    worldNations.add( new Nation("E") );
    
    for (int i=0; i<worldNations.size(); i++) {
      worldNations.get(i).randomSetup( int(random(1,100)) );
    }
  
    println("---");
    for (int i=0; i<worldCultures.size(); i++) {
      println("Culture " + i + ": " + worldCultures.get(i).name);
    }
    println("---");
    for (int i=0; i<worldNations.size(); i++) {
      println("Nation " + i + ": " + worldNations.get(i).name + " ; Population = " + worldNations.get(i).citizens.size());
    }
    
  }
  
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
  }
  
  
  //  A "Nation" is a collection of "Persons."
  //  A nation is susceptable to domestic crime rates and nativism
  class Nation {
    ArrayList<Persons> citizens;
    String name;
    
    Nation(String name) {
      this.name = name;
      citizens = new ArrayList<Persons>();
    }
    
    void randomSetup(int numPersons) {
      int randomCulture = int(random(0, worldCultures.size()));
      for (int i=0; i<numPersons; i++) {
        citizens.add( new Persons(false, worldCultures.get(randomCulture) ) );
      }
    }
    
    void calculateStats() {
      // Calculate Majority/Minority Culture (array index of worldCultures

    }
  }
  
  
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
  }

}
