//import processing libraries 
import processing.sound.*;  
import processing.serial.*;  
//sound source + fft analyzer 
SoundFile sample;   
FFT fft; 
AudioDevice device;
//arduino
Serial myPort;  

//import serial data from arduino
int potState;
int[] inputVars = {0, 0}; //make array to be populated from serial (note number of variables)
//stores the spectrum data/ variables for drawing the data
float[] spectrum =new float[4];
float a, b, c, d;
//creates the vizualization of the music 
float smoothingFactor = 0.2;

public void setup() {
  size(640, 360);  
  
//load soundfile + loop
  sample = new SoundFile(this, "calmsong.mp3"); 
  sample.loop();
  
  

//creates the fft analyzer and connects the music to it 
  fft = new FFT(this, 4);
  fft.input(sample);

  
//arduino to processing stuff
  String portName = Serial.list()[2]; 
  myPort = new Serial(this, portName, 9600);
  println(Serial.list());
  myPort.bufferUntil('\n'); // don't generate a serialEvent() unless you get a newline character
}      

public void draw() {
  background(0, 0, 0);
  
  fft.analyze();
  
  sample.amp(map(inputVars[0],0,1023,0,1));

   spectrum[0] += (fft.spectrum[0] - spectrum[0]) * smoothingFactor;
   spectrum[1] += (fft.spectrum[1] - spectrum[1]) * smoothingFactor;
   spectrum[2] += (fft.spectrum[2] - spectrum[2]) * smoothingFactor;
   spectrum[3] += (fft.spectrum[3] - spectrum[3]) * smoothingFactor;
   
   a = spectrum[0]*height*4;
   b = spectrum[1]*height*4;
   c = spectrum[2]*height*4;
   d = spectrum[3]*height*4;
   
   strokeWeight(map(inputVars[0],0,1023,0,100));
   
   stroke(255,0,0); 
   line( width/4 - 50, height, width/4 - 50, height - a );
   
   stroke(0,255,0);
   line( 2*width/4 - 50, height, 2*width/4 - 50, height - b);
   
   stroke(0,0,255);
   line( width - 50, height, width - 50, height - c );
   
   stroke(255,255,0);
   line( 3* width/4 - 50, height, 3*width/4- 50, height - d );
    
    myPort.write((int)a % 255);
    myPort.write((int)b % 255);
    myPort.write((int)c % 255);
    myPort.write((int)d % 255);
    
    
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n'); //read until new line (Serial.println on Arduino)
  if (inString != null) {
    inString = trim(inString); // trim off whitespace
    inputVars = int(split(inString, '&')); // break string into an array and change strings to ints
    println(inString);
}
}
