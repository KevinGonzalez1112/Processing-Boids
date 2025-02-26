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

// Creating sliders to assign the Flocks and Boids
Slider setNumberOfFlocks;
Slider setBoidsPerFlock;

// Creating variables for the sliders
int numberOfFlocksValue = 0;
int boidsPerFlockValue = 0;

// Assign random colours to the six possible Flocks
color[] colors = new color[] 
{
  color(127, 0, 22), // Dark Red
  color(254, 198, 1), // Yellow
  color(96, 167, 64), // Green 
  color(11, 30, 63), // Dark Blue
  color(177, 111, 99), // Background
  color(56, 51, 54) // Beak
};

// Used to pause simulation 
boolean unpause = true;

// Set size for sidebar
int menuSize = 742;

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

  // Creating sliders to control the number of Flocks and how many Boids are in a flock 
  setNumberOfFlocks = cp5.addSlider("numberOfFlocksValue", 0, 6, 0, 1043, 332, 100, 20).setLabel("Number Of Flocks");
  setBoidsPerFlock = cp5.addSlider("boidsPerFlockValue", 0, 40, 0, 1043, 362, 100, 20).setLabel("Boids in a Flock");
  
  // Creating a button to run the simulation Flocks
  cp5.addButton("populateSimulation").setPosition(1064, 422).setSize(150, 20).setLabel("Populate Simulation");
  
  // Creating a button to pause the simulation
  cp5.addButton("pauseSimulation").setPosition(1064, 452).setSize(150, 20).setLabel("Pause Simulation");
  
  // Creating a button to end the simulation
  cp5.addButton("endSimulation").setPosition(1064, 482).setSize(150, 20).setLabel("Reset Simulation");
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
}

void populateSimulation()
{
  setNumberOfFlocks();
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
  
  // Clear the canvas drawing
  boidsDrawing = createImage(WIDTH, HEIGHT, RGB);
}

void setNumberOfFlocks()
{
  if (numberOfFlocksValue != 0)
  {
    for (int i = 1; i <= numberOfFlocksValue; i = i + 1)
    { 
      setBoidsPerFlock(i);
    }
  }   
}

void setBoidsPerFlock(int i)
{
  for (int j = 1; j <= boidsPerFlockValue; j = j + 1)
  {
    // Create a new Boid with a colour from the array created
    flock.addBoid(new Boid(300, 300, colors[i - 1]));
  }
}
