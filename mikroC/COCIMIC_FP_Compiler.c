/*
This is a firmware code for the project, "A Simple Temperature-Controlled Fan using PIC16F877A".
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

char txtTemp[16];
char txtSpd[16];

unsigned short kp;

unsigned int tempValue;
unsigned int spdValue;

char i;                              // Loop variable
char shift;                          // Shift variable

unsigned short mode;             // 0 = Auto, 1 = Manual

void init() {
    // Initialize LCD library
    Lcd_Init();
    ADC_Init();
    Keypad_Init();
    TRISD = 0xFF;
    TRISB.f1 = 0; // Set RB1 as output for PWM1
    PWM1_Init(25000);
}

void startFan() {
    PORTB.f1 = 1;
    PWM1_Start();
    PWM1_Set_Duty(255*spdValue/100);
}

void stopFan() {
    PORTB.f1 = 0;
    PWM1_Stop();
}

void readTemp() {
    tempValue = ADC_Read(0);
    tempValue = tempValue * 5;    // Convert ADC value to voltage
    tempValue = tempValue / 10;  // Convert voltage to temperature

    if (tempValue < 32) {
        tempValue = 0;
        IntToStr(tempValue, txtTemp);
        Lcd_Out(1, 7, "   C ");
        Lcd_Out(1, 12, "(-)");
        Lcd_Out(2, 9, "  ");
    } else {
        Lcd_Out(1, 12, "   ");
        // Convert Fahrenheit to Celsius
        tempValue = tempValue - 32;
        tempValue = tempValue * 5;
        tempValue = tempValue / 9;

        // Convert temperature to string
        IntToStr(tempValue, txtTemp);
    }
}

void dispTemp() {
    Lcd_Out(1, 1, "Temp: ");
    Lcd_Out(1, 7, ltrim(txtTemp));
    Lcd_Out(1, 10, "C");
}

void autoFanControl() {
    if (tempValue < 26) {
        spdValue = 0;
        Lcd_Out(2, 9, " ");
        stopFan();
    } else if (tempValue < 29) {
        spdValue = 10;
        startFan();
    } else if (tempValue < 32) {
        spdValue = 30;
        startFan();
    } else if (tempValue < 35) {
        spdValue = 50;
        startFan();
    } else if (tempValue < 38) {
        spdValue = 70;
        startFan();
    } else if (tempValue < 41) {
        spdValue = 90;
        startFan();
    } else if (tempValue < 50) {
        spdValue = 100;
        startFan();
    } else {
        stopFan();
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1, 1, "TOO HOT!");
        Lcd_Out(2, 1, "FAN STOP!");
        delay_ms(300);
    }
}

void dispSpd() {
    IntToStr(spdValue, txtSpd);             // Convert speed to string

    // Display speed
    Lcd_Out(2, 1, "Speed: ");
    
    if (spdValue < 100) {
        Lcd_Out(2, 8, ltrim(txtSpd));
        Lcd_Out(2, 10, " ");
        Lcd_Out(2, 11, "%");
    } else {
        Lcd_Out(2, 8, ltrim(txtSpd));
        Lcd_Out(2, 11, "%");
    }

    // Display ON/OFF status
    if (spdValue == 0) {
        Lcd_Out(2, 13, "OFF ");
    } else if (spdValue < 33) {
        Lcd_Out(2, 13, "LOW "); 
    } else if (spdValue < 66) {
        Lcd_Out(2, 13, "MID "); 
    } else if (spdValue <= 99) {
        Lcd_Out(2, 13, "HIGH");
    } else {
        Lcd_Out(2, 13, "MAX "); 
    }
}

void keypad() {
    kp = 0;
    kp = Keypad_Key_Click();
    if (kp != 0) {
        switch (kp) {
            case 1: // 1
                spdValue = 10;
                startFan();
                break;
            case 2: // 2
                spdValue = 20;
                startFan();
                break;
            case 3: // 3
                spdValue = 30;
                startFan();
                break;
            case 5: // 4
                spdValue = 40;
                startFan();
                break;
            case 6: // 5
                spdValue = 50;
                startFan();
                break;
            case 7: // 6
                spdValue = 60;
                startFan();
                break;
            case 9: // 7
                spdValue = 70;
                startFan();
                break;
            case 10: // 8
                spdValue = 80;
                startFan();
                break;
            case 11: // 9
                spdValue = 90;
                startFan();
                break;
            case 13: // *
                mode = 1;
                break;
            case 14: // 0
                spdValue = 100;
                startFan();
                break;
            case 15: // #
                mode = 0;
                break;

        }
    }
}

void welcome() {
    Lcd_Out(1, 1, "COCIMIC-EK1 TERM 2 PROJECT");
    Lcd_Out(2, 1, "Dayrit | Guevarra | Rodriguez | Sulit");
    for (i = 0; i < 22; i++) {
        Lcd_Cmd(_LCD_SHIFT_LEFT);
        delay_ms(10);
    }
    Lcd_Cmd(_LCD_CLEAR);
}

void main() {
    init();
    welcome();
    while(1) {                              // Endless loop
        keypad();
        if (mode == 1) {
            Lcd_Out(1, 1, "               M");
            dispSpd();
            keypad();
        } else {
            Lcd_Out(1, 16, "A");
            readTemp();
            dispTemp();
            dispSpd();
            autoFanControl();
        }
    }
}