import controlP5.*;

ControlP5 cp5;

// Creating a blank Flock
Flock flock;

// Weight and Height of image
final int WIDTH = 512;
final int HEIGHT = 512;

// Create background image
PImage backingImage;

// Create image drawn by Boids
PImage boidsDrawing;

color selectedPixel;

// Used to pause simulation 
boolean unpause = true;

// Set size for sidebar
int menuSize = 742;

// Variables that control updating velocity in Particles
float omega;
float c1;
float c2;

Swarm swarm;

Target target;

ObstacleP obstacle;

boolean dropObstacle = true;

int maxInitialVelocity = 3;

void setup()
{
  // Set the size of the display
  size(1254, 512); 
    
  // Initialize a new flock
  flock = new Flock(); 

  cp5 = new ControlP5(this); 

  backingImage = loadImage("Boids-Background.jpg");
  backingImage.resize(WIDTH, HEIGHT);
  
  boidsDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < boidsDrawing.pixels.length; i++)
  {
    boidsDrawing.pixels[i] = color(255);
  }
  
  boidsDrawing.updatePixels();
  
  // Creating a button to run the simulation Flocks
  cp5.addButton("populateSimulation").setPosition(1064, 422).setSize(150, 20).setLabel("Populate Simulation");
  
  // Creating a button to pause the simulation
  cp5.addButton("pauseSimulation").setPosition(1064, 452).setSize(150, 20).setLabel("Pause Simulation");
  
  // Creating a button to end the simulation
  cp5.addButton("endSimulation").setPosition(1064, 482).setSize(150, 20).setLabel("Reset Simulation");
  
  // Setting the variables
  omega = 4;
  c1 = 4;
  c2 = 0.12;
  
  swarm = new Swarm();

  // Creation of Target
  target = new Target(30, 460, random(2,4), random(2,4), 10, 0, 100, WIDTH, HEIGHT);
  
  obstacle = new ObstacleP(new PVector(100, 100), new PVector(random(-maxInitialVelocity, maxInitialVelocity), random(-maxInitialVelocity, maxInitialVelocity)), color(0));
  
  // Creating a button to end the simulation
  cp5.addButton("dropObstacle").setPosition(1064, 30).setSize(150, 20).setLabel("Switch On Click");
}

void draw()
{
  // Set the panel background color
  background(128, 128, 128);
  
  // Create the background image
  image(backingImage, 0, 0);
  
  // Create the Boids drawn image
  image(boidsDrawing, WIDTH, 0);
  
  // Create pixels array
  backingImage.loadPixels();
     
  // Updates the Boids drawing as they pass over image sections of their color
  boidsDrawing.updatePixels();
   
  // Initialises the created flock 
  flock.run();
  
  swarm.run();
  
  target.display();
  
  obstacle.display();
}

void populateSimulation()
{
  setNumberOfFlocks();
  setNumberOfSwarms();
}

void pauseSimulation()
{
  // Will flip the value of unpause
  // Between TRUE and FALSE
  unpause = !unpause;
}

void endSimulation()
{
  // Remove all created Flocks
  flock.clearBoids();
  swarm.clearParticles();
  
  boidsDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < boidsDrawing.pixels.length; i++)
  {
    boidsDrawing.pixels[i] = color(255);
  }
  
  boidsDrawing.updatePixels();
}

void setNumberOfFlocks()
{
  for (int i = 1; i <= 1; i = i + 1)
  { 
    setBoidsPerFlock(i);
  } 
}

void setBoidsPerFlock(int i)
{
  for (int j = 1; j <= 60; j = j + 1)
  {
    // Create a new Boid with a colour from the array created
    flock.addBoid(new Boid(300, 300, color(254, 198, 1)));
  }
}

void setNumberOfSwarms()
{
  if (5 != 0)
  {
    for (int i = 1; i <= 5; i = i + 1)
    {
      setNumberOfParticlesPerSwarm(i);
    }
  }
}

void setNumberOfParticlesPerSwarm(int i)
{
  int maxInitialVelocity = 3;
  
  for (int j = 0; j < 20; j++)
  {
    swarm.addParticle(new Particle(new PVector(100, 100), new PVector(random(-maxInitialVelocity, maxInitialVelocity), random(-maxInitialVelocity, maxInitialVelocity)), color(254, 198, 1)));
  }
}

boolean inBound(int x, int y)
{
  boolean inbound = false;
  
  if (x > 0 && x < WIDTH && y > 0 && y < HEIGHT)
  {
    inbound = true;
  }
  
  return inbound;
}

void dropObstacle()
{
  dropObstacle = !dropObstacle;
}

void mousePressed()
{
  if (dropObstacle)
  {
    // If statement stops the user from being able to place obstacles in the menu bar
    if (mouseX < width - menuSize && unpause)
    {
      Shock shock = new Shock(mouseX, mouseY);
      shock.affect();
      
      // Add an Obstacle in that will interfere with the boids and cause them to avoid it
      flock.addBoid(new Obstacle(mouseX, mouseY, color(0, 0, 0)));
      
      // Add an Obstacle in that will interfere with the Particle and cause them to avoid it
      swarm.addObstacle(new ObstacleP(new PVector(mouseX, mouseY), new PVector(random(-maxInitialVelocity, maxInitialVelocity), random(-maxInitialVelocity, maxInitialVelocity)), color(255)));
    }
  }
  else
  {
    // If statement stops the user from being able to place obstacles in the menu bar
    if (mouseX < width - menuSize && unpause)
    {
      Shock shock = new Shock(mouseX, mouseY);
      shock.affect();
    
      // Creation of Target
      target = new Target(mouseX, mouseY, random(2,4), random(2,4), 10, 0, 100, WIDTH, HEIGHT);
    
      for (Particle par: swarm.swarm)
      {
        swarm.gBest = -10000000;
        par.pBest = -10000000;
      }
    }
  }
}
