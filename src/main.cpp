#include <Arduino.h>

void setup(void)
{
    pinMode(LED_BUILTIN, OUTPUT);
}

void loop(void)
{
    delay(500);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(500);
    digitalWrite(LED_BUILTIN, LOW);
}