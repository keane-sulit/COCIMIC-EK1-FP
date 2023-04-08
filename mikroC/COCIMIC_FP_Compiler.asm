
_init:

;COCIMIC_FP_Compiler.c,38 :: 		void init() {
;COCIMIC_FP_Compiler.c,40 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;COCIMIC_FP_Compiler.c,41 :: 		ADC_Init();
	CALL       _ADC_Init+0
;COCIMIC_FP_Compiler.c,42 :: 		Keypad_Init();
	CALL       _Keypad_Init+0
;COCIMIC_FP_Compiler.c,43 :: 		TRISD = 0xFF;
	MOVLW      255
	MOVWF      TRISD+0
;COCIMIC_FP_Compiler.c,44 :: 		TRISB.f1 = 0; // Set RB1 as output for PWM1
	BCF        TRISB+0, 1
;COCIMIC_FP_Compiler.c,45 :: 		PWM1_Init(25000);
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;COCIMIC_FP_Compiler.c,46 :: 		}
L_end_init:
	RETURN
; end of _init

_startFan:

;COCIMIC_FP_Compiler.c,48 :: 		void startFan() {
;COCIMIC_FP_Compiler.c,49 :: 		PORTB.f1 = 1;
	BSF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,50 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;COCIMIC_FP_Compiler.c,51 :: 		PWM1_Set_Duty(255*spdValue/100);
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
;COCIMIC_FP_Compiler.c,52 :: 		}
L_end_startFan:
	RETURN
; end of _startFan

_stopFan:

;COCIMIC_FP_Compiler.c,54 :: 		void stopFan() {
;COCIMIC_FP_Compiler.c,55 :: 		PORTB.f1 = 0;
	BCF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,56 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;COCIMIC_FP_Compiler.c,57 :: 		}
L_end_stopFan:
	RETURN
; end of _stopFan

_readTemp:

