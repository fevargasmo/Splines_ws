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
boolean drawGrid = true, drawCtrl = true, drawBezie= true;

//Choose P3D for a 3D scene, or P2D or JAVA2D for a 2D scene
String renderer = P3D;
ArrayList<Float> point = new ArrayList<Float>();
void setup() {
  size(800, 800, renderer);
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
    point.add(ctrlPoint.position().x());
    point.add(ctrlPoint.position().y());
    point.add(ctrlPoint.position().z());
    println(ctrlPoint.position());
  }
  
}

void draw() {
  background(175);
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
     cubicBezier(point.get(0), point.get(1), point.get(2),point.get(3), point.get(4),point.get(5),point.get(6), point.get(7), point.get(8),point.get(9), point.get(10),point.get(11));
  }
  else {
    fill(255, 0, 0);
    stroke(255, 0, 255);
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
}

//Hermite
class point
{
float x,y;
};

void hermite(point p1,point p4,float r1,float r4)
{
  float x,y,t;
  for(t=0.0;t<=1.0;t+=.001)
  {
    x=(2*t*t*t-3*t*t+1)*p1.x+(-2*t*t*t+3*t*t)*p4.x+(t*t*t-2*t*t+t)*r1+(t*t*t-t*t)*r4;
    y=(2*t*t*t-3*t*t+1)*p1.y+(-2*t*t*t+3*t*t)*p4.y+(t*t*t-2*t*t+1)*r1+(t*t*t-t*t)*r4;
    stroke(0,0,255);
    strokeWeight(2);
    println(x + " " + y);
    line(x,y,x,y);
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
    /*
    double d = i / n;
    double a = 1 - d;
    double b = a * a;
    double c = d * d;    
    a = a * b;
    b = 3 * b * d;
    c = 3 * a * c;
    d = c * d;
*/
    
    double xt = (a * (double)x0 + b * (double)x1 + c * (double)x2 + d * (double)x3);
    double yt = (a * (double)y0 + b * (double)y1 + c * (double)y2 + d * (double)y3);
    double zt = (a * (double)z0 + b * (double)z1 + c * (double)z2 + d * (double)z3);
    float x = (float)xt;
    float y = (float)yt;
    float z = (float)zt;
    println(x + " "+ y + " "+ z) ;
    NodeOur pt = new NodeOur();
    pt.x = x;
    pt.y = y;
    pt.z = z;
    pts.add(pt); 
    println(pt);
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





void keyPressed() {
  if (key == ' ')
    mode = mode < 3 ? mode+1 : 0;
  if (key == 'g')
    drawGrid = !drawGrid;
  if (key == 'c')
    drawCtrl = !drawCtrl;
   if (key == 'b')
     drawBezie = !drawBezie;
   
    
}
