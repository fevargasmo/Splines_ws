/**
 * Splines.
 *
 * Here we use the interpolator.keyFrames() nodes
 * as control points to render different splines.
 *
 * Press ' ' to change the spline mode.
 * Press 'g' to toggle grid drawing.
 * Press 'c' to toggle the interpolator path drawing.
 * Press 'b' to toggle the interpolator path with Bezie
 * Press 'h' to toggle the interpolator path with Hermite
 */

import frames.input.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

// global variables
// modes: 0 natural cubic spline; 1 Hermite;
// 2 (degree 7) Bezier; 3 Cubic Bezier
int mode;

Scene scene;
Interpolator interpolator;
OrbitNode eye;
boolean drawGrid = true, drawCtrl = true, drawBezie= false, drawHermite= false;

//Choose P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;
ArrayList<Float> point = new ArrayList<Float>();
ArrayList<Node> ctrlPoints = new ArrayList<Node>();
void setup() {
  size(800, 800, renderer);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(0);
  scene = new Scene(this);
  eye = new OrbitNode(scene);
  eye.setDamping(0);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.setRadius(150);
  scene.fitBallInterpolation();
  interpolator = new Interpolator(scene, new Frame());
  // framesjs next version, simply go:
  //interpolator = new Interpolator(scene);

  // Using OrbitNodes makes path editable
  
  for (int i = 0; i < 4; i++) {
    Node ctrlPoint = new OrbitNode(scene);
    ctrlPoint.randomize();  
    interpolator.addKeyFrame(ctrlPoint);
    
    ctrlPoints.add(ctrlPoint);
    
    point.add(ctrlPoint.position().x());
    point.add(ctrlPoint.position().y());
    point.add(ctrlPoint.position().z());
    println(ctrlPoint.position());
  }
  
}

void draw() {
  background(175);
  text(myText, 0, 0, width, height);
  if (drawGrid) {
    stroke(255, 255, 0);
    scene.drawGrid(200, 50);
  }
  if (drawCtrl) {
    fill(255, 0, 0);
    stroke(255, 0, 255);
    for (Frame frame : interpolator.keyFrames())
      scene.drawPickingTarget((Node)frame);
      
  }
  if(drawBezie){
    updatePoints();
     cubicBezier(point.get(0), point.get(1), point.get(2),point.get(3), point.get(4),point.get(5),point.get(6), point.get(7), point.get(8),point.get(9), point.get(10),point.get(11));
  }
  if(drawHermite){
    updatePoints();
     hermite(point.get(0), point.get(1), point.get(2),point.get(9), point.get(10),point.get(11),40,41,41,40,-40,-60);     
  }
  else {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    scene.drawPath(interpolator);
  }
  // implement me
  // draw curve according to control polygon an mode
  // To retrieve the positions of the control points do:
  int contador = 0;
  for(Frame frame : interpolator.keyFrames()){
    contador++;
   //println("punto " + frame +" "+  frame.position().x());
  }
  
  println(myText);
}



void updatePoints(){
  point.clear();
  for(Node i : ctrlPoints){
    point.add(i.position().x());
    point.add(i.position().y());
    point.add(i.position().z());
  }   
    
}

//Hermite
class point
{
float x,y,z;
};

