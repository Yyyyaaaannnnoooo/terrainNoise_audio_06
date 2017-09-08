import ddf.minim.*; 
import ddf.minim.analysis.*;  
Minim minim;   
FFT fft;  
AudioInput in;   
float amp = 15;
float ampWave = 10*amp; 
float avgAudio;
float bass; 
float mid; 
float high;
float r = .0001;
int edges = 2;
float rEllipse = 150;
int numPoints = 100;
int modulo = 0;
int counter = 0;
float factor;
int cols, rows, scl = 10;
int w = 1200;
int h = 1200;
float [][] terrain;
float [][] midTerrain;
float flying=0, rot=0, rot2 = 0;
float flying2 = 0;
float off = 0;
PVector[][] globe;
int total = 50;
boolean sw = false;
float offset = 0;
float z, angle;
float m = 0;
float mchange = 0;
int num = 1000;
float[] xx = new float [num];
float[] yy = new float [num];
float[] zz = new float [num];
float[] x1 = new float [num];
float[] y1 = new float [num];
float[] z1 = new float [num];
void setup() {
  size(900, 900, P3D);
  rectMode(CENTER);
  globe = new PVector[total+1][total+1];
  cols = w/scl;
  rows = h/scl;
  terrain = new float [cols][rows];
  midTerrain = new float [cols][rows];
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());  
  fft.logAverages(22, 3);
}

void draw() {
  angle+=.03;//controls wavy ondulation
  z=lerp( cos(angle), sin(angle), .001);
  background (0);
  translate(0, 0, -2000);
  //float alpha = map(mouseX, 0, width, 0, 255);
  //float alpha = 255;
  //fill(0, alpha);
  //rect(0, 0, 10000, 10000);
  fft.forward(in.mix);
  for (int i = 0; i < fft.avgSize(); i++) {  
    avgAudio+= abs(fft.getAvg(i)*amp);
  }    
  avgAudio /= fft.avgSize(); 
  bass = fft.calcAvg(0, 1000)*amp;
  mid = fft.calcAvg(1000, 5000)*amp;
  high = fft.calcAvg(5000, 20000)*amp;
  println(high,mid);
  ///////////////////TERRAIN/////////////////////
  float incFly = map(high, 0, 3, -.5, .5);
  float incFlyMid = map(mid, 3, 10, -.5, .5);
  flying += incFly;
  float inc = map(mouseY, 0, height, .01, .5);
  flying2 += incFlyMid;
  float yoff= flying;
  for (int y = 0; y<rows; y++) {
    float xoff=-flying;
    for (int x = 0; x<cols; x++) {
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -1, 1) * bass *30;
      midTerrain[x][y] = map(noise(xoff, yoff), 0, 1, -1, 1) * high *50;
      xoff+=inc;
    }
    yoff+= inc;
  }
  translate(width/2, height*.6, 1200);
  rotateX(PI/3);
  //rotateY(radians(rot2));
  strokeWeight(1);
  rotateZ(radians(rot));
  float sze = avgAudio * 20;
  //lights();
  //noStroke();
  //fill(0);
  //ellipse(0, 0, sze, sze);

  /*  if (sw) {
   noStroke();
   lights();
   fill(255);
   } else {
   noFill();
   stroke(255);
   }*/
  translate(-w/2, -h/2);
  lights();
  for (int y = 0; y<rows-1; y++) {
    stroke(0);
    noFill();
    beginShape(TRIANGLE_STRIP);//TRIANGLE_STRIP
    for (int x = 0; x<cols; x++) {
      vertex(x*scl, y*scl, midTerrain[x][y]);
      vertex(x*scl, (y+1)*scl, midTerrain[x][y+1]);
    }
    endShape();
  }
  for (int y = 0; y<rows-1; y++) {
    noFill();
    stroke(255);
    beginShape(TRIANGLE_STRIP);//TRIANGLE_STRIP
    for (int x = 0; x<cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();
  }
  rot += incFly;
  rot2 += .5;
}

void keyPressed() {
  if (key == 's') {
    if (sw) {
      sw = false;
    } else {
      sw = true;
    }
  }
}