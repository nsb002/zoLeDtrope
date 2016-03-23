int ledPin = 7;  // LED connected to digital pin
unsigned int nbrMoy = 8;

unsigned int nbrFlashByTach = 15;

unsigned int nbrTachByRev = 2*nbrMoy;
unsigned int nbrTachByRevCount = 0;

unsigned int nbrTachSkipByRev = 1; // *-1 to animate in reverse (high speed fan needed)

unsigned int lastTachCount = 65535;
unsigned int lastTachTime = 0;

unsigned int flashTimeOn = 8;
unsigned int flashTimeOnCount = 0;

unsigned int flashTimeOff = 0;
unsigned int flashTimeOffCount = 0;

void setup()
{
  pinMode(EI2, INPUT); // set External interrupt pin as INPUT
  // On Wiring S pin 18
  // On Wiring v1 pin 2
  pinMode(ledPin, OUTPUT);  // set ledPin pin as output

  digitalWrite(ledPin, LOW);

  attachInterrupt(EXTERNAL_INTERRUPT_2, tachFunction, FALLING);
}

void loop()
{
  delayMicroseconds(15);
  if (lastTachCount < 65535) { // int between 0 to 65535
    lastTachCount++;

    if (flashTimeOnCount < flashTimeOn) {
        flashTimeOnCount++;
        flashTimeOffCount++;
        digitalWrite(ledPin, HIGH);
    }
    else {
      if (flashTimeOffCount < flashTimeOff) {
        flashTimeOffCount++;
        digitalWrite(ledPin, LOW);
      }
      else {
        flashTimeOnCount = 0;
        flashTimeOffCount = 0;
      }
    }
  }
}

void tachFunction()
{
  if (++nbrTachByRevCount >= nbrTachByRev) {
    nbrTachByRevCount = 0;

    lastTachTime = lastTachCount / nbrMoy;
    lastTachCount = 0;

    flashTimeOff = abs(lastTachTime/nbrFlashByTach + lastTachTime*nbrTachSkipByRev);
  }
}
