/*
This is a firmware code for the project,
"A Simple Temperature-Controlled Fan using PIC16F877A".

This code is written in mikroC PRO for PIC compiler.
Build 2023.04.14 12:33 AM
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

// Define global variables
char txtTemp[16];         // Temperature value
char txtSpd[16];          // Speed value
unsigned int tempValue;   // Temperature value
unsigned int spdValue;    // Fan speed value
char i;                   // Loop variable
unsigned short mode = 0;  // 0 = Auto, 1 = Manual
unsigned int key;         // Keypad value
unsigned int keyFlag;     // Keypad flag

// Initialization function
void init() {
    Lcd_Init();        // Initialize LCD library
    ADC_Init();        // Initialize ADC library
    TRISB = 0xF0;      // Set RB4-RB7 as input (Keypad)
    TRISD = 0x00;      // Set RD0-RD7 as output (LED)
    PORTB = 0x0F;      // Set RB4-RB7 as low
    TRISC.f0 = 0;      // Set RC0 as output (Motor driver input 1)
    PWM1_Init(25000);  // Initialize PWM1 module at 25KHz
}

// Interrupt initialization function
void initInterrupt() {
    INTCON.f7 = 1;  // Enable global interrupt
    INTCON.f6 = 1;  // Enable peripheral interrupt
    INTCON.f3 = 1;  // Enable RB port change interrupt
    INTCON.f0 = 1;  // Enable RB0 interrupt

    OPTION_REG.f7 = 0;  // Enable pull-up
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
    } else if (spdValue < 33) {  // If speed is between 0 and 33, display LOW
        Lcd_Out(2, 13, "LOW ");
    } else if (spdValue < 66) {  // If speed is between 33 and 66, display MID
        Lcd_Out(2, 13, "MID ");
    } else if (spdValue <= 99) {  // If speed is between 66 and 99, display HIGH
        Lcd_Out(2, 13, "HIGH");
    } else {  // If speed is 100, display MAX
        Lcd_Out(2, 13, "MAX ");
    }
}

// Keypad scan function
void keypadScan() {
    key = 0;       // Clear key value
    PORTB.F0 = 0;
    delay_ms(1);
    PORTB.F0 = 1;
    PORTB.F1 = 0;
    delay_ms(1);
    PORTB.F1 = 1;
    PORTB.F2 = 0;
    delay_ms(1);
    PORTB.F2 = 1;
    PORTB.F3 = 0;
    delay_ms(1);
    PORTB.F3 = 1;
}

void keypad() {
    if (keyFlag == 1) {
        if (key == 10) {
            mode = 1;
        } else if (key == 11) {
            mode = 0;
        }
    }
}

// Manual fan control function
void manualFanControl() {
    if (keyFlag == 1) {
        keyFlag = 0;  // Clear keyFlag
        if (key == 1) {
            spdValue = 10;
        } else if (key == 2) {
            spdValue = 20;
        } else if (key == 3) {
            spdValue = 30;
        } else if (key == 4) {
            spdValue = 40;
        } else if (key == 5) {
            spdValue = 50;
        } else if (key == 6) {
            spdValue = 60;
        } else if (key == 7) {
            spdValue = 70;
        } else if (key == 8) {
            spdValue = 80;
        } else if (key == 9) {
            spdValue = 90;
        } else if (key == 12) {
            spdValue = 100;
        }
        startFan();
    }
}

// Mode function
void modeControl() {
    // Mode handling
    if (mode == 1) {                        // If mode is manual
        Lcd_Out(1, 1, "               M");  // Clear temperature reading and display M on LCD
        dispSpd();                          // Display speed based on keypad input
        manualFanControl();                 // Control fan speed based on keypad input
    } else {
        Lcd_Out(1, 16, "A");  // Display A on LCD
        readTemp();           // Read temperature
        dispTemp();           // Display temperature
        dispSpd();            // Display speed
        autoFanControl();     // Control fan speed based on temperature
    }
}

// Interrupt function
void interrupt() {
    INTCON.f7 = 0;  // Clear GIE

    // ISR for PORTB change
    if (INTCON.f0 == 1) {
        if (PORTB.f4 == 0) {  // If RB4 is low
            keyFlag = 1;      // Set keyFlag
            delay_ms(100);    // Debounce button
            if (PORTB.f0 == 0) {
                key = 1;  // Set keypad value to 1
            } else if (PORTB.f1 == 0) {
                key = 4;  // Set keypad value to 4
            } else if (PORTB.f2 == 0) {
                key = 7;  // Set keypad value to 7
            } else if (PORTB.f3 == 0) {
                key = 10;  // Set keypad value to 10 (*)
            }
        }

        if (PORTB.f5 == 0) {
            keyFlag = 1;    // Set keyFlag
            delay_ms(100);  // Debounce button
            if (PORTB.f0 == 0) {
                key = 2;  // Set keypad value to 2
            } else if (PORTB.f1 == 0) {
                key = 5;  // Set keypad value to 5
            } else if (PORTB.f2 == 0) {
                key = 8;  // Set keypad value to 8
            } else if (PORTB.f3 == 12) {
                key = 12;  // Set keypad value to 12
            }
        }

        if (PORTB.f6 == 0) {
            keyFlag = 1;    // Set keyFlag
            delay_ms(100);  // Debounce button
            if (PORTB.f0 == 0) {
                key = 3;  // Set keypad value to 3
            } else if (PORTB.f1 == 0) {
                key = 6;  // Set keypad value to 6
            } else if (PORTB.f2 == 0) {
                key = 9;  // Set keypad value to 9
            } else if (PORTB.f3 == 0) {
                key = 11;  // Set keypad value to 11 (#)
            }
        }

        INTCON.f0 = 0;  // Clear RBIF
    }
    INTCON.f7 = 1;  // Set GIE
}

// Main function
void main() {
    init();             // Initialize
    initInterrupt();    // Initialize interrupt
    while (1) {         // Endless loop
        keypadScan();   // Scan keypad
        keypad();       // Keypad function
        modeControl();  // Control mode
    }
}