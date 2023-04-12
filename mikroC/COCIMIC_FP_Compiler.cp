#line 1 "//Mac/Home/Documents/GitHub/COCIMIC-EK1-FP/mikroC/COCIMIC_FP_Compiler.c"
#line 11 "//Mac/Home/Documents/GitHub/COCIMIC-EK1-FP/mikroC/COCIMIC_FP_Compiler.c"
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







char txtTemp[16];
char txtSpd[16];



unsigned int tempValue;
unsigned int spdValue;

char i;

unsigned short mode;

unsigned int tmr0Count;


void init() {
 Lcd_Init();
 ADC_Init();

 TRISB = 0xF0;
 PORTB = 0x00;
 TRISC.f0 = 0;
 PWM1_Init(25000);
}


void startFan() {
 PORTC.f0 = 1;
 PWM1_Start();
 PWM1_Set_Duty(255 * spdValue / 100);
}


void stopFan() {
 PORTC.f0 = 0;
 PWM1_Stop();
}


void readTemp() {
 tempValue = ADC_Read(0);
 tempValue = tempValue * 5;
 tempValue = tempValue / 10;


 if (tempValue < 32) {
 tempValue = 0;
 IntToStr(tempValue, txtTemp);


 Lcd_Out(1, 7, "   C ");
 Lcd_Out(1, 12, "(-)");
 Lcd_Out(2, 9, "  ");

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
 spdValue = 100;
 Lcd_Out(1, 12, "(!)");
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


char keypadKey(char row, char col) {

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


char keypadScan() {
 for (i = 0; i < 4; i++) {

 if (i == 0) {
 PORTB = 1;
 } else if (i == 1) {
 PORTB = 2;
 } else if (i == 2) {
 PORTB = 4;
 } else if (i == 3) {
 PORTB = 8;
 }


 if (PORTB.f4) {
 return keypadKey(i, 0);
 } else if (PORTB.f5) {
 return keypadKey(i, 1);
 } else if (PORTB.f6) {
 return keypadKey(i, 2);
 }
 }
}


unsigned int keypad(int kp) {
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


unsigned int manualFanControl(int kp) {
 switch (kp) {
 case 1:
 spdValue = 10;
 startFan();
 break;
 case 2:
 spdValue = 20;
 startFan();
 break;
 case 3:
 spdValue = 30;
 startFan();
 break;
 case 4:
 spdValue = 40;
 startFan();
 break;
 case 5:
 spdValue = 50;
 startFan();
 break;
 case 6:
 spdValue = 60;
 startFan();
 break;
 case 7:
 spdValue = 70;
 startFan();
 break;
 case 8:
 spdValue = 80;
 startFan();
 break;
 case 9:
 spdValue = 90;
 startFan();
 break;
 case 10:
 spdValue = 100;
 startFan();
 break;
 case 11:
 mode = 1;
 break;
 case 12:
 mode = 0;
 break;
 }
}


void modeControl() {

 if (mode == 1) {
 Lcd_Out(1, 1, "               M");
 dispSpd();
 } else {
 Lcd_Out(1, 16, "A");
 readTemp();
 dispTemp();
 dispSpd();
 autoFanControl();
 }
}


void interrupt() {
 INTCON.GIE = 0;

 INTCON.GIE = 1;
}


void main() {
 init();
 while (1) {
 PORTB = manualFanControl(keypad(keypadScan()));
 delay_ms(100);
 modeControl();
 }
}
