import controlP5.*;

ControlP5 cp5;

// Backing image for Swarms
PImage backingImage;

// Create the image drawn by Particles
PImage particleDrawing;

// Width and Height of image
final int WIDTH = 512;
final int HEIGHT = 512;

// Variables that control updating velocity
float omega;
float c1;
float c2;

// Assign random colours to the six possible Flocks
color[] colors = new color[] 
{
  color(255, 0, 0), // Red Swarm
  color(0, 255, 0), // Green Swarm
  color(0, 0, 255), // Dark Blue Swarm
  color(255, 0, 255), // Pink Swarm
  color(255, 255, 0), // Yellow Swarm
  color(0, 255, 255) // Cyan Swarm
};

// The particle Swarm
Swarm swarm;

Target target;

Obstacle obstacle;

int maxInitialVelocity = 3;

Slider setNumberOfSwarms;
Slider setNumberOfParticlesPerSwarm;

int numberOfSwarmsValue = 0;
int numberOfParticlesPerSwarmValue = 0;

boolean unpause = true;

boolean dropObstacle = true;

void setup()
{
  // Image and Swarm will be displayed seperately
  size(1254, 512);  
  
  cp5 = new ControlP5(this); 
  
  // Loading image
  backingImage = loadImage("greyScale.jpg");
  
  // Resizing the image
  backingImage.resize(WIDTH, HEIGHT);
  
  // Creating Particle drawing
  particleDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < particleDrawing.pixels.length; i++)
  {
    particleDrawing.pixels[i] = color(255);
  }
  
  particleDrawing.updatePixels();
  
  // Setting the variables
  omega = 4;
  c1 = 4;
  c2 = 0.12;
  
  // Creation of Swarm
  swarm = new Swarm();
  
  // Creation of Target
  target = new Target(random(200,300), random(200,300), random(2,4), random(2,4), 10, 0, 100, WIDTH, HEIGHT);
  
  obstacle = new Obstacle(new PVector(100, 100), new PVector(random(-maxInitialVelocity, maxInitialVelocity), random(-maxInitialVelocity, maxInitialVelocity)), color(0));
  
  swarm.addObstacle(obstacle);
  
  setNumberOfSwarms = cp5.addSlider("numberOfSwarmsValue", 0, 6, 0, 1034, 332, 100, 20).setLabel("Number of Swarms");
  setNumberOfParticlesPerSwarm = cp5.addSlider("numberOfParticlesPerSwarmValue", 0, 40, 0, 1034, 362, 100, 20).setLabel("Particles per Swarm");
  
  // Creating a button to run the simulation Flocks
  cp5.addButton("populateSimulation").setPosition(1064, 422).setSize(150, 20).setLabel("Populate Simulation");
  
  // Creating a button to pause the simulation
  cp5.addButton("pauseSimulation").setPosition(1064, 452).setSize(150, 20).setLabel("Pause Simulation");
  
  // Creating a button to end the simulation
  cp5.addButton("endSimulation").setPosition(1064, 482).setSize(150, 20).setLabel("Reset Simulation");
  
  // Creating buttons so the backing image can be changed
  cp5.addButton("imageOne").setPosition(1064, 30).setSize(150, 20).setLabel("Image 1");
  cp5.addButton("imageTwo").setPosition(1064, 60).setSize(150, 20).setLabel("Image 2");
  cp5.addButton("imageThree").setPosition(1064, 90).setSize(150, 20).setLabel("Image 3");
  
  // Creating a button to end the simulation
  cp5.addButton("dropObstacle").setPosition(1064, 120).setSize(150, 20).setLabel("Switch On Click");
}

void draw()
{
  // Set background color
  background(128);
  
  // Image covers half the screen 
  image(backingImage, 0, 0);
  
  // Image covers other half
  image(particleDrawing, WIDTH, 0);
  
  backingImage.loadPixels();
  
  swarm.run();

  target.display();
  
  obstacle.display();
}

void imageOne()
{
  // Loading image
  backingImage = loadImage("greyScale.jpg");
  
  // Resizing the image
  backingImage.resize(WIDTH, HEIGHT);
  
  // Creating Particle drawing
  particleDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < particleDrawing.pixels.length; i++)
  {
    particleDrawing.pixels[i] = color(255);
  }
  
  particleDrawing.updatePixels();
}

void imageTwo()
{
  // Loading image
  backingImage = loadImage("greyScale2.jpg");
  
  // Resizing the image
  backingImage.resize(WIDTH, HEIGHT);
  
  // Creating Particle drawing
  particleDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < particleDrawing.pixels.length; i++)
  {
    particleDrawing.pixels[i] = color(255);
  }
  
  particleDrawing.updatePixels();
}

void imageThree()
{
  // Loading image
  backingImage = loadImage("greyScale3.jpg");
  
  // Resizing the image
  backingImage.resize(WIDTH, HEIGHT);
  
  // Creating Particle drawing
  particleDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < particleDrawing.pixels.length; i++)
  {
    particleDrawing.pixels[i] = color(255);
  }
  
  particleDrawing.updatePixels();
}

void populateSimulation()
{
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
  swarm.clearParticles();
  
  // Creating Particle drawing
  particleDrawing = createImage(WIDTH, HEIGHT, RGB);
  
  for (int i = 0; i < particleDrawing.pixels.length; i++)
  {
    particleDrawing.pixels[i] = color(255);
  }
  
  particleDrawing.updatePixels();
}

void setNumberOfSwarms()
{
  if (numberOfSwarmsValue != 0)
  {
    for (int i = 1; i <= numberOfSwarmsValue; i = i + 1)
    {
      setNumberOfParticlesPerSwarm(i);
    }
  }
}

void setNumberOfParticlesPerSwarm(int i)
{
  for (int j = 0; j < numberOfParticlesPerSwarmValue; j++)
  {
    swarm.addParticle(new Particle(new PVector(100, 100), new PVector(random(-maxInitialVelocity, maxInitialVelocity), random(-maxInitialVelocity, maxInitialVelocity)), colors[i - 1]));
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
    if (mouseX < width - 742 && unpause)
    {
      Shock shock = new Shock(mouseX, mouseY);
      shock.affect();
      
      // Add an Obstacle in that will interfere with the boids and cause them to avoid it
      swarm.addObstacle(new Obstacle(new PVector(mouseX, mouseY), new PVector(random(-maxInitialVelocity, maxInitialVelocity), random(-maxInitialVelocity, maxInitialVelocity)), color(255)));
    }
  }
  else
  {
    // If statement stops the user from being able to place obstacles in the menu bar
    if (mouseX < width - 742 && unpause)
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
