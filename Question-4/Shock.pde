class Shock
{
  PVector position;
  
  Shock(int x, int y)
  {
    position = new PVector(x, y);
  }
  
  void affect()
  {
    fill(0, 255, 255);
    ellipse(position.x, position.y, 100, 100);
  }
}
