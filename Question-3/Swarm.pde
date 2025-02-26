// Swarm class
// Creates a Swarm of Particles

class Swarm
{
  // A list of Particles
  ArrayList<Particle> swarm;
  ArrayList<Obstacle> obstacles;
  
  // Variable used to spread particles evenly 
  int every = 5;
  
  // Global best value
  float gBest;
  
  // Global best position
  PVector posG;
  
  // Maximum velocity 
  float maxInitialVelocity = 3;
  
  // Swarm Constructor
  Swarm()
  { 
    // Create an array of Particles 
    swarm = new ArrayList<Particle>();
    obstacles = new ArrayList<Obstacle>();
    
    // Best value and position is found 
    // In Swarm
    gBest = -10000000;
    posG = new PVector(WIDTH/2, HEIGHT/2);
    
    for (Particle par: swarm)
    {
      float val = par.evaluate();
      if (val > gBest)
      {
        gBest = val;
        posG = par.posB.copy();
      }
    }
  }
  
  void run()
  {
    if (unpause)
    {
      for (Particle par: swarm)
      {
        par.move(posG);
        par.sobel();
        par.swarmApply(obstacles);
      }
      
      // Calculate the new best global
      for (Particle par: swarm)
      {
        float val = par.evaluate();
        
        if (val > gBest)
        {
          gBest = val;
          posG = par.posB.copy();
        }
      }
    }
    
    for (Particle par: swarm)
    {
      par.display();
    }
    
    for (Particle par: obstacles)
    {
      par.display();
    }
  }
  
  void addParticle(Particle p)
  {
    swarm.add(p);
  }
  
  void addObstacle(Obstacle o)
  {
    obstacles.add(o);
  }
  
  void clearParticles()
  {
    swarm = new ArrayList<Particle>();
  }
}
