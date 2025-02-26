// Boid class

class Boid 
{
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxForce; // Max steering force
  float maxSpeed; // Maximum speed
  color col;
  
  Boid(float x, float y, color col)
  {
    this.col = col;
    acceleration = new PVector(0, 0);
    
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    
    position = new PVector(x, y);
    r = 2.0;
    maxSpeed = maxSpeedValue;
    maxForce = maxForceValue;
  }
  
  // Checks for nearby Boids and steers away to avoid collision
  PVector separate(ArrayList<Boid> boids)
  {
    float desiredSeparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // Get every Boid in the system and check if its too close
    for (Boid other: boids)
    {
      float d = PVector.dist(position, other.position);
      // If distance is greater than 0 and less than an arbituary amount
      if ((d > 0) && (d < desiredSeparation))
      {
        // Calculate vector pointing away from neighbouring Boid
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d); // Weight by distance
        steer.add(diff);
        count++;
      }
    }
    
    // Average / Count
    if (count > 0)
    {
      steer.div((float)count);
    }
    
    // If vector is > 0
    if (steer.mag() > 0)
    {
      // Implementing Ryenolds principle: 
      // Steering = Desired - Velocity 
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(velocity);
      steer.limit(maxForce);
    }
    
    return steer;
  }
  
  // Calculates average of nearby velocity of every Boid in the system
  PVector align(ArrayList<Boid> boids)
  {
    float neighborDist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    
    for (Boid other: boids)
    {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighborDist) && (other.col == col)) // Used to seperate Flocks by color
      {
        sum.add(other.velocity);
        count++;
      }
    }
    
    if (count > 0)
    {
      sum.div((float)count);
      
      // Implement Reynolds Principle
      // Steering = Desired - Velocity 
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxForce); 
      return steer;
    }
    else
    {
      return new PVector(0, 0);
    }
  }
  
  // Calculates and applies the steering force towards a target
  // Steer = Desired - Velocity
  PVector seek(PVector target)
  {
    PVector desired = PVector.sub(target, position); // Vector pointing from position to target
    
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxSpeed);
    
    PVector steer = PVector.sub(desired, velocity);
    
    // Steer = Desired - Velocity
    steer.limit(maxForce); // Limiting maximum steering force
    
    return steer;
  }
  
  // For average position of all nearby Boids, calculate steering vector towards that point
  PVector cohesion(ArrayList<Boid> boids)
  {
    float neighborDist = 50;
    PVector sum = new PVector(0, 0); // Starts with empty vector to acquire all positions
    int count = 0;
    
    for (Boid other: boids)
    {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighborDist) && (other.col == col)) // Used to seperate Flocks by color
      {
        sum.add(other.position); // Add position
        count++;
      }
    }
    
    if (count > 0) 
    {
      sum.div(count); 
      return seek(sum); // Steers towards position
    }
    else 
    {
      return new PVector(0, 0);
    }
  }
  
  void flock(ArrayList<Boid> boids)
  {
    PVector sep = separate(boids); // Seperation
    PVector ali = align(boids); // Alignment
    PVector coh = cohesion(boids); // Cohesion
    
    // Arbitrarily weight the forces
    sep.mult(seperationValue);
    ali.mult(alignmentValue);
    coh.mult(cohesionValue);
    
    // Add the force vectors to acceleration 
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void update()
  {
    velocity.add(acceleration); // Increase velocity
    velocity.limit(maxSpeed); // Limit maximum speed
    position.add(velocity); 
    acceleration.mult(0); // Reset acceleration to 0 after each cycle
  }
  
  void applyForce(PVector force)
  {
    acceleration.add(force);
  }
  
  void borders() 
  {
    if (position.x < -r) position.x = width - menuSize + r;
    if (position.y < -r) position.y = height + r;
    if (position.x > width - menuSize + r) position.x = -r; 
    if (position.y > height + r) position.y = -r;
  }
  
  void render()
  {
    // Draw triangle that will be rotated in direction of velocity
    float theta = velocity.heading2D() + radians(90);
        
    fill(col);
    stroke(color(0, 0, 0));
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r * 2);
    vertex(-r, r * 2);
    vertex(r, r * 2);
    endShape();
    popMatrix();
  }
  
  void run(ArrayList<Boid> boids)
  {
    if (unpause)
    {
      flock(boids);
      update();
      borders();
    }
    render();
  }
}
