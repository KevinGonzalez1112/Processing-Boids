// Flock holds a list of Boid objects

class Flock
{
  ArrayList<Boid> boids; // ArrayList that will be used to store the Boids
  
  Flock()
  {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }
  
  void run()
  {
    for (Boid b: boids)
    {
      b.run(boids); // Passing the entire list of Boids to each Boid
    }
  }
  
  void addBoid(Boid b)
  {
    boids.add(b);
  }
  
  void clearBoids()
  {
    boids = new ArrayList<Boid>();
  }
}
