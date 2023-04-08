/*
This is a firmware code for the project, 
"A Simple Temperature-Controlled Fan using PIC16F877A".
*/

// LCD module connections
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RC4_bit;
sbit LCD_D5 at RC5_bit;
sbit LCD_D6 at RC6_bit;
sbit LCD_D7 at RC7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISC4_bit;
sbit LCD_D5_Direction at TRISC5_bit;
sbit LCD_D6_Direction at TRISC6_bit;
sbit LCD_D7_Direction at TRISC7_bit;
// End LCD module connections

// Keypad module connections
char keypadPort at PORTD;
// End Keypad module connections

// Define global variables
char txtTemp[16];                    // Temperature value
char txtSpd[16];                     // Speed value

unsigned short kp;                   // Keypad value

unsigned int tempValue;              // Temperature value
unsigned int spdValue;               // Fan speed value

char i;                              // Loop variable
char shift;                          // Shift variable

unsigned short mode;                 // 0 = Auto, 1 = Manual

// Initialization function
void init() {
    Lcd_Init();                     // Initialize LCD library
    ADC_Init();                     // Initialize ADC library
    Keypad_Init();                  // Initialize Keypad library
    TRISD = 0xFF;                   // Set PORTD as input
    TRISB.f1 = 0;                   // Set RB1 as output for PWM1
    PWM1_Init(25000);               // Initialize PWM1 module at 25KHz
}

// Start fan function
void startFan() {
    PORTB.f1 = 1;                       // Set RB1 high
    PWM1_Start();                       // Start PWM1 module
    PWM1_Set_Duty(255*spdValue/100);    // Set PWM1 duty cycle
}

// Stop fan function
void stopFan() {
    PORTB.f1 = 0;                   // Set RB1 low
    PWM1_Stop();                    // Stop PWM1 module
}

// Read temperature function
void readTemp() {
    tempValue = ADC_Read(0);        // Read ADC value at channel 0
    tempValue = tempValue * 5;      // Convert ADC value to voltage
    tempValue = tempValue / 10;     // Convert voltage to temperature
    
    // Temperature value handling
    if (tempValue < 32) {                       // If temperature is below 32F
        tempValue = 0;                          // Set temperature to 0
        IntToStr(tempValue, txtTemp);           // Convert temperature to string
        
        // Display temperature
        Lcd_Out(1, 7, "   C ");
        Lcd_Out(1, 12, "(-)");                  // Display negative sign
        Lcd_Out(2, 9, "  ");                    // Clear values using space

    } else {                                    // If temperature is above 32F
        Lcd_Out(1, 12, "   ");                  // Clear values using space
        
        // Convert temperature to Celsius
        tempValue = tempValue - 32;
        tempValue = tempValue * 5;
        tempValue = tempValue / 9;
        IntToStr(tempValue, txtTemp);           // Convert temperature in Celsius to string
    }
}

// Display temperature function
void dispTemp() {

    // Display temperature
    Lcd_Out(1, 1, "Temp: ");
    Lcd_Out(1, 7, ltrim(txtTemp));
    Lcd_Out(1, 10, "C");
}

// Auto fan control function
void autoFanControl() {

    // Fan speed control
    if (tempValue < 26) {               // If temperature is below 26C, turn off fan
        spdValue = 0;
        Lcd_Out(2, 9, " ");
        stopFan();
    } else if (tempValue < 29) {        // If temperature is between 26C and 29C, set fan speed to 10%
        spdValue = 10;
        startFan();
    } else if (tempValue < 32) {        // If temperature is between 29C and 32C, set fan speed to 30%
        spdValue = 30;
        startFan();
    } else if (tempValue < 35) {        // If temperature is between 32C and 35C, set fan speed to 50%
        spdValue = 50;
        startFan();
    } else if (tempValue < 38) {        // If temperature is between 35C and 38C, set fan speed to 70%
        spdValue = 70;
        startFan();
    } else if (tempValue < 41) {        // If temperature is between 38C and 41C, set fan speed to 90%
        spdValue = 90;
        startFan();
    } else if (tempValue < 50) {        // If temperature is between 41C and 50C, set fan speed to 100%
        spdValue = 100;
        startFan();
    } else {                            // If temperature is above 50C, show warning message (!)
        spdValue = 100;
        Lcd_Out(1, 12, "(!)");
    }
}

