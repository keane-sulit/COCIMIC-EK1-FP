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


char txtTemp[10];
char txtSpd[10];

unsigned int tempValue;
unsigned int spdValue;

char i;

void Move_Delay() {
 Delay_ms(500);
}


void init() {

 Lcd_Init();
 ADC_Init();
 TRISB.f1 = 0;
 PWM1_Init(25000);
}

void readTemp() {
 tempValue = ADC_Read(0);
 tempValue = tempValue * 5;
 tempValue = tempValue / 10;


 tempValue = tempValue - 32;
 tempValue = tempValue * 5;
 tempValue = tempValue / 9;


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
 if (tempValue > 30) {
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

 while(1) {
 readTemp();

 dispTemp();

 fanControl();
 }
}