;COCIMIC_FP_Compiler.c,59 :: 		void readTemp() {
;COCIMIC_FP_Compiler.c,60 :: 		tempValue = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,61 :: 		tempValue = tempValue * 5;    // Convert ADC value to voltage
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,62 :: 		tempValue = tempValue / 10;  // Convert voltage to temperature
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,64 :: 		if (tempValue < 32) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readTemp54
	MOVLW      32
	SUBWF      R0+0, 0
L__readTemp54:
	BTFSC      STATUS+0, 0
	GOTO       L_readTemp0
;COCIMIC_FP_Compiler.c,65 :: 		tempValue = 0;
	CLRF       _tempValue+0
	CLRF       _tempValue+1
;COCIMIC_FP_Compiler.c,66 :: 		IntToStr(tempValue, txtTemp);
	CLRF       FARG_IntToStr_input+0
	CLRF       FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,67 :: 		Lcd_Out(1, 7, "   C ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,68 :: 		Lcd_Out(1, 12, "(-)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,69 :: 		Lcd_Out(2, 9, "  ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,70 :: 		} else {
	GOTO       L_readTemp1
L_readTemp0:
;COCIMIC_FP_Compiler.c,71 :: 		Lcd_Out(1, 12, "   ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,73 :: 		tempValue = tempValue - 32;
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
;COCIMIC_FP_Compiler.c,74 :: 		tempValue = tempValue * 5;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,75 :: 		tempValue = tempValue / 9;
	MOVLW      9
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,78 :: 		IntToStr(tempValue, txtTemp);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,79 :: 		}
L_readTemp1:
;COCIMIC_FP_Compiler.c,80 :: 		}
L_end_readTemp:
	RETURN
; end of _readTemp

_dispTemp:

;COCIMIC_FP_Compiler.c,82 :: 		void dispTemp() {
;COCIMIC_FP_Compiler.c,83 :: 		Lcd_Out(1, 1, "Temp: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,84 :: 		Lcd_Out(1, 7, ltrim(txtTemp));
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
;COCIMIC_FP_Compiler.c,85 :: 		Lcd_Out(1, 10, "C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,86 :: 		}
L_end_dispTemp:
	RETURN
; end of _dispTemp

_autoFanControl:

;COCIMIC_FP_Compiler.c,88 :: 		void autoFanControl() {
;COCIMIC_FP_Compiler.c,89 :: 		if (tempValue < 26) {
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl57
	MOVLW      26
	SUBWF      _tempValue+0, 0
L__autoFanControl57:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl2
;COCIMIC_FP_Compiler.c,90 :: 		spdValue = 0;
	CLRF       _spdValue+0
	CLRF       _spdValue+1
;COCIMIC_FP_Compiler.c,91 :: 		Lcd_Out(2, 9, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,92 :: 		stopFan();
	CALL       _stopFan+0
;COCIMIC_FP_Compiler.c,93 :: 		} else if (tempValue < 29) {
	GOTO       L_autoFanControl3
L_autoFanControl2:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl58
	MOVLW      29
	SUBWF      _tempValue+0, 0
L__autoFanControl58:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl4
;COCIMIC_FP_Compiler.c,94 :: 		spdValue = 10;
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,95 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,96 :: 		} else if (tempValue < 32) {
	GOTO       L_autoFanControl5
L_autoFanControl4:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl59
	MOVLW      32
	SUBWF      _tempValue+0, 0
L__autoFanControl59:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl6
;COCIMIC_FP_Compiler.c,97 :: 		spdValue = 30;
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,98 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,99 :: 		} else if (tempValue < 35) {
	GOTO       L_autoFanControl7
L_autoFanControl6:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl60
	MOVLW      35
	SUBWF      _tempValue+0, 0
L__autoFanControl60:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl8
;COCIMIC_FP_Compiler.c,100 :: 		spdValue = 50;
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,101 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,102 :: 		} else if (tempValue < 38) {
	GOTO       L_autoFanControl9
L_autoFanControl8:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl61
	MOVLW      38
	SUBWF      _tempValue+0, 0
L__autoFanControl61:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl10
;COCIMIC_FP_Compiler.c,103 :: 		spdValue = 70;
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,104 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,105 :: 		} else if (tempValue < 41) {
	GOTO       L_autoFanControl11
L_autoFanControl10:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl62
	MOVLW      41
	SUBWF      _tempValue+0, 0
L__autoFanControl62:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl12
;COCIMIC_FP_Compiler.c,106 :: 		spdValue = 90;
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,107 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,108 :: 		} else if (tempValue < 50) {
	GOTO       L_autoFanControl13
L_autoFanControl12:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl63
	MOVLW      50
	SUBWF      _tempValue+0, 0
L__autoFanControl63:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl14
;COCIMIC_FP_Compiler.c,109 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,110 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,111 :: 		} else {
	GOTO       L_autoFanControl15
L_autoFanControl14:
;COCIMIC_FP_Compiler.c,112 :: 		stopFan();
	CALL       _stopFan+0
;COCIMIC_FP_Compiler.c,113 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;COCIMIC_FP_Compiler.c,114 :: 		Lcd_Out(1, 1, "TOO HOT!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,115 :: 		Lcd_Out(2, 1, "FAN STOP!");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,116 :: 		delay_ms(300);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      157
	MOVWF      R12+0
	MOVLW      5
	MOVWF      R13+0
L_autoFanControl16:
	DECFSZ     R13+0, 1
	GOTO       L_autoFanControl16
	DECFSZ     R12+0, 1
	GOTO       L_autoFanControl16
	DECFSZ     R11+0, 1
	GOTO       L_autoFanControl16
	NOP
	NOP
;COCIMIC_FP_Compiler.c,117 :: 		}
L_autoFanControl15:
L_autoFanControl13:
L_autoFanControl11:
L_autoFanControl9:
L_autoFanControl7:
L_autoFanControl5:
L_autoFanControl3:
;COCIMIC_FP_Compiler.c,118 :: 		}
L_end_autoFanControl:
	RETURN
; end of _autoFanControl

_dispSpd:

;COCIMIC_FP_Compiler.c,120 :: 		void dispSpd() {
;COCIMIC_FP_Compiler.c,121 :: 		IntToStr(spdValue, txtSpd);             // Convert speed to string
	MOVF       _spdValue+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _spdValue+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtSpd+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,124 :: 		Lcd_Out(2, 1, "Speed: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,126 :: 		if (spdValue < 100) {
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd65
	MOVLW      100
	SUBWF      _spdValue+0, 0
L__dispSpd65:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd17
;COCIMIC_FP_Compiler.c,127 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
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
;COCIMIC_FP_Compiler.c,128 :: 		Lcd_Out(2, 10, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,129 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,130 :: 		} else {
	GOTO       L_dispSpd18
L_dispSpd17:
;COCIMIC_FP_Compiler.c,131 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
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
;COCIMIC_FP_Compiler.c,132 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,133 :: 		}
L_dispSpd18:
;COCIMIC_FP_Compiler.c,136 :: 		if (spdValue == 0) {
	MOVLW      0
	XORWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd66
	MOVLW      0
	XORWF      _spdValue+0, 0
L__dispSpd66:
	BTFSS      STATUS+0, 2
	GOTO       L_dispSpd19
;COCIMIC_FP_Compiler.c,137 :: 		Lcd_Out(2, 13, "OFF ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,138 :: 		} else if (spdValue < 33) {
	GOTO       L_dispSpd20
L_dispSpd19:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd67
	MOVLW      33
	SUBWF      _spdValue+0, 0
L__dispSpd67:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd21
;COCIMIC_FP_Compiler.c,139 :: 		Lcd_Out(2, 13, "LOW ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,140 :: 		} else if (spdValue < 66) {
	GOTO       L_dispSpd22
L_dispSpd21:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd68
	MOVLW      66
	SUBWF      _spdValue+0, 0
L__dispSpd68:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd23
;COCIMIC_FP_Compiler.c,141 :: 		Lcd_Out(2, 13, "MID ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr16_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,142 :: 		} else if (spdValue <= 99) {
	GOTO       L_dispSpd24
L_dispSpd23:
	MOVF       _spdValue+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd69
	MOVF       _spdValue+0, 0
	SUBLW      99
L__dispSpd69:
	BTFSS      STATUS+0, 0
	GOTO       L_dispSpd25
;COCIMIC_FP_Compiler.c,143 :: 		Lcd_Out(2, 13, "HIGH");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr17_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,144 :: 		} else {
	GOTO       L_dispSpd26
L_dispSpd25:
;COCIMIC_FP_Compiler.c,145 :: 		Lcd_Out(2, 13, "MAX ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr18_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,146 :: 		}
L_dispSpd26:
L_dispSpd24:
L_dispSpd22:
L_dispSpd20:
;COCIMIC_FP_Compiler.c,147 :: 		}
L_end_dispSpd:
	RETURN
; end of _dispSpd

_keypad:

;COCIMIC_FP_Compiler.c,149 :: 		void keypad() {
;COCIMIC_FP_Compiler.c,150 :: 		kp = 0;
	CLRF       _kp+0
;COCIMIC_FP_Compiler.c,151 :: 		kp = Keypad_Key_Click();
	CALL       _Keypad_Key_Click+0
	MOVF       R0+0, 0
	MOVWF      _kp+0
;COCIMIC_FP_Compiler.c,152 :: 		if (kp != 0) {
	MOVF       R0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_keypad27
;COCIMIC_FP_Compiler.c,153 :: 		switch (kp) {
	GOTO       L_keypad28
;COCIMIC_FP_Compiler.c,154 :: 		case 1: // 1
L_keypad30:
;COCIMIC_FP_Compiler.c,155 :: 		spdValue = 10;
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,156 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,157 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,158 :: 		case 2: // 2
L_keypad31:
;COCIMIC_FP_Compiler.c,159 :: 		spdValue = 20;
	MOVLW      20
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,160 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,161 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,162 :: 		case 3: // 3
L_keypad32:
;COCIMIC_FP_Compiler.c,163 :: 		spdValue = 30;
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,164 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,165 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,166 :: 		case 5: // 4
L_keypad33:
;COCIMIC_FP_Compiler.c,167 :: 		spdValue = 40;
	MOVLW      40
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,168 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,169 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,170 :: 		case 6: // 5
L_keypad34:
;COCIMIC_FP_Compiler.c,171 :: 		spdValue = 50;
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,172 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,173 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,174 :: 		case 7: // 6
L_keypad35:
;COCIMIC_FP_Compiler.c,175 :: 		spdValue = 60;
	MOVLW      60
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,176 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,177 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,178 :: 		case 9: // 7
L_keypad36:
;COCIMIC_FP_Compiler.c,179 :: 		spdValue = 70;
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,180 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,181 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,182 :: 		case 10: // 8
L_keypad37:
;COCIMIC_FP_Compiler.c,183 :: 		spdValue = 80;
	MOVLW      80
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,184 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,185 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,186 :: 		case 11: // 9
L_keypad38:
;COCIMIC_FP_Compiler.c,187 :: 		spdValue = 90;
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,188 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,189 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,190 :: 		case 13: // *
L_keypad39:
;COCIMIC_FP_Compiler.c,191 :: 		mode = 1;
	MOVLW      1
	MOVWF      _mode+0
;COCIMIC_FP_Compiler.c,192 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,193 :: 		case 14: // 0
L_keypad40:
;COCIMIC_FP_Compiler.c,194 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,195 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,196 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,197 :: 		case 15: // #
L_keypad41:
;COCIMIC_FP_Compiler.c,198 :: 		mode = 0;
	CLRF       _mode+0
;COCIMIC_FP_Compiler.c,199 :: 		break;
	GOTO       L_keypad29
;COCIMIC_FP_Compiler.c,201 :: 		}
L_keypad28:
	MOVF       _kp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_keypad30
	MOVF       _kp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_keypad31
	MOVF       _kp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_keypad32
	MOVF       _kp+0, 0
	XORLW      5
	BTFSC      STATUS+0, 2
	GOTO       L_keypad33
	MOVF       _kp+0, 0
	XORLW      6
	BTFSC      STATUS+0, 2
	GOTO       L_keypad34
	MOVF       _kp+0, 0
	XORLW      7
	BTFSC      STATUS+0, 2
	GOTO       L_keypad35
	MOVF       _kp+0, 0
	XORLW      9
	BTFSC      STATUS+0, 2
	GOTO       L_keypad36
	MOVF       _kp+0, 0
	XORLW      10
	BTFSC      STATUS+0, 2
	GOTO       L_keypad37
	MOVF       _kp+0, 0
	XORLW      11
	BTFSC      STATUS+0, 2
	GOTO       L_keypad38
	MOVF       _kp+0, 0
	XORLW      13
	BTFSC      STATUS+0, 2
	GOTO       L_keypad39
	MOVF       _kp+0, 0
	XORLW      14
	BTFSC      STATUS+0, 2
	GOTO       L_keypad40
	MOVF       _kp+0, 0
	XORLW      15
	BTFSC      STATUS+0, 2
	GOTO       L_keypad41
L_keypad29:
;COCIMIC_FP_Compiler.c,202 :: 		}
L_keypad27:
;COCIMIC_FP_Compiler.c,203 :: 		}
L_end_keypad:
	RETURN
; end of _keypad

_welcome:

;COCIMIC_FP_Compiler.c,205 :: 		void welcome() {
;COCIMIC_FP_Compiler.c,206 :: 		Lcd_Out(1, 1, "COCIMIC-EK1 TERM 2 PROJECT");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr19_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,207 :: 		Lcd_Out(2, 1, "Dayrit | Guevarra | Rodriguez | Sulit");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr20_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,208 :: 		for (i = 0; i < 22; i++) {
	CLRF       _i+0
L_welcome42:
	MOVLW      22
	SUBWF      _i+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_welcome43
;COCIMIC_FP_Compiler.c,209 :: 		Lcd_Cmd(_LCD_SHIFT_LEFT);
	MOVLW      24
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;COCIMIC_FP_Compiler.c,210 :: 		delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_welcome45:
	DECFSZ     R13+0, 1
	GOTO       L_welcome45
	DECFSZ     R12+0, 1
	GOTO       L_welcome45
	NOP
;COCIMIC_FP_Compiler.c,208 :: 		for (i = 0; i < 22; i++) {
	INCF       _i+0, 1
;COCIMIC_FP_Compiler.c,211 :: 		}
	GOTO       L_welcome42
L_welcome43:
;COCIMIC_FP_Compiler.c,212 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;COCIMIC_FP_Compiler.c,213 :: 		}
L_end_welcome:
	RETURN
; end of _welcome

_main:

;COCIMIC_FP_Compiler.c,215 :: 		void main() {
;COCIMIC_FP_Compiler.c,216 :: 		init();
	CALL       _init+0
;COCIMIC_FP_Compiler.c,217 :: 		welcome();
	CALL       _welcome+0
;COCIMIC_FP_Compiler.c,218 :: 		while(1) {                              // Endless loop
L_main46:
;COCIMIC_FP_Compiler.c,219 :: 		keypad();
	CALL       _keypad+0
;COCIMIC_FP_Compiler.c,220 :: 		if (mode == 1) {
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main48
;COCIMIC_FP_Compiler.c,221 :: 		Lcd_Out(1, 1, "               M");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr21_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,222 :: 		dispSpd();
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,223 :: 		keypad();
	CALL       _keypad+0
;COCIMIC_FP_Compiler.c,224 :: 		} else {
	GOTO       L_main49
L_main48:
;COCIMIC_FP_Compiler.c,225 :: 		Lcd_Out(1, 16, "A");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      16
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr22_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,226 :: 		readTemp();
	CALL       _readTemp+0
;COCIMIC_FP_Compiler.c,227 :: 		dispTemp();
	CALL       _dispTemp+0
;COCIMIC_FP_Compiler.c,228 :: 		dispSpd();
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,229 :: 		autoFanControl();
	CALL       _autoFanControl+0
;COCIMIC_FP_Compiler.c,230 :: 		}
L_main49:
;COCIMIC_FP_Compiler.c,231 :: 		}
	GOTO       L_main46
;COCIMIC_FP_Compiler.c,232 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
