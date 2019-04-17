int led1 = 2;
int led2 = 3;
int led3 = 4;
int led4 = 5;
int potPin = A2;
int potState = 0;

int a=0;
int b=0;
int c=0;
int d=0;

void setup() {                
  pinMode(led1, OUTPUT);   
  pinMode(led2, OUTPUT);  
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  pinMode(potPin, INPUT);
  Serial.begin (9600);   
}

void loop() {
  potState = analogRead(potPin);    // read the value from the sensor
  if (Serial.available() > 0) {
                a = Serial.read();
                b = Serial.read();
                c = Serial.read();
                d = Serial.read();
                
                analogWrite(led1, a);
                analogWrite(led2, b);
                analogWrite(led3, c); 
                analogWrite(led4, d);
  }
  delay(100);
Serial.println(potState);

}
