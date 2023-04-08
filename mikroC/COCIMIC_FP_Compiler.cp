#line 1 "//Mac/Home/Documents/GitHub/COCIMIC-EK1-FP/mikroC/COCIMIC_FP_Compiler.c"
#line 6 "//Mac/Home/Documents/GitHub/COCIMIC-EK1-FP/mikroC/COCIMIC_FP_Compiler.c"
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


char txtTemp[16];
char txtSpd[16];

unsigned int tempValue;
unsigned int spdValue;

char i;

void init() {

 Lcd_Init();
 ADC_Init();
 TRISB.f1 = 0;
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
 tempValue = tempValue * 5;
 tempValue = tempValue / 10;

 if (tempValue < 32) {
 tempValue = 0;
 Lcd_Out(1, 12, "(-)");
 } else {
 Lcd_Out(1, 12, "   ");

 tempValue = tempValue - 32;
 tempValue = tempValue * 5;
 tempValue = tempValue / 9;


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
 IntToStr(spdValue, txtSpd);


 Lcd_Out(2, 1, "Speed: ");

 if (spdValue < 100) {
 Lcd_Out(2, 8, ltrim(txtSpd));
 Lcd_Out(2, 10, " ");
 Lcd_Out(2, 11, "%");
 } else {
 Lcd_Out(2, 8, ltrim(txtSpd));
 Lcd_Out(2, 11, "%");
 }


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

void main() {
 init();

 while(1) {
 readTemp();
 dispTemp();
 dispSpd();
 autoFanControl();
 }
}
