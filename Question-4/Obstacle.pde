class Obstacle extends Boid
{
  Obstacle(float x, float y, color col)
  {
    super(x, y, col);
  }
  
  @Override
  void render()
  {
    fill(0, 0, 0);
    stroke(color(0, 0, 0));
    square(position.x - 5, position.y - 5, 10);
  }
  
  @Override
  void run(ArrayList<Boid> boids)
  {
    render();
  }
}
