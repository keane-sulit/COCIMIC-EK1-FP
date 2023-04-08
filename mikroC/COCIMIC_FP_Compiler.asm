
_init:

;COCIMIC_FP_Compiler.c,29 :: 		void init() {
;COCIMIC_FP_Compiler.c,31 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;COCIMIC_FP_Compiler.c,32 :: 		ADC_Init();
	CALL       _ADC_Init+0
;COCIMIC_FP_Compiler.c,33 :: 		TRISB.f1 = 0; // Set RB1 as output for PWM1
	BCF        TRISB+0, 1
;COCIMIC_FP_Compiler.c,34 :: 		PWM1_Init(25000);
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;COCIMIC_FP_Compiler.c,35 :: 		}
L_end_init:
	RETURN
; end of _init

_startFan:

;COCIMIC_FP_Compiler.c,37 :: 		void startFan() {
;COCIMIC_FP_Compiler.c,38 :: 		PORTB.f1 = 1;
	BSF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,39 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;COCIMIC_FP_Compiler.c,40 :: 		PWM1_Set_Duty(255*spdValue/100);
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
;COCIMIC_FP_Compiler.c,41 :: 		}
L_end_startFan:
	RETURN
; end of _startFan

_stopFan:

;COCIMIC_FP_Compiler.c,43 :: 		void stopFan() {
;COCIMIC_FP_Compiler.c,44 :: 		PORTB.f1 = 0;
	BCF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,45 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;COCIMIC_FP_Compiler.c,46 :: 		}
L_end_stopFan:
	RETURN
; end of _stopFan

_readTemp:

