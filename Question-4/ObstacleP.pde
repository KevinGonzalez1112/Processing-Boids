class ObstacleP extends Particle
{
  ObstacleP(PVector p, PVector v, color col)
  {
    super(p, v, col);
    this.col = color(255, 255, 255);
    radius = 12;
  }
  
  @Override 
  void move(PVector posG)
  {
  }
}
