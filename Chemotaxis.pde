ArrayList<Particle> particles;
boolean showBubbles;

void setup(){
  size(1000,1000);
  particles = new ArrayList<Particle>();
  particles.add(new Particle(500,500, true));
  showBubbles = false;
}

void draw(){
  background(150);
  int changeX,changeY;
  for(Particle particle:particles){
    changeX = particle.getBiasX(particles);
    changeY = particle.getBiasY(particles);
    if(!particle.wouldCollide(particles, particle.getX()+changeX, particle.getY()+changeY))
      particle.move(changeX + rand(-5,5), changeY + rand(-5,5));
    else
      particle.move(rand(-5,5), rand(-5,5));
    particle.show();
  }
}

void mousePressed(){
  if(mouseButton == LEFT)
    particles.add(new Particle(mouseX,mouseY, true));
  else
    particles.add(new Particle(mouseX,mouseY, false));
}  
void keyPressed(){
  if(key == 32)
    showBubbles = !showBubbles;
  
  if(key == ENTER || key == RETURN)
    particles.clear();
}


int rand(int start, int end){
  return((int)(Math.random()*(difference(start, end)+1))+start);
}
int difference(int a, int b){
  return(Math.abs(a-b));
}
int distanceBetween(int x1, int y1, int x2, int y2){
  return((int)Math.sqrt(Math.pow(difference(x1,x2),2) + Math.pow(difference(y1,y2),2)));
}


class Particle{
  int x, y;
  int[] rgb;
  boolean charge;
  Particle(int startX,int startY, boolean charge){
    x = startX;
    y = startY;
    this.charge = charge;
  }
  void show(){
    if(charge){
      stroke(255,0,0);
      fill(255,0,0);
    }
    else{
      stroke(0,0,255);
      fill(0,0,255);
    }
    ellipse(x,y,25,25);
    if(showBubbles){
      if(charge)
        fill(255,0,0, 15);
      else
        fill(0,0,255, 15);
      ellipse(x,y,500,500);
    }
  }
  void move(int changeX, int changeY){
    x+=changeX;
    y+=changeY;
    if(x>1000)
      x=1000;
    if(x<0)
      x=0;
    if(y>1000)
      y=1000;
    if(y<0)
      y=0;
  }
  int getBiasX(ArrayList<Particle> particles){
    int countRight = 0;
    int countLeft = 0;
    int influence;
    for(Particle particle:particles){
      influence = (1000-distanceBetween(x, y, particle.getX(), particle.getY()))/200;
        
      if(particle.getX()>x){
        if(this.charge != particle.getCharge())
          countRight += influence;
        else
          countRight -= influence;
      }
      if(particle.getX()<x){
        if(this.charge != particle.getCharge())
          countLeft += influence;
        else
          countLeft -= influence;
      }
    }
    return(countRight-countLeft);
  }
  int getBiasY(ArrayList<Particle> particles){
    int countBelow = 0;
    int countAbove = 0;
    int influence;
    for(Particle particle:particles){        
      influence = (1000-distanceBetween(x, y, particle.getX(), particle.getY()))/200;
      
      if(particle.getY()>y){
        if(this.charge != particle.getCharge())
          countAbove += influence;
        else
          countAbove -= influence;
      }
      if(particle.getY()<y){
        if(this.charge != particle.getCharge())
          countBelow += influence;
        else
          countBelow -= influence;
      }
    }
    return(countAbove-countBelow);
  }
  boolean wouldCollide(ArrayList<Particle> particles, int proposedX, int proposedY){
    for(Particle particle:particles){
      if(particle != this && distanceBetween(proposedX, proposedY, particle.getX(), particle.getY())<25)
        return true;
    }
    return false;
  }
  int getX(){
    return x;
  }
  int getY(){
    return y;
  }
  boolean getCharge(){
    return charge;
  }
}
