
// Set this to whatever text you want to print
char line1[] = " Hello, world!";
char line2[] = " from Arduino";

#define line1Length (sizeof(line1)-1)
#define line2Length (sizeof(line2)-1)

void setup() {
  Serial.begin(9600);
  backlightOn();
  clearLCD();
}

void loop() {
  // write line 1
  for(int i=0;i<line1Length;i++) {
    goTo(i);
    if (line1[i] != ' ') {
      Serial.print(line1[i]);
    }
    delay(50);
  }
  
  // write line 2
  for(int i=0;i<line2Length;i++) {
    goTo(i+16);
    if (line2[i] != ' ') {
      Serial.print(line2[i]);
    }
    delay(50);
  }
  
  delay(2000);
  clearLCD();
  delay(1000);
}

// Scrolls the display left by the number of characters passed in, and waits a given
// number of milliseconds between each step
void scrollLeft(int num, int wait) {
  for(int i=0;i<num;i++) {
    serCommand();
    Serial.print(0x18, BYTE);
    delay(wait);
  }
}

// Scrolls the display right by the number of characters passed in, and waits a given
// number of milliseconds between each step
void scrollRight(int num, int wait) {
  for(int i=0;i<num;i++) {
    serCommand();
    Serial.print(0x1C, BYTE);
    delay(wait);
  }
}

// Starts the cursor at the beginning of the first line (convienence method for goTo(0))
void selectLineOne() {  //puts the cursor at line 0 char 0.
   serCommand();   //command flag
   Serial.print(128, BYTE);    //position
}

// Starts the cursor at the beginning of the second line (convienence method for goTo(16))
void selectLineTwo() {  //puts the cursor at line 0 char 0.
   serCommand();   //command flag
   Serial.print(192, BYTE);    //position
}

// Sets the cursor to the given position
// line 1: 0-15, line 2: 16-31, 31+ defaults back to 0
void goTo(int position) {
  if (position < 16) { 
    serCommand();   //command flag
    Serial.print((position+128), BYTE);
  } else if (position < 32) {
    serCommand();   //command flag
    Serial.print((position+48+128), BYTE);
  } else { 
    goTo(0); 
  }
}

// Resets the display, undoing any scroll and removing all text
void clearLCD() {
   serCommand();
   Serial.print(0x01, BYTE);
}

// Turns the backlight on
void backlightOn() {
    serCommand();
    Serial.print(157, BYTE);
}

// Turns the backlight off
void backlightOff() {
    serCommand();
    Serial.print(128, BYTE);
}

// Initiates a function command to the display
void serCommand() {
  Serial.print(0xFE, BYTE);
}