;COCIMIC_FP_Compiler.c,48 :: 		void readTemp() {
;COCIMIC_FP_Compiler.c,49 :: 		tempValue = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,50 :: 		tempValue = tempValue * 5;    // Convert ADC value to voltage
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,51 :: 		tempValue = tempValue / 10;  // Convert voltage to temperature
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,53 :: 		if (tempValue < 32) {
	MOVLW      0
	SUBWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__readTemp33
	MOVLW      32
	SUBWF      R0+0, 0
L__readTemp33:
	BTFSC      STATUS+0, 0
	GOTO       L_readTemp0
;COCIMIC_FP_Compiler.c,54 :: 		tempValue = 0;
	CLRF       _tempValue+0
	CLRF       _tempValue+1
;COCIMIC_FP_Compiler.c,55 :: 		Lcd_Out(1, 12, "(-)");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,56 :: 		} else {
	GOTO       L_readTemp1
L_readTemp0:
;COCIMIC_FP_Compiler.c,57 :: 		Lcd_Out(1, 12, "   ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,59 :: 		tempValue = tempValue - 32;
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
;COCIMIC_FP_Compiler.c,60 :: 		tempValue = tempValue * 5;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,61 :: 		tempValue = tempValue / 9;
	MOVLW      9
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,64 :: 		IntToStr(tempValue, txtTemp);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,65 :: 		}
L_readTemp1:
;COCIMIC_FP_Compiler.c,66 :: 		}
L_end_readTemp:
	RETURN
; end of _readTemp

_dispTemp:

;COCIMIC_FP_Compiler.c,68 :: 		void dispTemp() {
;COCIMIC_FP_Compiler.c,69 :: 		Lcd_Out(1, 1, "Temp: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,70 :: 		Lcd_Out(1, 7, ltrim(txtTemp));
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
;COCIMIC_FP_Compiler.c,71 :: 		Lcd_Out(1, 10, "C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,72 :: 		}
L_end_dispTemp:
	RETURN
; end of _dispTemp

_autoFanControl:

;COCIMIC_FP_Compiler.c,74 :: 		void autoFanControl() {
;COCIMIC_FP_Compiler.c,75 :: 		if (tempValue < 26) {
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl36
	MOVLW      26
	SUBWF      _tempValue+0, 0
L__autoFanControl36:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl2
;COCIMIC_FP_Compiler.c,76 :: 		spdValue = 0;
	CLRF       _spdValue+0
	CLRF       _spdValue+1
;COCIMIC_FP_Compiler.c,77 :: 		stopFan();
	CALL       _stopFan+0
;COCIMIC_FP_Compiler.c,78 :: 		} else if (tempValue < 29) {
	GOTO       L_autoFanControl3
L_autoFanControl2:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl37
	MOVLW      29
	SUBWF      _tempValue+0, 0
L__autoFanControl37:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl4
;COCIMIC_FP_Compiler.c,79 :: 		spdValue = 10;
	MOVLW      10
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,80 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,81 :: 		} else if (tempValue < 32) {
	GOTO       L_autoFanControl5
L_autoFanControl4:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl38
	MOVLW      32
	SUBWF      _tempValue+0, 0
L__autoFanControl38:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl6
;COCIMIC_FP_Compiler.c,82 :: 		spdValue = 30;
	MOVLW      30
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,83 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,84 :: 		} else if (tempValue < 35) {
	GOTO       L_autoFanControl7
L_autoFanControl6:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl39
	MOVLW      35
	SUBWF      _tempValue+0, 0
L__autoFanControl39:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl8
;COCIMIC_FP_Compiler.c,85 :: 		spdValue = 50;
	MOVLW      50
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,86 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,87 :: 		} else if (tempValue < 38) {
	GOTO       L_autoFanControl9
L_autoFanControl8:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl40
	MOVLW      38
	SUBWF      _tempValue+0, 0
L__autoFanControl40:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl10
;COCIMIC_FP_Compiler.c,88 :: 		spdValue = 70;
	MOVLW      70
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,89 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,90 :: 		} else if (tempValue < 41) {
	GOTO       L_autoFanControl11
L_autoFanControl10:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl41
	MOVLW      41
	SUBWF      _tempValue+0, 0
L__autoFanControl41:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl12
;COCIMIC_FP_Compiler.c,91 :: 		spdValue = 90;
	MOVLW      90
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,92 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,93 :: 		} else if (tempValue < 50) {
	GOTO       L_autoFanControl13
L_autoFanControl12:
	MOVLW      0
	SUBWF      _tempValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__autoFanControl42
	MOVLW      50
	SUBWF      _tempValue+0, 0
L__autoFanControl42:
	BTFSC      STATUS+0, 0
	GOTO       L_autoFanControl14
;COCIMIC_FP_Compiler.c,94 :: 		spdValue = 100;
	MOVLW      100
	MOVWF      _spdValue+0
	MOVLW      0
	MOVWF      _spdValue+1
;COCIMIC_FP_Compiler.c,95 :: 		startFan();
	CALL       _startFan+0
;COCIMIC_FP_Compiler.c,96 :: 		} else {
	GOTO       L_autoFanControl15
L_autoFanControl14:
;COCIMIC_FP_Compiler.c,97 :: 		stopFan();
	CALL       _stopFan+0
;COCIMIC_FP_Compiler.c,98 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;COCIMIC_FP_Compiler.c,99 :: 		Lcd_Out(1, 1, "TOO HOT!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,100 :: 		Lcd_Out(2, 1, "FAN STOP!");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,101 :: 		delay_ms(300);
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
;COCIMIC_FP_Compiler.c,102 :: 		}
L_autoFanControl15:
L_autoFanControl13:
L_autoFanControl11:
L_autoFanControl9:
L_autoFanControl7:
L_autoFanControl5:
L_autoFanControl3:
;COCIMIC_FP_Compiler.c,103 :: 		}
L_end_autoFanControl:
	RETURN
; end of _autoFanControl

_dispSpd:

;COCIMIC_FP_Compiler.c,105 :: 		void dispSpd() {
;COCIMIC_FP_Compiler.c,106 :: 		IntToStr(spdValue, txtSpd);             // Convert speed to string
	MOVF       _spdValue+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _spdValue+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtSpd+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,109 :: 		Lcd_Out(2, 1, "Speed: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,111 :: 		if (spdValue < 100) {
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd44
	MOVLW      100
	SUBWF      _spdValue+0, 0
L__dispSpd44:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd17
;COCIMIC_FP_Compiler.c,112 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
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
;COCIMIC_FP_Compiler.c,113 :: 		Lcd_Out(2, 10, " ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,114 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,115 :: 		} else {
	GOTO       L_dispSpd18
L_dispSpd17:
;COCIMIC_FP_Compiler.c,116 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
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
;COCIMIC_FP_Compiler.c,117 :: 		Lcd_Out(2, 11, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      11
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,118 :: 		}
L_dispSpd18:
;COCIMIC_FP_Compiler.c,121 :: 		if (spdValue == 0) {
	MOVLW      0
	XORWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd45
	MOVLW      0
	XORWF      _spdValue+0, 0
L__dispSpd45:
	BTFSS      STATUS+0, 2
	GOTO       L_dispSpd19
;COCIMIC_FP_Compiler.c,122 :: 		Lcd_Out(2, 13, "OFF ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,123 :: 		} else if (spdValue < 33) {
	GOTO       L_dispSpd20
L_dispSpd19:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd46
	MOVLW      33
	SUBWF      _spdValue+0, 0
L__dispSpd46:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd21
;COCIMIC_FP_Compiler.c,124 :: 		Lcd_Out(2, 13, "LOW ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,125 :: 		} else if (spdValue < 66) {
	GOTO       L_dispSpd22
L_dispSpd21:
	MOVLW      0
	SUBWF      _spdValue+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd47
	MOVLW      66
	SUBWF      _spdValue+0, 0
L__dispSpd47:
	BTFSC      STATUS+0, 0
	GOTO       L_dispSpd23
;COCIMIC_FP_Compiler.c,126 :: 		Lcd_Out(2, 13, "MID ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,127 :: 		} else if (spdValue <= 99) {
	GOTO       L_dispSpd24
L_dispSpd23:
	MOVF       _spdValue+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__dispSpd48
	MOVF       _spdValue+0, 0
	SUBLW      99
L__dispSpd48:
	BTFSS      STATUS+0, 0
	GOTO       L_dispSpd25
;COCIMIC_FP_Compiler.c,128 :: 		Lcd_Out(2, 13, "HIGH");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,129 :: 		} else {
	GOTO       L_dispSpd26
L_dispSpd25:
;COCIMIC_FP_Compiler.c,130 :: 		Lcd_Out(2, 13, "MAX ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr15_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,131 :: 		}
L_dispSpd26:
L_dispSpd24:
L_dispSpd22:
L_dispSpd20:
;COCIMIC_FP_Compiler.c,132 :: 		}
L_end_dispSpd:
	RETURN
; end of _dispSpd

_main:

;COCIMIC_FP_Compiler.c,134 :: 		void main() {
;COCIMIC_FP_Compiler.c,135 :: 		init();
	CALL       _init+0
;COCIMIC_FP_Compiler.c,137 :: 		while(1) {                              // Endless loop
L_main27:
;COCIMIC_FP_Compiler.c,138 :: 		readTemp();
	CALL       _readTemp+0
;COCIMIC_FP_Compiler.c,139 :: 		dispTemp();
	CALL       _dispTemp+0
;COCIMIC_FP_Compiler.c,140 :: 		dispSpd();
	CALL       _dispSpd+0
;COCIMIC_FP_Compiler.c,141 :: 		autoFanControl();
	CALL       _autoFanControl+0
;COCIMIC_FP_Compiler.c,142 :: 		}
	GOTO       L_main27
;COCIMIC_FP_Compiler.c,143 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
