
_init:

;COCIMIC_FP_Compiler.c,46 :: 		void init() {
;COCIMIC_FP_Compiler.c,47 :: 		Lcd_Init();  // Initialize LCD library
	CALL       _Lcd_Init+0
;COCIMIC_FP_Compiler.c,48 :: 		ADC_Init();  // Initialize ADC library
	CALL       _ADC_Init+0
;COCIMIC_FP_Compiler.c,50 :: 		TRISB = 0xF0;
	MOVLW      240
	MOVWF      TRISB+0
;COCIMIC_FP_Compiler.c,51 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;COCIMIC_FP_Compiler.c,52 :: 		TRISC.f0 = 0;      // Set RC0 as output (Motor driver input 1)
	BCF        TRISC+0, 0
;COCIMIC_FP_Compiler.c,53 :: 		PWM1_Init(25000);  // Initialize PWM1 module at 25KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;COCIMIC_FP_Compiler.c,54 :: 		}
L_end_init:
	RETURN
; end of _init

_startFan:

;COCIMIC_FP_Compiler.c,57 :: 		void startFan() {
;COCIMIC_FP_Compiler.c,58 :: 		PORTC.f0 = 1;                         // Set RB1 high
	BSF        PORTC+0, 0
;COCIMIC_FP_Compiler.c,59 :: 		PWM1_Start();                         // Start PWM1 module
	CALL       _PWM1_Start+0
;COCIMIC_FP_Compiler.c,60 :: 		PWM1_Set_Duty(255 * spdValue / 100);  // Set PWM1 duty cycle
	MOVLW      255
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       _spdValue+0, 0
	MOVWF      R4+0
	MOVF       _spdValue+1, 0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;COCIMIC_FP_Compiler.c,61 :: 		}
L_end_startFan:
	RETURN
; end of _startFan

_stopFan:

;COCIMIC_FP_Compiler.c,64 :: 		void stopFan() {
;COCIMIC_FP_Compiler.c,65 :: 		PORTC.f0 = 0;  // Set RB1 low
	BCF        PORTC+0, 0
;COCIMIC_FP_Compiler.c,66 :: 		PWM1_Stop();   // Stop PWM1 module
	CALL       _PWM1_Stop+0
;COCIMIC_FP_Compiler.c,67 :: 		}
L_end_stopFan:
	RETURN
; end of _stopFan

_readTemp:

;COCIMIC_FP_Compiler.c,70 :: 		void readTemp() {
;COCIMIC_FP_Compiler.c,71 :: 		tempValue = ADC_Read(0);     // Read ADC value at channel 0
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,72 :: 		tempValue = tempValue * 5;   // Convert ADC value to voltage
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,73 :: 		tempValue = tempValue / 10;  // Convert voltage to temperature
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,76 :: 		if (tempValue < 32) {              // If temperature is below 32F
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readTemp104
	MOVLW      32
	SUBWF      R0+0, 0
L__readTemp104:
	BTFSC      STATUS+0, 0
	GOTO       L_readTemp0
;COCIMIC_FP_Compiler.c,77 :: 		tempValue = 0;                 // Set temperature to 0
	CLRF       _tempValue+0
	CLRF       _tempValue+1
;COCIMIC_FP_Compiler.c,78 :: 		IntToStr(tempValue, txtTemp);  // Convert temperature to string
	CLRF       FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,81 :: 		Lcd_Out(1, 7, "   C ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,82 :: 		Lcd_Out(1, 12, "(-)");  // Display negative sign
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,83 :: 		Lcd_Out(2, 9, "  ");    // Clear values using space
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,85 :: 		} else {                    // If temperature is above 32F
	GOTO       L_readTemp1
L_readTemp0:
;COCIMIC_FP_Compiler.c,86 :: 		Lcd_Out(1, 12, "   ");  // Clear values using space
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,89 :: 		tempValue = tempValue - 32;
	MOVLW      32
	SUBWF      _tempValue+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _tempValue+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,90 :: 		tempValue = tempValue * 5;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,91 :: 		tempValue = tempValue / 9;
	MOVLW      9
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,92 :: 		IntToStr(tempValue, txtTemp);  // Convert temperature in Celsius to string
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,93 :: 		}
L_readTemp1:
;COCIMIC_FP_Compiler.c,94 :: 		}
L_end_readTemp:
	RETURN
; end of _readTemp

_dispTemp:

;COCIMIC_FP_Compiler.c,97 :: 		void dispTemp() {
;COCIMIC_FP_Compiler.c,99 :: 		Lcd_Out(1, 1, "Temp: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,100 :: 		Lcd_Out(1, 7, ltrim(txtTemp));
	MOVLW      _txtTemp+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,101 :: 		Lcd_Out(1, 10, "C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,102 :: 		}
L_end_dispTemp:
	RETURN
; end of _dispTemp

_autoFanControl:

;COCIMIC_FP_Compiler.c,105 :: 		void autoFanControl() {
;COCIMIC_FP_Compiler.c,107 :: 		if (tempValue < 26) {  // If temperature is below 26C, turn off fan
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl107
	MOVLW      26
	SUBWF      _tempValue+0, 0
L__autoFanControl107:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl2
;COCIMIC_FP_Compiler.c,108 :: 		spdValue = 0;
	CLRF       _spdValue+0
	CLRF       _spdValue+1
;COCIMIC_FP_Compiler.c,109 :: 		Lcd_Out(2, 9, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,110 :: 		stopFan();
	CALL       _stopFan+0
;COCIMIC_FP_Compiler.c,111 :: 		} else if (tempValue < 29) {  // If temperature is between 26C and 29C, set fan speed to 10%
	GOTO       L_autoFanControl3
L_autoFanControl2:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl108
	MOVLW      29
	SUBWF      _tempValue+0, 0
L__autoFanControl108:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl4
;COCIMIC_FP_Compiler.c,112 :: 		spdValue = 10;
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,113 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,114 :: 		} else if (tempValue < 32) {  // If temperature is between 29C and 32C, set fan speed to 30%
	GOTO       L_autoFanControl5
L_autoFanControl4:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl109
	MOVLW      32
	SUBWF      _tempValue+0, 0
L__autoFanControl109:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl6
;COCIMIC_FP_Compiler.c,115 :: 		spdValue = 30;
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,116 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,117 :: 		} else if (tempValue < 35) {  // If temperature is between 32C and 35C, set fan speed to 50%
	GOTO       L_autoFanControl7
L_autoFanControl6:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl110
	MOVLW      35
	SUBWF      _tempValue+0, 0
L__autoFanControl110:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl8
;COCIMIC_FP_Compiler.c,118 :: 		spdValue = 50;
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,119 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,120 :: 		} else if (tempValue < 38) {  // If temperature is between 35C and 38C, set fan speed to 70%
	GOTO       L_autoFanControl9
L_autoFanControl8:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl111
	MOVLW      38
	SUBWF      _tempValue+0, 0
L__autoFanControl111:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl10
;COCIMIC_FP_Compiler.c,121 :: 		spdValue = 70;
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,122 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,123 :: 		} else if (tempValue < 41) {  // If temperature is between 38C and 41C, set fan speed to 90%
	GOTO       L_autoFanControl11
L_autoFanControl10:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl112
	MOVLW      41
	SUBWF      _tempValue+0, 0
L__autoFanControl112:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl12
;COCIMIC_FP_Compiler.c,124 :: 		spdValue = 90;
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,125 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,126 :: 		} else if (tempValue < 50) {  // If temperature is between 41C and 50C, set fan speed to 100%
	GOTO       L_autoFanControl13
L_autoFanControl12:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl113
	MOVLW      50
	SUBWF      _tempValue+0, 0
L__autoFanControl113:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl14
;COCIMIC_FP_Compiler.c,127 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,128 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,129 :: 		} else {  // If temperature is above 50C, show warning message (!)
	GOTO       L_autoFanControl15
L_autoFanControl14:
;COCIMIC_FP_Compiler.c,130 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,131 :: 		Lcd_Out(1, 12, "(!)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,132 :: 		}
L_autoFanControl15:
L_autoFanControl13:
L_autoFanControl11:
L_autoFanControl9:
L_autoFanControl7:
L_autoFanControl5:
L_autoFanControl3:
;COCIMIC_FP_Compiler.c,133 :: 		}
L_end_autoFanControl:
	RETURN
; end of _autoFanControl

_dispSpd:

;COCIMIC_FP_Compiler.c,136 :: 		void dispSpd() {
;COCIMIC_FP_Compiler.c,137 :: 		IntToStr(spdValue, txtSpd);  // Convert speed to string
	MOVF       _spdValue+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _spdValue+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtSpd+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,140 :: 		Lcd_Out(2, 1, "Speed: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,143 :: 		if (spdValue < 100) {  // If speed is less than 100, clear 3rd digit using space
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd115
	MOVLW      100
	SUBWF      _spdValue+0, 0
L__dispSpd115:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd16
;COCIMIC_FP_Compiler.c,144 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
	MOVLW      _txtSpd+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,145 :: 		Lcd_Out(2, 10, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,146 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,147 :: 		} else {  // If speed is 100, as is
	GOTO       L_dispSpd17
L_dispSpd16:
;COCIMIC_FP_Compiler.c,148 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
	MOVLW      _txtSpd+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,149 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,150 :: 		}
L_dispSpd17:
;COCIMIC_FP_Compiler.c,153 :: 		if (spdValue == 0) {  // If speed is 0, display OFF
	MOVLW      0
	XORWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd116
	MOVLW      0
	XORWF      _spdValue+0, 0
L__dispSpd116:
	BTFSS      STATUS+0, 2
	GOTO       L_dispSpd18
;COCIMIC_FP_Compiler.c,154 :: 		Lcd_Out(2, 13, "OFF ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,155 :: 		} else if (spdValue < 33) {  // If speed is between 0 and 33, display LOW
	GOTO       L_dispSpd19
L_dispSpd18:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd117
	MOVLW      33
	SUBWF      _spdValue+0, 0
L__dispSpd117:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd20
;COCIMIC_FP_Compiler.c,156 :: 		Lcd_Out(2, 13, "LOW ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,157 :: 		} else if (spdValue < 66) {  // If speed is between 33 and 66, display MID
	GOTO       L_dispSpd21
L_dispSpd20:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd118
	MOVLW      66
	SUBWF      _spdValue+0, 0
L__dispSpd118:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd22
;COCIMIC_FP_Compiler.c,158 :: 		Lcd_Out(2, 13, "MID ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,159 :: 		} else if (spdValue <= 99) {  // If speed is between 66 and 99, display HIGH
	GOTO       L_dispSpd23
L_dispSpd22:
	MOVF       _spdValue+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd119
	MOVF       _spdValue+0, 0
	SUBLW      99
L__dispSpd119:
	BTFSS      STATUS+0, 0
	GOTO       L_dispSpd24
;COCIMIC_FP_Compiler.c,160 :: 		Lcd_Out(2, 13, "HIGH");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr16_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,161 :: 		} else {  // If speed is 100, display MAX
	GOTO       L_dispSpd25
L_dispSpd24:
;COCIMIC_FP_Compiler.c,162 :: 		Lcd_Out(2, 13, "MAX ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr17_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,163 :: 		}
L_dispSpd25:
L_dispSpd23:
L_dispSpd21:
L_dispSpd19:
;COCIMIC_FP_Compiler.c,164 :: 		}
L_end_dispSpd:
	RETURN
; end of _dispSpd

_keypadKey:

;COCIMIC_FP_Compiler.c,167 :: 		char keypadKey(char row, char col) {
;COCIMIC_FP_Compiler.c,169 :: 		if (col == 0) {
	MOVF       FARG_keypadKey_col+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey26
;COCIMIC_FP_Compiler.c,170 :: 		if (row == 0) {
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey27
;COCIMIC_FP_Compiler.c,171 :: 		return '1';
	MOVLW      49
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,172 :: 		} else if (row == 1) {
L_keypadKey27:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey29
;COCIMIC_FP_Compiler.c,173 :: 		return '4';
	MOVLW      52
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,174 :: 		} else if (row == 2) {
L_keypadKey29:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey31
;COCIMIC_FP_Compiler.c,175 :: 		return '7';
	MOVLW      55
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,176 :: 		} else if (row == 3) {
L_keypadKey31:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey33
;COCIMIC_FP_Compiler.c,177 :: 		return '*';
	MOVLW      42
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,178 :: 		}
L_keypadKey33:
;COCIMIC_FP_Compiler.c,179 :: 		} else if (col == 1) {
	GOTO       L_keypadKey34
L_keypadKey26:
	MOVF       FARG_keypadKey_col+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey35
;COCIMIC_FP_Compiler.c,180 :: 		if (row == 0) {
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey36
;COCIMIC_FP_Compiler.c,181 :: 		return '2';
	MOVLW      50
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,182 :: 		} else if (row == 1) {
L_keypadKey36:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey38
;COCIMIC_FP_Compiler.c,183 :: 		return '5';
	MOVLW      53
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,184 :: 		} else if (row == 2) {
L_keypadKey38:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey40
;COCIMIC_FP_Compiler.c,185 :: 		return '8';
	MOVLW      56
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,186 :: 		} else if (row == 3) {
L_keypadKey40:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey42
;COCIMIC_FP_Compiler.c,187 :: 		return '0';
	MOVLW      48
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,188 :: 		}
L_keypadKey42:
;COCIMIC_FP_Compiler.c,189 :: 		} else if (col == 2) {
	GOTO       L_keypadKey43
L_keypadKey35:
	MOVF       FARG_keypadKey_col+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey44
;COCIMIC_FP_Compiler.c,190 :: 		if (row == 0) {
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey45
;COCIMIC_FP_Compiler.c,191 :: 		return '3';
	MOVLW      51
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,192 :: 		} else if (row == 1) {
L_keypadKey45:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey47
;COCIMIC_FP_Compiler.c,193 :: 		return '6';
	MOVLW      54
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,194 :: 		} else if (row == 2) {
L_keypadKey47:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey49
;COCIMIC_FP_Compiler.c,195 :: 		return '9';
	MOVLW      57
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,196 :: 		} else if (row == 3) {
L_keypadKey49:
	MOVF       FARG_keypadKey_row+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_keypadKey51
;COCIMIC_FP_Compiler.c,197 :: 		return '#';
	MOVLW      35
	MOVWF      R0+0
	GOTO       L_end_keypadKey
;COCIMIC_FP_Compiler.c,198 :: 		}
L_keypadKey51:
;COCIMIC_FP_Compiler.c,199 :: 		}
L_keypadKey44:
L_keypadKey43:
L_keypadKey34:
;COCIMIC_FP_Compiler.c,200 :: 		}
L_end_keypadKey:
	RETURN
; end of _keypadKey

_keypadScan:

;COCIMIC_FP_Compiler.c,203 :: 		char keypadScan() {
;COCIMIC_FP_Compiler.c,204 :: 		for (i = 0; i < 4; i++) {
	CLRF       _i+0
L_keypadScan52:
	MOVLW      4
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_keypadScan53
;COCIMIC_FP_Compiler.c,206 :: 		if (i == 0) {
	MOVF       _i+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_keypadScan55
;COCIMIC_FP_Compiler.c,207 :: 		PORTB = 1;
	MOVLW      1
	MOVWF      PORTB+0
;COCIMIC_FP_Compiler.c,208 :: 		} else if (i == 1) {
	GOTO       L_keypadScan56
L_keypadScan55:
	MOVF       _i+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_keypadScan57
;COCIMIC_FP_Compiler.c,209 :: 		PORTB = 2;
	MOVLW      2
	MOVWF      PORTB+0
;COCIMIC_FP_Compiler.c,210 :: 		} else if (i == 2) {
	GOTO       L_keypadScan58
L_keypadScan57:
	MOVF       _i+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_keypadScan59
;COCIMIC_FP_Compiler.c,211 :: 		PORTB = 4;
	MOVLW      4
	MOVWF      PORTB+0
;COCIMIC_FP_Compiler.c,212 :: 		} else if (i == 3) {
	GOTO       L_keypadScan60
L_keypadScan59:
	MOVF       _i+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_keypadScan61
;COCIMIC_FP_Compiler.c,213 :: 		PORTB = 8;
	MOVLW      8
	MOVWF      PORTB+0
;COCIMIC_FP_Compiler.c,214 :: 		}
L_keypadScan61:
L_keypadScan60:
L_keypadScan58:
L_keypadScan56:
;COCIMIC_FP_Compiler.c,217 :: 		if (PORTB.f4) {
	BTFSS      PORTB+0, 4
	GOTO       L_keypadScan62
;COCIMIC_FP_Compiler.c,218 :: 		return keypadKey(i, 0);
	MOVF       _i+0, 0
	MOVWF      FARG_keypadKey_row+0
	CLRF       FARG_keypadKey_col+0
	CALL       _keypadKey+0
	GOTO       L_end_keypadScan
;COCIMIC_FP_Compiler.c,219 :: 		} else if (PORTB.f5) {
L_keypadScan62:
	BTFSS      PORTB+0, 5
	GOTO       L_keypadScan64
;COCIMIC_FP_Compiler.c,220 :: 		return keypadKey(i, 1);
	MOVF       _i+0, 0
	MOVWF      FARG_keypadKey_row+0
	MOVLW      1
	MOVWF      FARG_keypadKey_col+0
	CALL       _keypadKey+0
	GOTO       L_end_keypadScan
;COCIMIC_FP_Compiler.c,221 :: 		} else if (PORTB.f6) {
L_keypadScan64:
	BTFSS      PORTB+0, 6
	GOTO       L_keypadScan66
;COCIMIC_FP_Compiler.c,222 :: 		return keypadKey(i, 2);
	MOVF       _i+0, 0
	MOVWF      FARG_keypadKey_row+0
	MOVLW      2
	MOVWF      FARG_keypadKey_col+0
	CALL       _keypadKey+0
	GOTO       L_end_keypadScan
;COCIMIC_FP_Compiler.c,223 :: 		}
L_keypadScan66:
;COCIMIC_FP_Compiler.c,204 :: 		for (i = 0; i < 4; i++) {
	INCF       _i+0, 1
;COCIMIC_FP_Compiler.c,224 :: 		}
	GOTO       L_keypadScan52
L_keypadScan53:
;COCIMIC_FP_Compiler.c,225 :: 		}
L_end_keypadScan:
	RETURN
; end of _keypadScan

_keypad:

;COCIMIC_FP_Compiler.c,228 :: 		unsigned int keypad(int kp) {
;COCIMIC_FP_Compiler.c,229 :: 		switch (kp) {
	GOTO       L_keypad67
;COCIMIC_FP_Compiler.c,230 :: 		case '1':
L_keypad69:
;COCIMIC_FP_Compiler.c,231 :: 		return 1;
	MOVLW      1
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,233 :: 		case '2':
L_keypad70:
;COCIMIC_FP_Compiler.c,234 :: 		return 2;
	MOVLW      2
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,236 :: 		case '3':
L_keypad71:
;COCIMIC_FP_Compiler.c,237 :: 		return 3;
	MOVLW      3
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,239 :: 		case '4':
L_keypad72:
;COCIMIC_FP_Compiler.c,240 :: 		return 4;
	MOVLW      4
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,242 :: 		case '5':
L_keypad73:
;COCIMIC_FP_Compiler.c,243 :: 		return 5;
	MOVLW      5
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,245 :: 		case '6':
L_keypad74:
;COCIMIC_FP_Compiler.c,246 :: 		return 6;
	MOVLW      6
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,248 :: 		case '7':
L_keypad75:
;COCIMIC_FP_Compiler.c,249 :: 		return 7;
	MOVLW      7
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,251 :: 		case '8':
L_keypad76:
;COCIMIC_FP_Compiler.c,252 :: 		return 8;
	MOVLW      8
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,254 :: 		case '9':
L_keypad77:
;COCIMIC_FP_Compiler.c,255 :: 		return 9;
	MOVLW      9
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,257 :: 		case '0':
L_keypad78:
;COCIMIC_FP_Compiler.c,258 :: 		return 10;
	MOVLW      10
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,260 :: 		case '*':
L_keypad79:
;COCIMIC_FP_Compiler.c,261 :: 		return 11;
	MOVLW      11
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,263 :: 		case '#':
L_keypad80:
;COCIMIC_FP_Compiler.c,264 :: 		return 12;
	MOVLW      12
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_keypad
;COCIMIC_FP_Compiler.c,266 :: 		}
L_keypad67:
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad123
	MOVLW      49
	XORWF      FARG_keypad_kp+0, 0
L__keypad123:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad69
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad124
	MOVLW      50
	XORWF      FARG_keypad_kp+0, 0
L__keypad124:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad70
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad125
	MOVLW      51
	XORWF      FARG_keypad_kp+0, 0
L__keypad125:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad71
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad126
	MOVLW      52
	XORWF      FARG_keypad_kp+0, 0
L__keypad126:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad72
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad127
	MOVLW      53
	XORWF      FARG_keypad_kp+0, 0
L__keypad127:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad73
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad128
	MOVLW      54
	XORWF      FARG_keypad_kp+0, 0
L__keypad128:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad74
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad129
	MOVLW      55
	XORWF      FARG_keypad_kp+0, 0
L__keypad129:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad75
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad130
	MOVLW      56
	XORWF      FARG_keypad_kp+0, 0
L__keypad130:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad76
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad131
	MOVLW      57
	XORWF      FARG_keypad_kp+0, 0
L__keypad131:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad77
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad132
	MOVLW      48
	XORWF      FARG_keypad_kp+0, 0
L__keypad132:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad78
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad133
	MOVLW      42
	XORWF      FARG_keypad_kp+0, 0
L__keypad133:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad79
	MOVLW      0
	XORWF      FARG_keypad_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad134
	MOVLW      35
	XORWF      FARG_keypad_kp+0, 0
L__keypad134:
	BTFSC      STATUS+0, 2
	GOTO       L_keypad80
;COCIMIC_FP_Compiler.c,267 :: 		}
L_end_keypad:
	RETURN
; end of _keypad

_manualFanControl:

;COCIMIC_FP_Compiler.c,270 :: 		unsigned int manualFanControl(int kp) {
;COCIMIC_FP_Compiler.c,271 :: 		switch (kp) {
	GOTO       L_manualFanControl81
;COCIMIC_FP_Compiler.c,272 :: 		case 1:
L_manualFanControl83:
;COCIMIC_FP_Compiler.c,273 :: 		spdValue = 10;  // Set speed to 10% if 1 is pressed
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,274 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,275 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,276 :: 		case 2:
L_manualFanControl84:
;COCIMIC_FP_Compiler.c,277 :: 		spdValue = 20;  // Set speed to 20% if 2 is pressed
	MOVLW      20
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,278 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,279 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,280 :: 		case 3:
L_manualFanControl85:
;COCIMIC_FP_Compiler.c,281 :: 		spdValue = 30;  // Set speed to 30% if 3 is pressed
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,282 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,283 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,284 :: 		case 4:
L_manualFanControl86:
;COCIMIC_FP_Compiler.c,285 :: 		spdValue = 40;  // Set speed to 40% if 4 is pressed
	MOVLW      40
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,286 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,287 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,288 :: 		case 5:
L_manualFanControl87:
;COCIMIC_FP_Compiler.c,289 :: 		spdValue = 50;  // Set speed to 50% if 5 is pressed
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,290 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,291 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,292 :: 		case 6:
L_manualFanControl88:
;COCIMIC_FP_Compiler.c,293 :: 		spdValue = 60;  // Set speed to 60% if 6 is pressed
	MOVLW      60
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,294 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,295 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,296 :: 		case 7:
L_manualFanControl89:
;COCIMIC_FP_Compiler.c,297 :: 		spdValue = 70;  // Set speed to 70% if 7 is pressed
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,298 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,299 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,300 :: 		case 8:
L_manualFanControl90:
;COCIMIC_FP_Compiler.c,301 :: 		spdValue = 80;  // Set speed to 80% if 8 is pressed
	MOVLW      80
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,302 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,303 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,304 :: 		case 9:
L_manualFanControl91:
;COCIMIC_FP_Compiler.c,305 :: 		spdValue = 90;  // Set speed to 90% if 9 is pressed
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,306 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,307 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,308 :: 		case 10:
L_manualFanControl92:
;COCIMIC_FP_Compiler.c,309 :: 		spdValue = 100;  // Set speed to 100% if * is pressed
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,310 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,311 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,312 :: 		case 11:
L_manualFanControl93:
;COCIMIC_FP_Compiler.c,313 :: 		mode = 1;  // Set mode to manual if * is pressed
	MOVLW      1
	MOVWF      _mode+0
;COCIMIC_FP_Compiler.c,314 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,315 :: 		case 12:
L_manualFanControl94:
;COCIMIC_FP_Compiler.c,316 :: 		mode = 0;  // Set mode to auto if # is pressed
	CLRF       _mode+0
;COCIMIC_FP_Compiler.c,317 :: 		break;
	GOTO       L_manualFanControl82
;COCIMIC_FP_Compiler.c,318 :: 		}
L_manualFanControl81:
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl136
	MOVLW      1
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl136:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl83
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl137
	MOVLW      2
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl137:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl84
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl138
	MOVLW      3
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl138:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl85
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl139
	MOVLW      4
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl139:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl86
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl140
	MOVLW      5
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl140:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl87
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl141
	MOVLW      6
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl141:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl88
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl142
	MOVLW      7
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl142:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl89
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl143
	MOVLW      8
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl143:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl90
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl144
	MOVLW      9
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl144:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl91
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl145
	MOVLW      10
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl145:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl92
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl146
	MOVLW      11
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl146:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl93
	MOVLW      0
	XORWF      FARG_manualFanControl_kp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl147
	MOVLW      12
	XORWF      FARG_manualFanControl_kp+0, 0
L__manualFanControl147:
	BTFSC      STATUS+0, 2
	GOTO       L_manualFanControl94
L_manualFanControl82:
;COCIMIC_FP_Compiler.c,319 :: 		}
L_end_manualFanControl:
	RETURN
; end of _manualFanControl

_modeControl:

;COCIMIC_FP_Compiler.c,322 :: 		void modeControl() {
;COCIMIC_FP_Compiler.c,324 :: 		if (mode == 1) {                        // If mode is manual
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_modeControl95
;COCIMIC_FP_Compiler.c,325 :: 		Lcd_Out(1, 1, "               M");  // Clear temperature reading and display M on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr18_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,326 :: 		dispSpd();                          // Display speed based on keypad input
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,327 :: 		} else {
	GOTO       L_modeControl96
L_modeControl95:
;COCIMIC_FP_Compiler.c,328 :: 		Lcd_Out(1, 16, "A");  // Display A on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr19_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,329 :: 		readTemp();           // Read temperature
	CALL       _readTemp+0
;COCIMIC_FP_Compiler.c,330 :: 		dispTemp();           // Display temperature
	CALL       _dispTemp+0
;COCIMIC_FP_Compiler.c,331 :: 		dispSpd();            // Display speed
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,332 :: 		autoFanControl();     // Control fan speed based on temperature
	CALL       _autoFanControl+0
;COCIMIC_FP_Compiler.c,333 :: 		}
L_modeControl96:
;COCIMIC_FP_Compiler.c,334 :: 		}
L_end_modeControl:
	RETURN
; end of _modeControl

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;COCIMIC_FP_Compiler.c,337 :: 		void interrupt() {
;COCIMIC_FP_Compiler.c,338 :: 		INTCON.GIE = 0;  // Disable global interrupt
	BCF        INTCON+0, 7
;COCIMIC_FP_Compiler.c,340 :: 		INTCON.GIE = 1;  // Enable global interrupt
	BSF        INTCON+0, 7
;COCIMIC_FP_Compiler.c,341 :: 		}
L_end_interrupt:
L__interrupt150:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;COCIMIC_FP_Compiler.c,344 :: 		void main() {
;COCIMIC_FP_Compiler.c,345 :: 		init();                                                 // Initialize
	CALL       _init+0
;COCIMIC_FP_Compiler.c,346 :: 		while (1) {                                             // Endless loop
L_main97:
;COCIMIC_FP_Compiler.c,347 :: 		PORTB = manualFanControl(keypad(keypadScan()));     // Manual fan control
	CALL       _keypadScan+0
	MOVF       R0+0, 0
	MOVWF      FARG_keypad_kp+0
	CLRF       FARG_keypad_kp+1
	CALL       _keypad+0
	MOVF       R0+0, 0
	MOVWF      FARG_manualFanControl_kp+0
	MOVF       R0+1, 0
	MOVWF      FARG_manualFanControl_kp+1
	CALL       _manualFanControl+0
	MOVF       R0+0, 0
	MOVWF      PORTB+0
;COCIMIC_FP_Compiler.c,348 :: 		delay_ms(100);                                      // Debounce button
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main99:
	DECFSZ     R13+0, 1
	GOTO       L_main99
	DECFSZ     R12+0, 1
	GOTO       L_main99
	DECFSZ     R11+0, 1
	GOTO       L_main99
	NOP
	NOP
;COCIMIC_FP_Compiler.c,349 :: 		modeControl();                                      // Control mode
	CALL       _modeControl+0
;COCIMIC_FP_Compiler.c,350 :: 		}
	GOTO       L_main97
;COCIMIC_FP_Compiler.c,351 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
