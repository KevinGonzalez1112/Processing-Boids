class Obstacle extends Particle
{
  Obstacle(PVector p, PVector v, color col)
  {
    super(p, v, col);
    this.col = color(255, 255, 255);
    radius = 15;
  }
  
  @Override 
  void move(PVector posG)
  {
  }
}
