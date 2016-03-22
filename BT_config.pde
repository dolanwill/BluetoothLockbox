#define ROBOT_NAME "BlackBox"

// If you haven't configured your device before use this
// #define BLUETOOTH_SPEED 9600
// If you are modifying your existing configuration, use this:
#define BLUETOOTH_SPEED 57600

#include <SoftwareSerial.h>

// Swap RX/TX connections on bluetooth chip
//   Pin 10 --> Bluetooth TX
//   Pin 11 --> Bluetooth RX
SoftwareSerial BTSerial(10, 11); // RX, TX


/*
  The posible baudrates are:
    AT+BAUD1-------1200
    AT+BAUD2-------2400
    AT+BAUD3-------4800
    AT+BAUD4-------9600 - Default for hc-06
    AT+BAUD5------19200
    AT+BAUD6------38400
    AT+BAUD7------57600 - Johnny-five speed
    AT+BAUD8-----115200
    AT+BAUD9-----230400
    AT+BAUDA-----460800
    AT+BAUDB-----921600
    AT+BAUDC----1382400
*/


void setup()
{
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for Leonardo only
  }
  Serial.println("Starting config");
  BTSerial.begin(BLUETOOTH_SPEED);
  delay(1000);

  // Should respond with OK
  BTSerial.print("AT");
  Serial.print("AT");
  waitForResponse();

  // Should respond with its version
  BTSerial.print("AT+VERSION");
  Serial.print("AT+VERSION");
  waitForResponse();

  // Set pin to 0000
  BTSerial.print("AT+PIN0000");
  Serial.print("AT+PIN0000");
  waitForResponse();

  // Set the name to ROBOT_NAME
  BTSerial.print("AT+NAME");
  Serial.print("AT+NAME");
  BTSerial.print(ROBOT_NAME);
  waitForResponse();

  // Set baudrate to 57600
  BTSerial.print("AT+BAUD7");
  Serial.print("AT+BAUD7");
  waitForResponse();

  Serial.println("Done!");
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

void loop() {}