void hermite(float x0, float y0, float z0,float x1, float y1, float z1,float r0x,float r0y,float r0z,float r1x,float r1y,float r1z)
{
  ArrayList<point> pts = new ArrayList<point>();
  strokeWeight(1);
  float x,y,z,t;
  double h00,h01,h10,h11, aux1, aux2;
  //(1+2*s)*(1-s)^2*(1)+s*(1-s)^2*(1)+s^2*(3-2*s)*(4)+s^2*(s-1)*(1)
  for(t=0.0;t<=1.0;t+=.001)
  {
    //las cuatro funciones bases de hermite 
    //auxiliares
    aux1=Math.pow(1-t, 2);
    aux2=Math.pow(t,2);
    //funciones
    h00=(1+2*t)*aux1;
    h10=t*aux1;
    h01=aux2*(3-2*t);
    h11=aux2*(t-1);
    
    x=(float)(h00*x0+h10*r0x+h01*x1+h11*r1x);
    y=(float)(h00*y0+h10*r0y+h01*y1+h11*r1y);
    z=(float)(h00*z0+h10*r0z+h01*z1+h11*r1z);
    stroke(0,0,254);
    
    //println(x + " " + y);
    //line(x,y,z,x,y,z);
    point pt = new point();
    pt.x = x;
    pt.y = y;
    pt.z = z;
    pts.add(pt);
   }
   
   
   strokeWeight(1);
  for(int i=0;i<pts.size() -1;i++){    
    // 2D
    //line(pts.get(i).x, pts.get(i).y, pts.get(i+1).x, pts.get(i+1).y);
    //println(pts.get(i).x + " " + pts.get(i).y + " " + pts.get(i+1).x + " "+ pts.get(i+1).y + " " );
    //3D
    
    stroke(0,0,254);
    line(pts.get(i).x, pts.get(i).y, pts.get(i).z, pts.get(i+1).x, pts.get(i+1).y, pts.get(i+1).z);
    
  }
}

//Bezie
class NodeOur{
  float x;
  float y;
  float z;
  
}

void cubicBezier(float x0, float y0, float z0,float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3){
  ArrayList<NodeOur> pts = new ArrayList<NodeOur>();
  double n=20.0;
  for(int i=0; i<n+1; i++){    
    double t = i / n;
    //println("soy t: " + t);
    double a = Math.pow(1-t, 3);
    double b = 3 * t * Math.pow(1-t, 2);
    double c = 3 * Math.pow(t, 2) * (1-t);
    double d = Math.pow(t, 3); 
    
    double xt = (a * (double)x0 + b * (double)x1 + c * (double)x2 + d * (double)x3);
    double yt = (a * (double)y0 + b * (double)y1 + c * (double)y2 + d * (double)y3);
    double zt = (a * (double)z0 + b * (double)z1 + c * (double)z2 + d * (double)z3);
    float x = (float)xt;
    float y = (float)yt;
    float z = (float)zt;
    //println(x + " "+ y + " "+ z) ;
    NodeOur pt = new NodeOur();
    pt.x = x;
    pt.y = y;
    pt.z = z;
    pts.add(pt); 
    //println(pt);
  }
  strokeWeight(1);
  for(int i=0;i<n;i++){    
    // 2D
    //line(pts.get(i).x, pts.get(i).y, pts.get(i+1).x, pts.get(i+1).y);
    //println(pts.get(i).x + " " + pts.get(i).y + " " + pts.get(i+1).x + " "+ pts.get(i+1).y + " " );
    //3D
    
    stroke(0,0,254);
    line(pts.get(i).x, pts.get(i).y, pts.get(i).z, pts.get(i+1).x, pts.get(i+1).y, pts.get(i+1).z);
    
  }
}



void changeCP(int nodeId, float x, float y, float z){
   Node n0 = ctrlPoints.get(nodeId);
   //println(x +" "+ y + " "+z);
   n0.setPosition(x,y,z);
}

 String myText = ""; 

void keyPressed() {
  if (key == ' ')
    mode = mode < 3 ? mode+1 : 0;
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
   if (key == 'b')
     drawBezie = !drawBezie;
   if (key == 'h')
     drawHermite = !drawHermite;
   
     
   
   if (keyCode == BACKSPACE) {
    if (myText.length() > 0) {
      myText = myText.substring(0, myText.length()-1);
    }
  } else if (keyCode == DELETE) {
    myText = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT) {
    myText = myText + key;
  } if (keyCode == ENTER) {
    String[] parts = myText.split(" ");
    changeCP(Integer.parseInt(parts[0]),Float.parseFloat(parts[1]), Float.parseFloat(parts[2]), Float.parseFloat(parts[3]));
    myText = "";
  }
   
    
}
