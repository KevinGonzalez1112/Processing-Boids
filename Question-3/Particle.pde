// Particle class

class Particle
{
  // Particle position
  PVector pos;
  // Particle velocity
  PVector vel;
  // Particle position so far
  PVector posB;
  // Particle best position
  float pBest;
  
  float radius;
  
  color col;
  
  // Particle max velocity
  float maxVel = 5;
  
  // Used in Sobel Filtering 
  float[][] hsob = {{ +1, 0, -1}, 
                    { +2, 0, -2}, 
                    { +1, 0, -1}};
                    
  float[][] vsob = {{ +1, +2, +1}, 
                    { 0, 0, 0}, 
                    { -1, -2, -1}};
                    
  PVector acceleration;
  
  // The Particle Constructor
  Particle(PVector p, PVector v, color col)
  {
    pos = p.copy();
    vel = v.copy();
    pBest = -10000000;
    radius = 10;
    posB = pos.copy(); 
    this.col = col;
    acceleration = new PVector(0, 0);
  }
  
  void wraparound()
  {
    if (pos.x > WIDTH) 
    {
      pos.x = WIDTH - pos.x;
    }
    if (pos.y > HEIGHT) 
    {
      pos.y = HEIGHT - pos.y;
    }
    if (pos.x < 0) 
    {
      pos.x = WIDTH + pos.x;
    }
    if (pos.y < 0) 
    {
      pos.y = HEIGHT + pos.y;
    }  
  }
  
  void curbvel()
  {
    if (sqrt(vel.x * vel.x + vel.y * vel.y) > 10)
    {
      vel.normalize();
      vel.mult(maxVel);
    }
  }
  
  void display()
  {
    fill(col);
    circle(pos.x, pos.y, radius);
  }
  
  void move(PVector posG)
  {
    // vel (t + 1) = omega * vel(t) + ...
    vel = PVector.mult(vel, omega);
    
    // c1 * rand(1) * (posB - pos) + ...
    vel = PVector.add(vel, PVector.mult(PVector.sub(posB, pos), c1 * random(1)));
    
    // c2 * rand(1) * (posG - pos)
    vel = PVector.add(vel, PVector.mult(PVector.sub(posG, pos), c2 * random(1)));
    
    swarmApply(swarm.obstacles);
    
    // pos(t + 1) = pos(t) + vel(t)
    curbvel();
    
    pos = PVector.add(pos, vel);
    
    if (!inBound((int)pos.x, (int)pos.y))
    {
      wraparound();
    }
  }
  
  // fitness function
  float evaluate()
  {
    // evaluating personal best
    float val = funcedge();
    
    if (pBest < val)
    {
      pBest = val;
      posB = pos.copy();
    }
    
    return pBest;
  }
  
  void sobel()
  {
    float hsum, vsum;
    hsum = vsum = 0;
    
    for (int i = -1; i <= 1; i++)
    {
      for (int j = -1; j <= 1; j++)
      {
        if ((pos.x > 1) && (pos.x < WIDTH - 1) && (pos.y > 1) && (pos.y < HEIGHT - 1))
        {
          color c = backingImage.get(int(pos.x + i), int(pos.y + j));
          float g = red(c) + green(c) + blue(c);
          g /= 3.0;
          
          hsum += hsob[i + 1][j + 1] * g;
          vsum += vsob[i + 1][j + 1] * g;
        }
      }
    }

    float s = 255 * sqrt(hsum * hsum + vsum * vsum)/(sqrt(2) * 244);

    particleDrawing.set(int(pos.x), int(pos.y), color(255 - s));
  }
  
  float funcedge()
  {
    // Get target location 
    PVector targetLocation = new PVector(target.x, target.y);
    
    return -(this.pos.dist(targetLocation));
  }
  
  // Checks for nearby Boids and steers away to avoid collision
  PVector separate(ArrayList<Obstacle> obstacles)
  {
    float desiredSeparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    float maxSpeed = 2.0;
    float maxForce = 10;
    float angle = random(TWO_PI);
    PVector velocity = new PVector(cos(angle), sin(angle));
    
    // Get every Boid in the system and check if its too close
    for (Particle other: obstacles)
    {
      float d = PVector.dist(pos, other.pos);
      // If distance is greater than 0 and less than an arbituary amount
      if ((d > 0) && (d < desiredSeparation))
      {
        // Calculate vector pointing away from neighbouring Boid
        PVector diff = PVector.sub(pos, other.pos);
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
  
  void swarmApply(ArrayList<Obstacle> obstacles)
  {
    PVector sep = separate(obstacles); // Seperation
    
    sep.mult(10000.0);
    
    applyForce(sep);
  }
  
  void applyForce(PVector force)
  {
    vel.add(force);
  }
}