// Display speed function
void dispSpd() {
    IntToStr(spdValue, txtSpd);             // Convert speed to string

    // Display speed
    Lcd_Out(2, 1, "Speed: ");
    
    // Display speed value
    if (spdValue < 100) {                   // If speed is less than 100, clear 3rd digit using space
        Lcd_Out(2, 8, ltrim(txtSpd));
        Lcd_Out(2, 10, " ");
        Lcd_Out(2, 11, "%");
    } else {                                // If speed is 100, as is
        Lcd_Out(2, 8, ltrim(txtSpd));
        Lcd_Out(2, 11, "%");
    }

    // Display speed status
    if (spdValue == 0) {                    // If speed is 0, display OFF
        Lcd_Out(2, 13, "OFF ");
    } else if (spdValue < 33) {             // If speed is between 0 and 33, display LOW
        Lcd_Out(2, 13, "LOW "); 
    } else if (spdValue < 66) {             // If speed is between 33 and 66, display MID
        Lcd_Out(2, 13, "MID ");             
    } else if (spdValue <= 99) {            // If speed is between 66 and 99, display HIGH
        Lcd_Out(2, 13, "HIGH");
    } else {                                // If speed is 100, display MAX
        Lcd_Out(2, 13, "MAX ");
    }
}

// Keypad function
void keypad() {
    kp = 0;                                 // Clear kp variable
    kp = Keypad_Key_Click();                // Read keypad value
    
    // Keypad value handling
    if (kp != 0) {                          // If keypad value is pressed
        switch (kp) {
            case 1:
                spdValue = 10;              // Set speed to 10% if 1 is pressed
                startFan();
                break;
            case 2:
                spdValue = 20;              // Set speed to 20% if 2 is pressed
                startFan();
                break;
            case 3:
                spdValue = 30;              // Set speed to 30% if 3 is pressed
                startFan();
                break;
            case 5:
                spdValue = 40;              // Set speed to 40% if 4 is pressed
                startFan();
                break;
            case 6:
                spdValue = 50;              // Set speed to 50% if 5 is pressed
                startFan();
                break;
            case 7:
                spdValue = 60;              // Set speed to 60% if 6 is pressed
                startFan();
                break;
            case 9:
                spdValue = 70;              // Set speed to 70% if 7 is pressed
                startFan();
                break;
            case 10:
                spdValue = 80;              // Set speed to 80% if 8 is pressed
                startFan();
                break;
            case 11:
                spdValue = 90;              // Set speed to 90% if 9 is pressed
                startFan();
                break;
            case 13:                        // Set mode to manual if * is pressed
                mode = 1;
                break;
            case 14:                        // Set speed to 100% if 0 is pressed
                spdValue = 100;
                startFan();
                break;
            case 15:                        // Set mode to auto if # is pressed
                mode = 0;
                break;

        }
    }
}

// Mode function
void modeControl() {

    // Mode handling
    if (mode == 1) {                                // If mode is manual
            Lcd_Out(1, 1, "               M");      // Clear temperature reading and display M on LCD
            keypad();                               // Read keypad
            dispSpd();                              // Display speed based on keypad input
        } else {
            Lcd_Out(1, 16, "A");                    // Display A on LCD
            readTemp();                             // Read temperature
            dispTemp();                             // Display temperature
            dispSpd();                              // Display speed
            autoFanControl();                       // Control fan speed based on temperature
        }
}

// Main function
void main() {
    init();                    // Initialize
    while(1) {                 // Endless loop
        keypad();              // Read keypad
        modeControl();         // Control mode
    }
}