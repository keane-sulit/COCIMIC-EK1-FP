
_init:

;COCIMIC_FP_Compiler.c,41 :: 		void init() {
;COCIMIC_FP_Compiler.c,42 :: 		Lcd_Init();                     // Initialize LCD library
	CALL       _Lcd_Init+0
;COCIMIC_FP_Compiler.c,43 :: 		ADC_Init();                     // Initialize ADC library
	CALL       _ADC_Init+0
;COCIMIC_FP_Compiler.c,44 :: 		Keypad_Init();                  // Initialize Keypad library
	CALL       _Keypad_Init+0
;COCIMIC_FP_Compiler.c,45 :: 		TRISD = 0xFF;                   // Set PORTD as input
	MOVLW      255
	MOVWF      TRISD+0
;COCIMIC_FP_Compiler.c,46 :: 		TRISB.f1 = 0;                   // Set RB1 as output for PWM1
	BCF        TRISB+0, 1
;COCIMIC_FP_Compiler.c,47 :: 		PWM1_Init(25000);               // Initialize PWM1 module at 25KHz
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;COCIMIC_FP_Compiler.c,48 :: 		}
L_end_init:
	RETURN
; end of _init

_startFan:

;COCIMIC_FP_Compiler.c,51 :: 		void startFan() {
;COCIMIC_FP_Compiler.c,52 :: 		PORTB.f1 = 1;                       // Set RB1 high
	BSF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,53 :: 		PWM1_Start();                       // Start PWM1 module
	CALL       _PWM1_Start+0
;COCIMIC_FP_Compiler.c,54 :: 		PWM1_Set_Duty(255*spdValue/100);    // Set PWM1 duty cycle
	MOVLW      255
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       _spdValue+0, 0
	MOVWF      R4+0
	MOVF       _spdValue+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;COCIMIC_FP_Compiler.c,55 :: 		}
L_end_startFan:
	RETURN
; end of _startFan

_stopFan:

;COCIMIC_FP_Compiler.c,58 :: 		void stopFan() {
;COCIMIC_FP_Compiler.c,59 :: 		PORTB.f1 = 0;                   // Set RB1 low
	BCF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,60 :: 		PWM1_Stop();                    // Stop PWM1 module
	CALL       _PWM1_Stop+0
;COCIMIC_FP_Compiler.c,61 :: 		}
L_end_stopFan:
	RETURN
; end of _stopFan

_readTemp:

