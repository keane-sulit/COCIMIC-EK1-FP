/*
This is a firmware code for the project,
"A Simple Temperature-Controlled Fan using PIC16F877A".

This code is written in mikroC PRO for PIC compiler.
Build 2023.04.12 08:32 PM

*/

// LCD module connections
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
// End LCD module connections

// Keypad module connections
// char keypadPort at PORTB;
// End Keypad module connections

// Define global variables
char txtTemp[16];        // Temperature value
char txtSpd[16];         // Speed value
unsigned int tempValue;  // Temperature value
unsigned int spdValue;   // Fan speed value
char i;                  // Loop variable
unsigned short mode;     // 0 = Auto, 1 = Manual

// Initialization function
void init() {
    Lcd_Init();        // Initialize LCD library
    ADC_Init();        // Initialize ADC library
    TRISB = 0xF0;      // Set RB4-RB7 as input (Keypad)
    PORTB = 0x00;      // Set RB4-RB7 as low
    TRISC.f0 = 0;      // Set RC0 as output (Motor driver input 1)
    PWM1_Init(25000);  // Initialize PWM1 module at 25KHz
}

// Start fan function
void startFan() {
    PORTC.f0 = 1;                         // Set RB1 high
    PWM1_Start();                         // Start PWM1 module
    PWM1_Set_Duty(255 * spdValue / 100);  // Set PWM1 duty cycle
}

// Stop fan function
void stopFan() {
    PORTC.f0 = 0;  // Set RB1 low
    PWM1_Stop();   // Stop PWM1 module
}

