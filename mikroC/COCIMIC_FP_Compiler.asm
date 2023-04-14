
_init:

;COCIMIC_FP_Compiler.c,36 :: 		void init() {
;COCIMIC_FP_Compiler.c,37 :: 		Lcd_Init();        // Initialize LCD library
	CALL       _Lcd_Init+0
;COCIMIC_FP_Compiler.c,38 :: 		ADC_Init();        // Initialize ADC library
	CALL       _ADC_Init+0
;COCIMIC_FP_Compiler.c,39 :: 		TRISB = 0xF0;      // Set RB4-RB7 as input (Keypad)
	MOVLW      240
	MOVWF      TRISB+0
;COCIMIC_FP_Compiler.c,40 :: 		TRISD = 0x00;      // Set RD0-RD7 as output (LED)
	CLRF       TRISD+0
;COCIMIC_FP_Compiler.c,41 :: 		PORTB = 0x0F;      // Set RB4-RB7 as low
	MOVLW      15
	MOVWF      PORTB+0
;COCIMIC_FP_Compiler.c,42 :: 		TRISC.f0 = 0;      // Set RC0 as output (Motor driver input 1)
	BCF        TRISC+0, 0
;COCIMIC_FP_Compiler.c,43 :: 		PWM1_Init(25000);  // Initialize PWM1 module at 25KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;COCIMIC_FP_Compiler.c,44 :: 		}
L_end_init:
	RETURN
; end of _init

_initInterrupt:

;COCIMIC_FP_Compiler.c,47 :: 		void initInterrupt() {
;COCIMIC_FP_Compiler.c,48 :: 		INTCON.f7 = 1;  // Enable global interrupt
	BSF        INTCON+0, 7
;COCIMIC_FP_Compiler.c,49 :: 		INTCON.f6 = 1;  // Enable peripheral interrupt
	BSF        INTCON+0, 6
;COCIMIC_FP_Compiler.c,50 :: 		INTCON.f3 = 1;  // Enable RB port change interrupt
	BSF        INTCON+0, 3
;COCIMIC_FP_Compiler.c,51 :: 		INTCON.f0 = 1;  // Enable RB0 interrupt
	BSF        INTCON+0, 0
;COCIMIC_FP_Compiler.c,53 :: 		OPTION_REG.f7 = 0;  // Enable pull-up
	BCF        OPTION_REG+0, 7
;COCIMIC_FP_Compiler.c,54 :: 		}
L_end_initInterrupt:
	RETURN
; end of _initInterrupt

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
	GOTO       L__readTemp91
	MOVLW      32
	SUBWF      R0+0, 0
L__readTemp91:
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
;COCIMIC_FP_Compiler.c,81 :: 		Lcd_Out(1, 7, "   C ");  // Display Celsius sign
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,82 :: 		Lcd_Out(1, 12, "(-)");   // Display negative sign
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,83 :: 		Lcd_Out(2, 9, "  ");     // Clear values using space
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
	GOTO       L__autoFanControl94
	MOVLW      26
	SUBWF      _tempValue+0, 0
L__autoFanControl94:
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
	GOTO       L__autoFanControl95
	MOVLW      29
	SUBWF      _tempValue+0, 0
L__autoFanControl95:
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
	GOTO       L__autoFanControl96
	MOVLW      32
	SUBWF      _tempValue+0, 0
L__autoFanControl96:
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
	GOTO       L__autoFanControl97
	MOVLW      35
	SUBWF      _tempValue+0, 0
L__autoFanControl97:
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
	GOTO       L__autoFanControl98
	MOVLW      38
	SUBWF      _tempValue+0, 0
L__autoFanControl98:
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
	GOTO       L__autoFanControl99
	MOVLW      41
	SUBWF      _tempValue+0, 0
L__autoFanControl99:
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
	GOTO       L__autoFanControl100
	MOVLW      50
	SUBWF      _tempValue+0, 0
L__autoFanControl100:
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
	GOTO       L__dispSpd102
	MOVLW      100
	SUBWF      _spdValue+0, 0
L__dispSpd102:
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
	GOTO       L__dispSpd103
	MOVLW      0
	XORWF      _spdValue+0, 0
L__dispSpd103:
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
	GOTO       L__dispSpd104
	MOVLW      33
	SUBWF      _spdValue+0, 0
L__dispSpd104:
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
	GOTO       L__dispSpd105
	MOVLW      66
	SUBWF      _spdValue+0, 0
L__dispSpd105:
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
	GOTO       L__dispSpd106
	MOVF       _spdValue+0, 0
	SUBLW      99
L__dispSpd106:
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

_keypadScan:

;COCIMIC_FP_Compiler.c,167 :: 		void keypadScan() {
;COCIMIC_FP_Compiler.c,168 :: 		key = 0;       // Clear key value
	CLRF       _key+0
	CLRF       _key+1
;COCIMIC_FP_Compiler.c,169 :: 		PORTB.F0 = 0;
	BCF        PORTB+0, 0
;COCIMIC_FP_Compiler.c,170 :: 		delay_ms(1);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_keypadScan26:
	DECFSZ     R13+0, 1
	GOTO       L_keypadScan26
	DECFSZ     R12+0, 1
	GOTO       L_keypadScan26
;COCIMIC_FP_Compiler.c,171 :: 		PORTB.F0 = 1;
	BSF        PORTB+0, 0
;COCIMIC_FP_Compiler.c,172 :: 		PORTB.F1 = 0;
	BCF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,173 :: 		delay_ms(1);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_keypadScan27:
	DECFSZ     R13+0, 1
	GOTO       L_keypadScan27
	DECFSZ     R12+0, 1
	GOTO       L_keypadScan27
;COCIMIC_FP_Compiler.c,174 :: 		PORTB.F1 = 1;
	BSF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,175 :: 		PORTB.F2 = 0;
	BCF        PORTB+0, 2
;COCIMIC_FP_Compiler.c,176 :: 		delay_ms(1);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_keypadScan28:
	DECFSZ     R13+0, 1
	GOTO       L_keypadScan28
	DECFSZ     R12+0, 1
	GOTO       L_keypadScan28
;COCIMIC_FP_Compiler.c,177 :: 		PORTB.F2 = 1;
	BSF        PORTB+0, 2
;COCIMIC_FP_Compiler.c,178 :: 		PORTB.F3 = 0;
	BCF        PORTB+0, 3
;COCIMIC_FP_Compiler.c,179 :: 		delay_ms(1);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_keypadScan29:
	DECFSZ     R13+0, 1
	GOTO       L_keypadScan29
	DECFSZ     R12+0, 1
	GOTO       L_keypadScan29
;COCIMIC_FP_Compiler.c,180 :: 		PORTB.F3 = 1;
	BSF        PORTB+0, 3
;COCIMIC_FP_Compiler.c,181 :: 		}
L_end_keypadScan:
	RETURN
; end of _keypadScan

_keypad:

;COCIMIC_FP_Compiler.c,183 :: 		void keypad() {
;COCIMIC_FP_Compiler.c,184 :: 		if (keyFlag == 1) {
	MOVLW      0
	XORWF      _keyFlag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad109
	MOVLW      1
	XORWF      _keyFlag+0, 0
L__keypad109:
	BTFSS      STATUS+0, 2
	GOTO       L_keypad30
;COCIMIC_FP_Compiler.c,185 :: 		if (key == 10) {
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad110
	MOVLW      10
	XORWF      _key+0, 0
L__keypad110:
	BTFSS      STATUS+0, 2
	GOTO       L_keypad31
;COCIMIC_FP_Compiler.c,186 :: 		mode = 1;
	MOVLW      1
	MOVWF      _mode+0
;COCIMIC_FP_Compiler.c,187 :: 		} else if (key == 11) {
	GOTO       L_keypad32
L_keypad31:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__keypad111
	MOVLW      11
	XORWF      _key+0, 0
L__keypad111:
	BTFSS      STATUS+0, 2
	GOTO       L_keypad33
;COCIMIC_FP_Compiler.c,188 :: 		mode = 0;
	CLRF       _mode+0
;COCIMIC_FP_Compiler.c,189 :: 		}
L_keypad33:
L_keypad32:
;COCIMIC_FP_Compiler.c,190 :: 		}
L_keypad30:
;COCIMIC_FP_Compiler.c,191 :: 		}
L_end_keypad:
	RETURN
; end of _keypad

_manualFanControl:

;COCIMIC_FP_Compiler.c,194 :: 		void manualFanControl() {
;COCIMIC_FP_Compiler.c,195 :: 		if (keyFlag == 1) {
	MOVLW      0
	XORWF      _keyFlag+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl113
	MOVLW      1
	XORWF      _keyFlag+0, 0
L__manualFanControl113:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl34
;COCIMIC_FP_Compiler.c,196 :: 		keyFlag = 0;  // Clear keyFlag
	CLRF       _keyFlag+0
	CLRF       _keyFlag+1
;COCIMIC_FP_Compiler.c,197 :: 		if (key == 1) {
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl114
	MOVLW      1
	XORWF      _key+0, 0
L__manualFanControl114:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl35
;COCIMIC_FP_Compiler.c,198 :: 		spdValue = 10;
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,199 :: 		} else if (key == 2) {
	GOTO       L_manualFanControl36
L_manualFanControl35:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl115
	MOVLW      2
	XORWF      _key+0, 0
L__manualFanControl115:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl37
;COCIMIC_FP_Compiler.c,200 :: 		spdValue = 20;
	MOVLW      20
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,201 :: 		} else if (key == 3) {
	GOTO       L_manualFanControl38
L_manualFanControl37:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl116
	MOVLW      3
	XORWF      _key+0, 0
L__manualFanControl116:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl39
;COCIMIC_FP_Compiler.c,202 :: 		spdValue = 30;
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,203 :: 		} else if (key == 4) {
	GOTO       L_manualFanControl40
L_manualFanControl39:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl117
	MOVLW      4
	XORWF      _key+0, 0
L__manualFanControl117:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl41
;COCIMIC_FP_Compiler.c,204 :: 		spdValue = 40;
	MOVLW      40
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,205 :: 		} else if (key == 5) {
	GOTO       L_manualFanControl42
L_manualFanControl41:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl118
	MOVLW      5
	XORWF      _key+0, 0
L__manualFanControl118:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl43
;COCIMIC_FP_Compiler.c,206 :: 		spdValue = 50;
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,207 :: 		} else if (key == 6) {
	GOTO       L_manualFanControl44
L_manualFanControl43:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl119
	MOVLW      6
	XORWF      _key+0, 0
L__manualFanControl119:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl45
;COCIMIC_FP_Compiler.c,208 :: 		spdValue = 60;
	MOVLW      60
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,209 :: 		} else if (key == 7) {
	GOTO       L_manualFanControl46
L_manualFanControl45:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl120
	MOVLW      7
	XORWF      _key+0, 0
L__manualFanControl120:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl47
;COCIMIC_FP_Compiler.c,210 :: 		spdValue = 70;
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,211 :: 		} else if (key == 8) {
	GOTO       L_manualFanControl48
L_manualFanControl47:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl121
	MOVLW      8
	XORWF      _key+0, 0
L__manualFanControl121:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl49
;COCIMIC_FP_Compiler.c,212 :: 		spdValue = 80;
	MOVLW      80
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,213 :: 		} else if (key == 9) {
	GOTO       L_manualFanControl50
L_manualFanControl49:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl122
	MOVLW      9
	XORWF      _key+0, 0
L__manualFanControl122:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl51
;COCIMIC_FP_Compiler.c,214 :: 		spdValue = 90;
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,215 :: 		} else if (key == 12) {
	GOTO       L_manualFanControl52
L_manualFanControl51:
	MOVLW      0
	XORWF      _key+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manualFanControl123
	MOVLW      12
	XORWF      _key+0, 0
L__manualFanControl123:
	BTFSS      STATUS+0, 2
	GOTO       L_manualFanControl53
;COCIMIC_FP_Compiler.c,216 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,217 :: 		}
L_manualFanControl53:
L_manualFanControl52:
L_manualFanControl50:
L_manualFanControl48:
L_manualFanControl46:
L_manualFanControl44:
L_manualFanControl42:
L_manualFanControl40:
L_manualFanControl38:
L_manualFanControl36:
;COCIMIC_FP_Compiler.c,218 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,219 :: 		}
L_manualFanControl34:
;COCIMIC_FP_Compiler.c,220 :: 		}
L_end_manualFanControl:
	RETURN
; end of _manualFanControl

_modeControl:

;COCIMIC_FP_Compiler.c,223 :: 		void modeControl() {
;COCIMIC_FP_Compiler.c,225 :: 		if (mode == 1) {                        // If mode is manual
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_modeControl54
;COCIMIC_FP_Compiler.c,226 :: 		Lcd_Out(1, 1, "               M");  // Clear temperature reading and display M on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr18_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,227 :: 		dispSpd();                          // Display speed based on keypad input
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,228 :: 		manualFanControl();                 // Control fan speed based on keypad input
	CALL       _manualFanControl+0
;COCIMIC_FP_Compiler.c,229 :: 		} else {
	GOTO       L_modeControl55
L_modeControl54:
;COCIMIC_FP_Compiler.c,230 :: 		Lcd_Out(1, 16, "A");  // Display A on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr19_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,231 :: 		readTemp();           // Read temperature
	CALL       _readTemp+0
;COCIMIC_FP_Compiler.c,232 :: 		dispTemp();           // Display temperature
	CALL       _dispTemp+0
;COCIMIC_FP_Compiler.c,233 :: 		dispSpd();            // Display speed
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,234 :: 		autoFanControl();     // Control fan speed based on temperature
	CALL       _autoFanControl+0
;COCIMIC_FP_Compiler.c,235 :: 		}
L_modeControl55:
;COCIMIC_FP_Compiler.c,236 :: 		}
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

;COCIMIC_FP_Compiler.c,239 :: 		void interrupt() {
;COCIMIC_FP_Compiler.c,240 :: 		INTCON.f7 = 0;  // Clear GIE
	BCF        INTCON+0, 7
;COCIMIC_FP_Compiler.c,243 :: 		if (INTCON.f0 == 1) {
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt56
;COCIMIC_FP_Compiler.c,244 :: 		if (PORTB.f4 == 0) {  // If RB4 is low
	BTFSC      PORTB+0, 4
	GOTO       L_interrupt57
;COCIMIC_FP_Compiler.c,245 :: 		keyFlag = 1;      // Set keyFlag
	MOVLW      1
	MOVWF      _keyFlag+0
	MOVLW      0
	MOVWF      _keyFlag+1
;COCIMIC_FP_Compiler.c,246 :: 		delay_ms(100);    // Debounce button
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_interrupt58:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt58
	DECFSZ     R12+0, 1
	GOTO       L_interrupt58
	DECFSZ     R11+0, 1
	GOTO       L_interrupt58
	NOP
	NOP
;COCIMIC_FP_Compiler.c,247 :: 		if (PORTB.f0 == 0) {
	BTFSC      PORTB+0, 0
	GOTO       L_interrupt59
;COCIMIC_FP_Compiler.c,248 :: 		key = 1;  // Set keypad value to 1
	MOVLW      1
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,249 :: 		} else if (PORTB.f1 == 0) {
	GOTO       L_interrupt60
L_interrupt59:
	BTFSC      PORTB+0, 1
	GOTO       L_interrupt61
;COCIMIC_FP_Compiler.c,250 :: 		key = 4;  // Set keypad value to 4
	MOVLW      4
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,251 :: 		} else if (PORTB.f2 == 0) {
	GOTO       L_interrupt62
L_interrupt61:
	BTFSC      PORTB+0, 2
	GOTO       L_interrupt63
;COCIMIC_FP_Compiler.c,252 :: 		key = 7;  // Set keypad value to 7
	MOVLW      7
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,253 :: 		} else if (PORTB.f3 == 0) {
	GOTO       L_interrupt64
L_interrupt63:
	BTFSC      PORTB+0, 3
	GOTO       L_interrupt65
;COCIMIC_FP_Compiler.c,254 :: 		key = 10;  // Set keypad value to 10 (*)
	MOVLW      10
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,255 :: 		}
L_interrupt65:
L_interrupt64:
L_interrupt62:
L_interrupt60:
;COCIMIC_FP_Compiler.c,256 :: 		}
L_interrupt57:
;COCIMIC_FP_Compiler.c,258 :: 		if (PORTB.f5 == 0) {
	BTFSC      PORTB+0, 5
	GOTO       L_interrupt66
;COCIMIC_FP_Compiler.c,259 :: 		keyFlag = 1;    // Set keyFlag
	MOVLW      1
	MOVWF      _keyFlag+0
	MOVLW      0
	MOVWF      _keyFlag+1
;COCIMIC_FP_Compiler.c,260 :: 		delay_ms(100);  // Debounce button
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_interrupt67:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt67
	DECFSZ     R12+0, 1
	GOTO       L_interrupt67
	DECFSZ     R11+0, 1
	GOTO       L_interrupt67
	NOP
	NOP
;COCIMIC_FP_Compiler.c,261 :: 		if (PORTB.f0 == 0) {
	BTFSC      PORTB+0, 0
	GOTO       L_interrupt68
;COCIMIC_FP_Compiler.c,262 :: 		key = 2;  // Set keypad value to 2
	MOVLW      2
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,263 :: 		} else if (PORTB.f1 == 0) {
	GOTO       L_interrupt69
L_interrupt68:
	BTFSC      PORTB+0, 1
	GOTO       L_interrupt70
;COCIMIC_FP_Compiler.c,264 :: 		key = 5;  // Set keypad value to 5
	MOVLW      5
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,265 :: 		} else if (PORTB.f2 == 0) {
	GOTO       L_interrupt71
L_interrupt70:
	BTFSC      PORTB+0, 2
	GOTO       L_interrupt72
;COCIMIC_FP_Compiler.c,266 :: 		key = 8;  // Set keypad value to 8
	MOVLW      8
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,267 :: 		} else if (PORTB.f3 == 12) {
	GOTO       L_interrupt73
L_interrupt72:
	BTFSC      PORTB+0, 3
	GOTO       L_interrupt74
;COCIMIC_FP_Compiler.c,268 :: 		key = 12;  // Set keypad value to 12
	MOVLW      12
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,269 :: 		}
L_interrupt74:
L_interrupt73:
L_interrupt71:
L_interrupt69:
;COCIMIC_FP_Compiler.c,270 :: 		}
L_interrupt66:
;COCIMIC_FP_Compiler.c,272 :: 		if (PORTB.f6 == 0) {
	BTFSC      PORTB+0, 6
	GOTO       L_interrupt75
;COCIMIC_FP_Compiler.c,273 :: 		keyFlag = 1;    // Set keyFlag
	MOVLW      1
	MOVWF      _keyFlag+0
	MOVLW      0
	MOVWF      _keyFlag+1
;COCIMIC_FP_Compiler.c,274 :: 		delay_ms(100);  // Debounce button
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_interrupt76:
	DECFSZ     R13+0, 1
	GOTO       L_interrupt76
	DECFSZ     R12+0, 1
	GOTO       L_interrupt76
	DECFSZ     R11+0, 1
	GOTO       L_interrupt76
	NOP
	NOP
;COCIMIC_FP_Compiler.c,275 :: 		if (PORTB.f0 == 0) {
	BTFSC      PORTB+0, 0
	GOTO       L_interrupt77
;COCIMIC_FP_Compiler.c,276 :: 		key = 3;  // Set keypad value to 3
	MOVLW      3
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,277 :: 		} else if (PORTB.f1 == 0) {
	GOTO       L_interrupt78
L_interrupt77:
	BTFSC      PORTB+0, 1
	GOTO       L_interrupt79
;COCIMIC_FP_Compiler.c,278 :: 		key = 6;  // Set keypad value to 6
	MOVLW      6
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,279 :: 		} else if (PORTB.f2 == 0) {
	GOTO       L_interrupt80
L_interrupt79:
	BTFSC      PORTB+0, 2
	GOTO       L_interrupt81
;COCIMIC_FP_Compiler.c,280 :: 		key = 9;  // Set keypad value to 9
	MOVLW      9
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,281 :: 		} else if (PORTB.f3 == 0) {
	GOTO       L_interrupt82
L_interrupt81:
	BTFSC      PORTB+0, 3
	GOTO       L_interrupt83
;COCIMIC_FP_Compiler.c,282 :: 		key = 11;  // Set keypad value to 11 (#)
	MOVLW      11
	MOVWF      _key+0
	MOVLW      0
	MOVWF      _key+1
;COCIMIC_FP_Compiler.c,283 :: 		}
L_interrupt83:
L_interrupt82:
L_interrupt80:
L_interrupt78:
;COCIMIC_FP_Compiler.c,284 :: 		}
L_interrupt75:
;COCIMIC_FP_Compiler.c,286 :: 		INTCON.f0 = 0;  // Clear RBIF
	BCF        INTCON+0, 0
;COCIMIC_FP_Compiler.c,287 :: 		}
L_interrupt56:
;COCIMIC_FP_Compiler.c,288 :: 		INTCON.f7 = 1;  // Set GIE
	BSF        INTCON+0, 7
;COCIMIC_FP_Compiler.c,289 :: 		}
L_end_interrupt:
L__interrupt126:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;COCIMIC_FP_Compiler.c,292 :: 		void main() {
;COCIMIC_FP_Compiler.c,293 :: 		init();             // Initialize
	CALL       _init+0
;COCIMIC_FP_Compiler.c,294 :: 		initInterrupt();    // Initialize interrupt
	CALL       _initInterrupt+0
;COCIMIC_FP_Compiler.c,295 :: 		while (1) {         // Endless loop
L_main84:
;COCIMIC_FP_Compiler.c,296 :: 		keypadScan();   // Scan keypad
	CALL       _keypadScan+0
;COCIMIC_FP_Compiler.c,297 :: 		keypad();       // Keypad function
	CALL       _keypad+0
;COCIMIC_FP_Compiler.c,298 :: 		modeControl();  // Control mode
	CALL       _modeControl+0
;COCIMIC_FP_Compiler.c,299 :: 		}
	GOTO       L_main84
;COCIMIC_FP_Compiler.c,300 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
