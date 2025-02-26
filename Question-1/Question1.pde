import controlP5.*;

ControlP5 cp5;

// Creating a blank Flock
Flock flock;

// Creating sliders to assign the Flocks and Boids
Slider setNumberOfFlocks;
Slider setBoidsPerFlock;
Slider setSeperation;
Slider setAlignment;
Slider setCohesion;
Slider setMaxSpeed;
Slider setMaxForce;

// Creating variables for the sliders
int numberOfFlocksValue = 0;
int boidsPerFlockValue = 0;
float seperationValue = 0;
float alignmentValue = 0;
float cohesionValue = 0;
float maxSpeedValue = 0;
float maxForceValue = 0;

// Assign random colours to the six possible Flocks
color[] colors = new color[] 
{
  color(255, 0, 0), // Red Flock
  color(0, 255, 0), // Green Flock
  color(0, 0, 255), // Dark Blue Flock
  color(255, 0, 255), // Pink Flock
  color(255, 255, 0), // Yellow Flock
  color(0, 255, 255) // Cyan Flock
};

// Used to pause simulation 
boolean unpause = true;

// Set size for sidebar
int menuSize = 250;

void setup()
{
  // Set the size of the display
  size(1200, 800); 
    
  // Create a new flock
  flock = new Flock(); 

  cp5 = new ControlP5(this); 

  // Creating sliders to control the number of Flocks and how many Boids are in each flock 
  setNumberOfFlocks = cp5.addSlider("numberOfFlocksValue", 0, 6, 0, 1000, 360, 100, 20).setLabel("Number Of Flocks");
  setBoidsPerFlock = cp5.addSlider("boidsPerFlockValue", 0, 40, 0, 1000, 390, 100, 20).setLabel("Boids in a Flock");
  
  // Creating sliders to control Flocking behaviour
  setSeperation = cp5.addSlider("seperationValue", 0.0, 5.0, 0, 1000, 450, 100, 20).setLabel("Seperation");
  setAlignment = cp5.addSlider("alignmentValue", 0.0, 3.0, 0, 1000, 480, 100, 20).setLabel("Alignment");
  setCohesion = cp5.addSlider("cohesionValue", 0.0, 3.0, 0, 1000, 510, 100, 20).setLabel("Cohesion");
  
  // Creating sliders to control individual Boid behaviour
  setMaxSpeed = cp5.addSlider("maxSpeedValue", 0.0, 4.0, 0, 1000, 570, 100, 20).setLabel("Max Speed");
  setMaxForce = cp5.addSlider("maxForceValue", 0.0, 0.08, 0, 1000, 600, 100, 20).setLabel("Max Force");
  
  // Creating a button to populate the simulation with Flocks
  cp5.addButton("populateSimulation").setPosition(1000, 690).setSize(150, 20).setLabel("Populate Simulation");
  
  // Creating a button to pause the simulation
  cp5.addButton("pauseSimulation").setPosition(1000, 720).setSize(150, 20).setLabel("Pause Simulation");
  
  // Creating a button to reset the simulation
  cp5.addButton("endSimulation").setPosition(1000, 750).setSize(150, 20).setLabel("Reset Simulation");
}

void draw()
{
  // Set the background color
  background(128, 128, 128);
  
  // Set text colour
  fill(255, 255, 255);
  
  // Create labels for panel
  text("Flocks + Boids:", 1000, 345);
  text("Boid Behaviour:", 1000, 555);
  text("Flocking Behaviour:", 1000, 435);
    
  // Run the created 
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

void mousePressed()
{
  // If statement stops the user from being able to place obstacles in the menu bar
  if (mouseX < width - menuSize && unpause)
  {
    Shock shock = new Shock(mouseX, mouseY);
    shock.affect();
    
    // Add an Obstacle in that will interfere with the boids and cause them to avoid it
    flock.addBoid(new Obstacle(mouseX, mouseY, color(0, 0, 0)));
  }
}