// Read temperature function
void readTemp() {
    tempValue = ADC_Read(0);     // Read ADC value at channel 0
    tempValue = tempValue * 5;   // Convert ADC value to voltage
    tempValue = tempValue / 10;  // Convert voltage to temperature

    // Temperature value handling
    if (tempValue < 32) {              // If temperature is below 32F
        tempValue = 0;                 // Set temperature to 0
        IntToStr(tempValue, txtTemp);  // Convert temperature to string

        // Display temperature
        Lcd_Out(1, 7, "   C ");  // Display Celsius sign
        Lcd_Out(1, 12, "(-)");   // Display negative sign
        Lcd_Out(2, 9, "  ");     // Clear values using space

    } else {                    // If temperature is above 32F
        Lcd_Out(1, 12, "   ");  // Clear values using space

        // Convert temperature to Celsius
        tempValue = tempValue - 32;
        tempValue = tempValue * 5;
        tempValue = tempValue / 9;
        IntToStr(tempValue, txtTemp);  // Convert temperature in Celsius to string
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
    if (tempValue < 26) {  // If temperature is below 26C, turn off fan
        spdValue = 0;
        Lcd_Out(2, 9, " ");
        stopFan();
    } else if (tempValue < 29) {  // If temperature is between 26C and 29C, set fan speed to 10%
        spdValue = 10;
        startFan();
    } else if (tempValue < 32) {  // If temperature is between 29C and 32C, set fan speed to 30%
        spdValue = 30;
        startFan();
    } else if (tempValue < 35) {  // If temperature is between 32C and 35C, set fan speed to 50%
        spdValue = 50;
        startFan();
    } else if (tempValue < 38) {  // If temperature is between 35C and 38C, set fan speed to 70%
        spdValue = 70;
        startFan();
    } else if (tempValue < 41) {  // If temperature is between 38C and 41C, set fan speed to 90%
        spdValue = 90;
        startFan();
    } else if (tempValue < 50) {  // If temperature is between 41C and 50C, set fan speed to 100%
        spdValue = 100;
        startFan();
    } else {  // If temperature is above 50C, show warning message (!)
        spdValue = 100;
        Lcd_Out(1, 12, "(!)");
    }
}

// Display speed function
void dispSpd() {
    IntToStr(spdValue, txtSpd);  // Convert speed to string

    // Display speed
    Lcd_Out(2, 1, "Speed: ");

    // Display speed value
    if (spdValue < 100) {  // If speed is less than 100, clear 3rd digit using space
        Lcd_Out(2, 8, ltrim(txtSpd));
        Lcd_Out(2, 10, " ");
        Lcd_Out(2, 11, "%");
    } else {  // If speed is 100, as is
        Lcd_Out(2, 8, ltrim(txtSpd));
        Lcd_Out(2, 11, "%");
    }

    // Display speed status
    if (spdValue == 0) {  // If speed is 0, display OFF
        Lcd_Out(2, 13, "OFF ");
    } else if (spdValue < 33) {     // If speed is between 0 and 33, display LOW
        Lcd_Out(2, 13, "LOW ");
    } else if (spdValue < 66) {     // If speed is between 33 and 66, display MID
        Lcd_Out(2, 13, "MID ");
    } else if (spdValue <= 99) {    // If speed is between 66 and 99, display HIGH
        Lcd_Out(2, 13, "HIGH");
    } else {                        // If speed is 100, display MAX
        Lcd_Out(2, 13, "MAX ");
    }
}

// Keypad function
char keypadKey(char row, char col) {
    // Return key value
    if (col == 0) {
        if (row == 0) {
            return '1';
        } else if (row == 1) {
            return '4';
        } else if (row == 2) {
            return '7';
        } else if (row == 3) {
            return '*';
        }
    } else if (col == 1) {
        if (row == 0) {
            return '2';
        } else if (row == 1) {
            return '5';
        } else if (row == 2) {
            return '8';
        } else if (row == 3) {
            return '0';
        }
    } else if (col == 2) {
        if (row == 0) {
            return '3';
        } else if (row == 1) {
            return '6';
        } else if (row == 2) {
            return '9';
        } else if (row == 3) {
            return '#';
        }
    }
}

// Keypad scan function
char keypadScan() {
    for (i = 0; i < 4; i++) {
        // Scan rows
        if (i == 0) {
            PORTB = 1;
        } else if (i == 1) {
            PORTB = 2;
        } else if (i == 2) {
            PORTB = 4;
        } else if (i == 3) {
            PORTB = 8;
        }

        // Scan columns
        if (PORTB.f4) {
            return keypadKey(i, 0);
        } else if (PORTB.f5) {
            return keypadKey(i, 1);
        } else if (PORTB.f6) {
            return keypadKey(i, 2);
        }
    }
}

// Keypad input function
unsigned int keypad(int kp) {
    // Convert key to number
    switch (kp) {
        case '1':
            return 1;
            break;
        case '2':
            return 2;
            break;
        case '3':
            return 3;
            break;
        case '4':
            return 4;
            break;
        case '5':
            return 5;
            break;
        case '6':
            return 6;
            break;
        case '7':
            return 7;
            break;
        case '8':
            return 8;
            break;
        case '9':
            return 9;
            break;
        case '0':
            return 10;
            break;
        case '*':
            return 11;
            break;
        case '#':
            return 12;
            break;
    }
}

// Manual fan control function
unsigned int manualFanControl(int kp) {
    // Toggle manual fan control
    switch (kp) {
        case 1:
            spdValue = 10;  // Set speed to 10% if 1 is pressed
            startFan();
            break;
        case 2:
            spdValue = 20;  // Set speed to 20% if 2 is pressed
            startFan();
            break;
        case 3:
            spdValue = 30;  // Set speed to 30% if 3 is pressed
            startFan();
            break;
        case 4:
            spdValue = 40;  // Set speed to 40% if 4 is pressed
            startFan();
            break;
        case 5:
            spdValue = 50;  // Set speed to 50% if 5 is pressed
            startFan();
            break;
        case 6:
            spdValue = 60;  // Set speed to 60% if 6 is pressed
            startFan();
            break;
        case 7:
            spdValue = 70;  // Set speed to 70% if 7 is pressed
            startFan();
            break;
        case 8:
            spdValue = 80;  // Set speed to 80% if 8 is pressed
            startFan();
            break;
        case 9:
            spdValue = 90;  // Set speed to 90% if 9 is pressed
            startFan();
            break;
        case 10:
            spdValue = 100;  // Set speed to 100% if * is pressed
            startFan();
            break;
        case 11:
            mode = 1;  // Set mode to manual if * is pressed
            break;
        case 12:
            mode = 0;  // Set mode to auto if # is pressed
            break;
    }
}

// Mode function
void modeControl() {
    // Mode handling
    if (mode == 1) {                        // If mode is manual
        Lcd_Out(1, 1, "               M");  // Clear temperature reading and display M on LCD
        dispSpd();                          // Display speed based on keypad input
    } else {
        Lcd_Out(1, 16, "A");  // Display A on LCD
        readTemp();           // Read temperature
        dispTemp();           // Display temperature
        dispSpd();            // Display speed
        autoFanControl();     // Control fan speed based on temperature
    }
}

// Main function
void main() {
    init();                                              // Initialize
    while (1) {                                          // Endless loop
        PORTB = manualFanControl(keypad(keypadScan()));  // Manual fan control
        modeControl();                                   // Control mode
    }
}