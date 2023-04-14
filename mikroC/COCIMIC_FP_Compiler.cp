#line 1 "//Mac/Home/Documents/GitHub/COCIMIC-EK1-FP/mikroC/COCIMIC_FP_Compiler.c"
#line 10 "//Mac/Home/Documents/GitHub/COCIMIC-EK1-FP/mikroC/COCIMIC_FP_Compiler.c"
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
unsigned short mode = 0;
unsigned int key;
unsigned int keyFlag;


void init() {
 Lcd_Init();
 ADC_Init();
 TRISB = 0xF0;
 TRISD = 0x00;
 PORTB = 0x0F;
 TRISC.f0 = 0;
 PWM1_Init(25000);
}


void initInterrupt() {
 INTCON.f7 = 1;
 INTCON.f6 = 1;
 INTCON.f3 = 1;
 INTCON.f0 = 1;

 OPTION_REG.f7 = 0;
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


void keypadScan() {
 key = 0;
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


void manualFanControl() {
 if (keyFlag == 1) {
 keyFlag = 0;
 if (key == 1) {
 spdValue = 10;
 startFan();
 } else if (key == 2) {
 spdValue = 20;
 startFan();
 } else if (key == 3) {
 spdValue = 30;
 startFan();
 } else if (key == 4) {
 spdValue = 40;
 startFan();
 } else if (key == 5) {
 spdValue = 50;
 startFan();
 } else if (key == 6) {
 spdValue = 60;
 startFan();
 } else if (key == 7) {
 spdValue = 70;
 startFan();
 } else if (key == 8) {
 spdValue = 80;
 startFan();
 } else if (key == 9) {
 spdValue = 90;
 startFan();
 } else if (key == 12) {
 spdValue = 100;
 startFan();
 }
 }
}


void modeControl() {

 if (mode == 1) {
 Lcd_Out(1, 1, "               M");
 dispSpd();
 manualFanControl();
 } else {
 Lcd_Out(1, 16, "A");
 readTemp();
 dispTemp();
 dispSpd();
 autoFanControl();
 }
}


void interrupt() {
 INTCON.f7 = 0;


 if (INTCON.f0 == 1) {
 if (PORTB.f4 == 0) {
 keyFlag = 1;
 delay_ms(100);
 if (PORTB.f0 == 0) {
 key = 1;
 } else if (PORTB.f1 == 0) {
 key = 4;
 } else if (PORTB.f2 == 0) {
 key = 7;
 } else if (PORTB.f3 == 0) {
 key = 10;
 }
 }

 if (PORTB.f5 == 0) {
 keyFlag = 1;
 delay_ms(100);
 if (PORTB.f0 == 0) {
 key = 2;
 } else if (PORTB.f1 == 0) {
 key = 5;
 } else if (PORTB.f2 == 0) {
 key = 8;
 } else if (PORTB.f3 == 12) {
 key = 12;
 }
 }

 if (PORTB.f6 == 0) {
 keyFlag = 1;
 delay_ms(100);
 if (PORTB.f0 == 0) {
 key = 3;
 } else if (PORTB.f1 == 0) {
 key = 6;
 } else if (PORTB.f2 == 0) {
 key = 9;
 } else if (PORTB.f3 == 0) {
 key = 11;
 }
 }

 INTCON.f0 = 0;
 }
 INTCON.f7 = 1;
}


void main() {
 init();
 initInterrupt();
 while (1) {
 keypadScan();
 keypad();
 modeControl();
 }
}
