/*
This is a firmware code for the project, "A Simple Temperature-Controlled Fan using PIC16F877A".
*/

// LCD module connections
sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
// End LCD module connections

char txtTemp[10];
char txtSpd[10];

unsigned int tempValue;
unsigned int spdValue;

char i;                              // Loop variable

void Move_Delay() {                  // Function used for text moving
  Delay_ms(500);                     // You can change the moving speed here
}


void init() {
    // Initialize LCD library
    Lcd_Init();
    ADC_Init();
    TRISB.f1 = 0; // Set RB1 as output for PWM1
    PWM1_Init(25000);
}

void readTemp() {
    tempValue = ADC_Read(0);
    tempValue = tempValue * 5;    // Convert ADC value to voltage
    tempValue = tempValue / 10;  // Convert voltage to temperature

    // Convert Fahrenheit to Celsius
    tempValue = tempValue - 32;
    tempValue = tempValue * 5;
    tempValue = tempValue / 9;

    // Convert temperature to string
    IntToStr(tempValue, txtTemp);
}

void dispTemp() {
    Lcd_Out(1, 1, "Temp: ");
    delay_ms(10);
    Lcd_Out(1, 7, ltrim(txtTemp));
    Lcd_Out(1, 10, "C");
    delay_ms(10);
}

void fanControl() {
    if (tempValue > 30) {       // If temperature is greater than 30C
        PORTB.f1 = 1;
        PWM1_Start();
        PWM1_Set_Duty(100);
    } else {
        PORTB.f1 = 0;
        PWM1_Stop();
    }
}

void dispSpd() {
    Lcd_Out(2, 1, "Speed: ");
    delay_ms(10);
    Lcd_Out(2, 8, ltrim(txtSpd));
    delay_ms(10);
}

void main() {
    init();

    while(1) {                         // Endless loop
        readTemp();
        // LCD Output
        dispTemp();

        fanControl();
    }
}