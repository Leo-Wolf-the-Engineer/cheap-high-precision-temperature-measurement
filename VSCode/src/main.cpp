//Complete project details at https://RandomNerdTutorials.com/esp-now-esp32-arduino-ide/

//#include <esp_now.h>
#include <WiFi.h>
#include <MAX31865_NonBlocking.h>
#include <movingAvgFloat.h> //not sure if this is rlly needed over the normal one
#include <Ewma.h>

// uses hardware SPI, just pass in the CS pin (mandatory) and SPI bus (optional)
MAX31865 thermo1(05);
MAX31865 thermo2(16);

// The value of the Rref resistor. Use 430.0 for PT100 and 4300.0 for PT1000
#define RREF      430.0
// The 'nominal' 0-degrees-C resistance of the sensor
#define RNOMINAL  100.0

Ewma ewma1(0.02);  //lower factor = More smoothing - less prone to noise, but slower to detect changes
Ewma ewma2(0.02);  //higher factor = Less smoothing - faster to detect changes, but more prone to noise

movingAvgFloat maf1(250);
movingAvgFloat maf2(250);
float offset_t1 = -1.054824669759334;
float offset_t2 = -1.216860744018287;

float temp1;
float avg11;
float avg12;
float temp2;
float avg21;
float avg22;
 
void setup() {
  // Init Serial Monitor
  Serial.begin(115200);
  Serial.println("Initializing...");
  // Init MAX31865 comms
  thermo1.begin(MAX31865::RTD_4WIRE);
  thermo1.setConvMode(MAX31865::CONV_MODE_CONTINUOUS);
  thermo2.begin(MAX31865::RTD_4WIRE);
  thermo2.setConvMode(MAX31865::CONV_MODE_CONTINUOUS);
  // Init moving average
  maf1.begin();
  maf2.begin();
}

void loop() {
  while (thermo1.isConversionComplete() == false) {
    //Wait for the MAX31865 to complete. 
    //this allows to read multiple sensors at the full frequency instead of 
    //polling each one and waiting for the answer.
    //You can also do stuff during this time.
    //For example: plot to a display or serial print.
  }
  temp1 = thermo1.getTemperature(RNOMINAL, RREF) + offset_t1;
  avg11 = maf1.reading(temp1);
  avg12 = ewma1.filter(temp1);   // calculate the moving average
  Serial.print(temp1,9);         // print the measurement
  Serial.print(",");             // seperator
  Serial.print(avg11,9);         // print the moving average
  Serial.print(",");             // seperator
  Serial.print(avg12,9);         // print the ewma
  Serial.print(",");             //seperator

  temp2 = thermo2.getTemperature(RNOMINAL, RREF) + offset_t2;
  avg21 = maf2.reading(temp2);
  avg22 = ewma2.filter(temp2);   // calculate the moving average
  Serial.print(temp2,9);         // print the measurement
  Serial.print(",");             // seperator
  Serial.print(avg21,9);         // print the moving average
  Serial.print(",");             // seperator
  Serial.print(avg22,9);         // print the ewma
  Serial.println(";");           //seperator
}