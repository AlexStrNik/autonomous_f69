
#include <Servo.h>

Servo steering;
Servo rear;

#define STEERING_MIN (50)
#define STEERING_MAX (130)

#define FULL_THROTTLE (1700)
#define FULL_STOP (1500)
#define FULL_REVERSE (1200)

#define MIN_THROTTLE (1580)
#define MIN_REVERSE (1400)

#define REAR_STOP_BYTE (131)

void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
  Serial.begin(115200);

  steering.attach(PA8);
  rear.attach(PA9);
  digitalWrite(LED_BUILTIN, HIGH);
  rear.writeMicroseconds(1500);
  delay(3000);
  digitalWrite(LED_BUILTIN, LOW);
  steering.write(STEERING_MIN + 50);
}

int lastRearSpeed = 1500;
void loop() {
  // we wait until 2 bytes
  if (Serial.available() > 1) {
    int motorType = Serial.read();
        if (motorType == 255) return;
    int motorSpeedRaw = Serial.read();
        if (motorSpeedRaw == 255) return;

    if (motorType == 's') {
      steering.write(STEERING_MIN + (80 - motorSpeedRaw));
      digitalWrite(LED_BUILTIN, HIGH);
//      Serial.print("steer");
//      Serial.println(motorSpeedRaw);
    } else if (motorType == 'r') {
      int motorSpeed = 0;
      if (motorSpeedRaw < REAR_STOP_BYTE) {
        motorSpeed = map(motorSpeedRaw, 0, 130,FULL_REVERSE, MIN_REVERSE);
      } else if (motorSpeedRaw == REAR_STOP_BYTE) {
        motorSpeed = FULL_STOP;
      } else {
//        Serial.print("rev");
        motorSpeed = map(motorSpeedRaw - REAR_STOP_BYTE, 0, 80, MIN_THROTTLE, FULL_THROTTLE);
      }

      if (motorSpeed < FULL_STOP && lastRearSpeed >= FULL_STOP) {
//        Serial.print("comp");
        rear.writeMicroseconds(FULL_STOP);
        delay(200);
        rear.writeMicroseconds(FULL_REVERSE);
        delay(200);
        rear.writeMicroseconds(FULL_STOP);
        delay(200);
      }
      rear.writeMicroseconds(motorSpeed);
      lastRearSpeed = motorSpeed;

//      Serial.print("rear");
      digitalWrite(LED_BUILTIN, LOW);
      Serial.println(motorSpeed);
    }
  }
}