;COCIMIC_FP_Compiler.c,64 :: 		void readTemp() {
;COCIMIC_FP_Compiler.c,65 :: 		tempValue = ADC_Read(0);        // Read ADC value at channel 0
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,66 :: 		tempValue = tempValue * 5;      // Convert ADC value to voltage
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,67 :: 		tempValue = tempValue / 10;     // Convert voltage to temperature
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,70 :: 		if (tempValue < 32) {                       // If temperature is below 32F
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readTemp49
	MOVLW      32
	SUBWF      R0+0, 0
L__readTemp49:
	BTFSC      STATUS+0, 0
	GOTO       L_readTemp0
;COCIMIC_FP_Compiler.c,71 :: 		tempValue = 0;                          // Set temperature to 0
	CLRF       _tempValue+0
	CLRF       _tempValue+1
;COCIMIC_FP_Compiler.c,72 :: 		IntToStr(tempValue, txtTemp);           // Convert temperature to string
	CLRF       FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,75 :: 		Lcd_Out(1, 7, "   C ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,76 :: 		Lcd_Out(1, 12, "(-)");                  // Display negative sign
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,77 :: 		Lcd_Out(2, 9, "  ");                    // Clear values using space
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,79 :: 		} else {                                    // If temperature is above 32F
	GOTO       L_readTemp1
L_readTemp0:
;COCIMIC_FP_Compiler.c,80 :: 		Lcd_Out(1, 12, "   ");                  // Clear values using space
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,83 :: 		tempValue = tempValue - 32;
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
;COCIMIC_FP_Compiler.c,84 :: 		tempValue = tempValue * 5;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,85 :: 		tempValue = tempValue / 9;
	MOVLW      9
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,86 :: 		IntToStr(tempValue, txtTemp);           // Convert temperature in Celsius to string
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,87 :: 		}
L_readTemp1:
;COCIMIC_FP_Compiler.c,88 :: 		}
L_end_readTemp:
	RETURN
; end of _readTemp

_dispTemp:

;COCIMIC_FP_Compiler.c,91 :: 		void dispTemp() {
;COCIMIC_FP_Compiler.c,94 :: 		Lcd_Out(1, 1, "Temp: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,95 :: 		Lcd_Out(1, 7, ltrim(txtTemp));
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
;COCIMIC_FP_Compiler.c,96 :: 		Lcd_Out(1, 10, "C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,97 :: 		}
L_end_dispTemp:
	RETURN
; end of _dispTemp

_autoFanControl:

;COCIMIC_FP_Compiler.c,100 :: 		void autoFanControl() {
;COCIMIC_FP_Compiler.c,103 :: 		if (tempValue < 26) {               // If temperature is below 26C, turn off fan
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl52
	MOVLW      26
	SUBWF      _tempValue+0, 0
L__autoFanControl52:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl2
;COCIMIC_FP_Compiler.c,104 :: 		spdValue = 0;
	CLRF       _spdValue+0
	CLRF       _spdValue+1
;COCIMIC_FP_Compiler.c,105 :: 		Lcd_Out(2, 9, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,106 :: 		stopFan();
	CALL       _stopFan+0
;COCIMIC_FP_Compiler.c,107 :: 		} else if (tempValue < 29) {        // If temperature is between 26C and 29C, set fan speed to 10%
	GOTO       L_autoFanControl3
L_autoFanControl2:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl53
	MOVLW      29
	SUBWF      _tempValue+0, 0
L__autoFanControl53:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl4
;COCIMIC_FP_Compiler.c,108 :: 		spdValue = 10;
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,109 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,110 :: 		} else if (tempValue < 32) {        // If temperature is between 29C and 32C, set fan speed to 30%
	GOTO       L_autoFanControl5
L_autoFanControl4:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl54
	MOVLW      32
	SUBWF      _tempValue+0, 0
L__autoFanControl54:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl6
;COCIMIC_FP_Compiler.c,111 :: 		spdValue = 30;
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,112 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,113 :: 		} else if (tempValue < 35) {        // If temperature is between 32C and 35C, set fan speed to 50%
	GOTO       L_autoFanControl7
L_autoFanControl6:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl55
	MOVLW      35
	SUBWF      _tempValue+0, 0
L__autoFanControl55:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl8
;COCIMIC_FP_Compiler.c,114 :: 		spdValue = 50;
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,115 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,116 :: 		} else if (tempValue < 38) {        // If temperature is between 35C and 38C, set fan speed to 70%
	GOTO       L_autoFanControl9
L_autoFanControl8:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl56
	MOVLW      38
	SUBWF      _tempValue+0, 0
L__autoFanControl56:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl10
;COCIMIC_FP_Compiler.c,117 :: 		spdValue = 70;
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,118 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,119 :: 		} else if (tempValue < 41) {        // If temperature is between 38C and 41C, set fan speed to 90%
	GOTO       L_autoFanControl11
L_autoFanControl10:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl57
	MOVLW      41
	SUBWF      _tempValue+0, 0
L__autoFanControl57:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl12
;COCIMIC_FP_Compiler.c,120 :: 		spdValue = 90;
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,121 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,122 :: 		} else if (tempValue < 50) {        // If temperature is between 41C and 50C, set fan speed to 100%
	GOTO       L_autoFanControl13
L_autoFanControl12:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl58
	MOVLW      50
	SUBWF      _tempValue+0, 0
L__autoFanControl58:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl14
;COCIMIC_FP_Compiler.c,123 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,124 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,125 :: 		} else {                            // If temperature is above 50C, show warning message (!)
	GOTO       L_autoFanControl15
L_autoFanControl14:
;COCIMIC_FP_Compiler.c,126 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,127 :: 		Lcd_Out(1, 12, "(!)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,128 :: 		}
L_autoFanControl15:
L_autoFanControl13:
L_autoFanControl11:
L_autoFanControl9:
L_autoFanControl7:
L_autoFanControl5:
L_autoFanControl3:
;COCIMIC_FP_Compiler.c,129 :: 		}
L_end_autoFanControl:
	RETURN
; end of _autoFanControl

_dispSpd:

;COCIMIC_FP_Compiler.c,132 :: 		void dispSpd() {
;COCIMIC_FP_Compiler.c,133 :: 		IntToStr(spdValue, txtSpd);             // Convert speed to string
	MOVF       _spdValue+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _spdValue+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtSpd+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,136 :: 		Lcd_Out(2, 1, "Speed: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,139 :: 		if (spdValue < 100) {                   // If speed is less than 100, clear 3rd digit using space
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd60
	MOVLW      100
	SUBWF      _spdValue+0, 0
L__dispSpd60:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd16
;COCIMIC_FP_Compiler.c,140 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
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
;COCIMIC_FP_Compiler.c,141 :: 		Lcd_Out(2, 10, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,142 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,143 :: 		} else {                                // If speed is 100, as is
	GOTO       L_dispSpd17
L_dispSpd16:
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
;COCIMIC_FP_Compiler.c,145 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,146 :: 		}
L_dispSpd17:
;COCIMIC_FP_Compiler.c,149 :: 		if (spdValue == 0) {                    // If speed is 0, display OFF
	MOVLW      0
	XORWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd61
	MOVLW      0
	XORWF      _spdValue+0, 0
L__dispSpd61:
	BTFSS      STATUS+0, 2
	GOTO       L_dispSpd18
;COCIMIC_FP_Compiler.c,150 :: 		Lcd_Out(2, 13, "OFF ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,151 :: 		} else if (spdValue < 33) {             // If speed is between 0 and 33, display LOW
	GOTO       L_dispSpd19
L_dispSpd18:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd62
	MOVLW      33
	SUBWF      _spdValue+0, 0
L__dispSpd62:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd20
;COCIMIC_FP_Compiler.c,152 :: 		Lcd_Out(2, 13, "LOW ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,153 :: 		} else if (spdValue < 66) {             // If speed is between 33 and 66, display MID
	GOTO       L_dispSpd21
L_dispSpd20:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd63
	MOVLW      66
	SUBWF      _spdValue+0, 0
L__dispSpd63:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd22
;COCIMIC_FP_Compiler.c,154 :: 		Lcd_Out(2, 13, "MID ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,155 :: 		} else if (spdValue <= 99) {            // If speed is between 66 and 99, display HIGH
	GOTO       L_dispSpd23
L_dispSpd22:
	MOVF       _spdValue+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd64
	MOVF       _spdValue+0, 0
	SUBLW      99
L__dispSpd64:
	BTFSS      STATUS+0, 0
	GOTO       L_dispSpd24
;COCIMIC_FP_Compiler.c,156 :: 		Lcd_Out(2, 13, "HIGH");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr16_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,157 :: 		} else {                                // If speed is 100, display MAX
	GOTO       L_dispSpd25
L_dispSpd24:
;COCIMIC_FP_Compiler.c,158 :: 		Lcd_Out(2, 13, "MAX ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr17_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,159 :: 		}
L_dispSpd25:
L_dispSpd23:
L_dispSpd21:
L_dispSpd19:
;COCIMIC_FP_Compiler.c,160 :: 		}
L_end_dispSpd:
	RETURN
; end of _dispSpd

_keypad:

;COCIMIC_FP_Compiler.c,163 :: 		void keypad() {
;COCIMIC_FP_Compiler.c,164 :: 		kp = 0;                                 // Clear kp variable
	CLRF       _kp+0
;COCIMIC_FP_Compiler.c,165 :: 		kp = Keypad_Key_Click();                // Read keypad value
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;COCIMIC_FP_Compiler.c,168 :: 		if (kp != 0) {                          // If keypad value is pressed
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_keypad26
;COCIMIC_FP_Compiler.c,169 :: 		switch (kp) {
	GOTO       L_keypad27
;COCIMIC_FP_Compiler.c,170 :: 		case 1:
L_keypad29:
;COCIMIC_FP_Compiler.c,171 :: 		spdValue = 10;              // Set speed to 10% if 1 is pressed
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,172 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,173 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,174 :: 		case 2:
L_keypad30:
;COCIMIC_FP_Compiler.c,175 :: 		spdValue = 20;              // Set speed to 20% if 2 is pressed
	MOVLW      20
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,176 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,177 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,178 :: 		case 3:
L_keypad31:
;COCIMIC_FP_Compiler.c,179 :: 		spdValue = 30;              // Set speed to 30% if 3 is pressed
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,180 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,181 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,182 :: 		case 5:
L_keypad32:
;COCIMIC_FP_Compiler.c,183 :: 		spdValue = 40;              // Set speed to 40% if 4 is pressed
	MOVLW      40
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,184 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,185 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,186 :: 		case 6:
L_keypad33:
;COCIMIC_FP_Compiler.c,187 :: 		spdValue = 50;              // Set speed to 50% if 5 is pressed
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,188 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,189 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,190 :: 		case 7:
L_keypad34:
;COCIMIC_FP_Compiler.c,191 :: 		spdValue = 60;              // Set speed to 60% if 6 is pressed
	MOVLW      60
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,192 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,193 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,194 :: 		case 9:
L_keypad35:
;COCIMIC_FP_Compiler.c,195 :: 		spdValue = 70;              // Set speed to 70% if 7 is pressed
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,196 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,197 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,198 :: 		case 10:
L_keypad36:
;COCIMIC_FP_Compiler.c,199 :: 		spdValue = 80;              // Set speed to 80% if 8 is pressed
	MOVLW      80
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,200 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,201 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,202 :: 		case 11:
L_keypad37:
;COCIMIC_FP_Compiler.c,203 :: 		spdValue = 90;              // Set speed to 90% if 9 is pressed
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,204 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,205 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,206 :: 		case 13:                        // Set mode to manual if * is pressed
L_keypad38:
;COCIMIC_FP_Compiler.c,207 :: 		mode = 1;
	MOVLW      1
	MOVWF      _mode+0
;COCIMIC_FP_Compiler.c,208 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,209 :: 		case 14:                        // Set speed to 100% if 0 is pressed
L_keypad39:
;COCIMIC_FP_Compiler.c,210 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,211 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,212 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,213 :: 		case 15:                        // Set mode to auto if # is pressed
L_keypad40:
;COCIMIC_FP_Compiler.c,214 :: 		mode = 0;
	CLRF       _mode+0
;COCIMIC_FP_Compiler.c,215 :: 		break;
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,217 :: 		}
L_keypad27:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_keypad29
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_keypad30
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_keypad31
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_keypad32
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_keypad33
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_keypad34
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_keypad35
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_keypad36
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_keypad37
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_keypad38
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_keypad39
	MOVF       _kp+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_keypad40
L_keypad28:
;COCIMIC_FP_Compiler.c,218 :: 		}
L_keypad26:
;COCIMIC_FP_Compiler.c,219 :: 		}
L_end_keypad:
	RETURN
; end of _keypad

_modeControl:

;COCIMIC_FP_Compiler.c,222 :: 		void modeControl() {
;COCIMIC_FP_Compiler.c,225 :: 		if (mode == 1) {                                // If mode is manual
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_modeControl41
;COCIMIC_FP_Compiler.c,226 :: 		Lcd_Out(1, 1, "               M");      // Clear temperature reading and display M on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr18_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,227 :: 		keypad();                               // Read keypad
	CALL       _keypad+0
;COCIMIC_FP_Compiler.c,228 :: 		dispSpd();                              // Display speed based on keypad input
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,229 :: 		} else {
	GOTO       L_modeControl42
L_modeControl41:
;COCIMIC_FP_Compiler.c,230 :: 		Lcd_Out(1, 16, "A");                    // Display A on LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr19_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,231 :: 		readTemp();                             // Read temperature
	CALL       _readTemp+0
;COCIMIC_FP_Compiler.c,232 :: 		dispTemp();                             // Display temperature
	CALL       _dispTemp+0
;COCIMIC_FP_Compiler.c,233 :: 		dispSpd();                              // Display speed
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,234 :: 		autoFanControl();                       // Control fan speed based on temperature
	CALL       _autoFanControl+0
;COCIMIC_FP_Compiler.c,235 :: 		}
L_modeControl42:
;COCIMIC_FP_Compiler.c,236 :: 		}
L_end_modeControl:
	RETURN
; end of _modeControl

_main:

;COCIMIC_FP_Compiler.c,239 :: 		void main() {
;COCIMIC_FP_Compiler.c,240 :: 		init();                    // Initialize
	CALL       _init+0
;COCIMIC_FP_Compiler.c,241 :: 		while(1) {                 // Endless loop
L_main43:
;COCIMIC_FP_Compiler.c,242 :: 		keypad();              // Read keypad
	CALL       _keypad+0
;COCIMIC_FP_Compiler.c,243 :: 		modeControl();         // Control mode
	CALL       _modeControl+0
;COCIMIC_FP_Compiler.c,244 :: 		}
	GOTO       L_main43
;COCIMIC_FP_Compiler.c,245 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
