// The Target class
class Target
{
 
  // self
 float x;
 float y;
 float dx; 
 float dy;
 float radius;
 color col;
 
 // bounds
 float minXBound; 
 float minYBound; 
 float maxXBound; 
 float maxYBound;
 
 Target(float x, float y, float dx, float dy, float radius, float minX, float minY, float maxX, float maxY)
 {
   this.x = x; 
   this.y= y; 
   this.dx = dx; 
   this.dy = dy;
   this.radius = radius;
   this.col = color(255, 255, 0);
   
   //set the bounds
   this.minXBound = minX; 
   this.maxXBound = maxX;
   this.minYBound = minY; 
   this.maxYBound = maxY;
 }
 
 void deviate()
 {
   float beta=random(-0.5, 0.5);
   
   float mod = sqrt(dx * dx + dy * dy);
   float dxx = dx/mod;
   float dyy = dy/mod;
   dx = dxx * cos(beta) + dyy * sin(beta); 
   dx *= mod;
   dy = -dxx * sin(beta) + dyy * cos(beta); 
   dy*=mod;
 }
 
 void move()
 {
   deviate();
    
   float xdx = x + dx;
   float ydy = y + dy;
     
   if (xdx<minXBound || xdx>maxXBound)
   {
     this.dx = -this.dx;
   }
   if (ydy<minYBound || ydy>maxYBound)
   {
     this.dy = -this.dy;
   }
    
   x += dx;
   y += dy;
 }
 
 void display()
 {
   fill(col);
   circle(x,y,radius);
   // move();
 }
}
