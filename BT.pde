#define ROBOT_NAME "BlackBox"
#define PASSWORD   "openbox"

// If you haven't configured your device before use this
// #define BLUETOOTH_SPEED 9600
// If you are modifying your existing configuration, use this:
#define BLUETOOTH_SPEED 57600
#define LOCK 1
#define UNLOCK 180

#include <SoftwareSerial.h>
#include <Servo.h>

// Swap RX/TX connections on bluetooth chip
//   Pin 10 --> Bluetooth TX
//   Pin 11 --> Bluetooth RX
SoftwareSerial BTSerial(10, 11); // RX, TX
Servo myservo;  // create servo object to control a servo 


void setup()
{
        pinMode(8, OUTPUT); //outputs high voltage to pin 8 to power the servo
        digitalWrite(8, HIGH);
        myservo.attach(9);  // attaches the servo on pin 9 to the servo object 
        myservo.write(LOCK);

        Serial.begin(9600);
        while (!Serial) {
        ; // wait for serial port to connect. Needed for Leonardo only
        }
        Serial.println("Starting config!");
        BTSerial.begin(BLUETOOTH_SPEED);
        delay(1000);

        // Should respond with OK
        BTSerial.print("AT");
        Serial.println("AT");
        waitForResponse();

        // Should respond with its version
        BTSerial.print("AT+VERSION");
        Serial.println("AT+VERSION");
        waitForResponse();

        Serial.println("Ready!");

        //now wait for any input in the main loop
  
}

void loop() {

        getPassword();

}

void getPassword() {
        while(!BTSerial.available()){
        delay(50);
        }
        delay(3000); //delay for them to finish typing
        char password[20];
        int i = 0;
        while(BTSerial.available()) {
                password[i] = (char)BTSerial.read();
                Serial.write(password[i]);
                i++;
        }
 
        bool match = true;
        for(int j = 0; j < 4; j++){
                Serial.print(password[j]);
                if (password[j] != PASSWORD[j]){
                        match = false;
                }
        }
        if (match){
                unlock();
        }
        else{
                lock();
        }

        Serial.write("\n");
}

void unlock() {
        myservo.write(UNLOCK);
        Serial.println("unlocked! congratulations!");
}

void lock() {
        myservo.write(LOCK);
        Serial.println("blackbox locked.");
}

void waitForResponse() {
        delay(1000);
        while(!BTSerial.available()){
        delay(50);
        }
        while (BTSerial.available()) {
        Serial.write(BTSerial.read());
        }
        Serial.write("\n");
}