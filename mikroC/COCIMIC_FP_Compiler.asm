
_Move_Delay:

;COCIMIC_FP_Compiler.c,29 :: 		void Move_Delay() {                  // Function used for text moving
;COCIMIC_FP_Compiler.c,30 :: 		Delay_ms(500);                     // You can change the moving speed here
	MOVLW      13
	MOVWF      R11+0
	MOVLW      175
	MOVWF      R12+0
	MOVLW      182
	MOVWF      R13+0
L_Move_Delay0:
	DECFSZ     R13+0, 1
	GOTO       L_Move_Delay0
	DECFSZ     R12+0, 1
	GOTO       L_Move_Delay0
	DECFSZ     R11+0, 1
	GOTO       L_Move_Delay0
	NOP
;COCIMIC_FP_Compiler.c,31 :: 		}
L_end_Move_Delay:
	RETURN
; end of _Move_Delay

_init:

;COCIMIC_FP_Compiler.c,34 :: 		void init() {
;COCIMIC_FP_Compiler.c,36 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;COCIMIC_FP_Compiler.c,37 :: 		ADC_Init();
	CALL       _ADC_Init+0
;COCIMIC_FP_Compiler.c,38 :: 		TRISB.f1 = 0; // Set RB1 as output for PWM1
	BCF        TRISB+0, 1
;COCIMIC_FP_Compiler.c,39 :: 		PWM1_Init(25000);
	BCF        T2CON+0, 0
	BCF        T2CON+0, 1
	MOVLW      199
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;COCIMIC_FP_Compiler.c,40 :: 		}
L_end_init:
	RETURN
; end of _init

_readTemp:

;COCIMIC_FP_Compiler.c,42 :: 		void readTemp() {
;COCIMIC_FP_Compiler.c,43 :: 		tempValue = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,44 :: 		tempValue = tempValue * 5;    // Convert ADC value to voltage
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,45 :: 		tempValue = tempValue / 10;  // Convert voltage to temperature
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,48 :: 		tempValue = tempValue - 32;
	MOVLW      32
	SUBWF      R0+0, 1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,49 :: 		tempValue = tempValue * 5;
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,50 :: 		tempValue = tempValue / 9;
	MOVLW      9
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _tempValue+0
	MOVF       R0+1, 0
	MOVWF      _tempValue+1
;COCIMIC_FP_Compiler.c,53 :: 		IntToStr(tempValue, txtTemp);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txtTemp+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;COCIMIC_FP_Compiler.c,54 :: 		}
L_end_readTemp:
	RETURN
; end of _readTemp

_dispTemp:

;COCIMIC_FP_Compiler.c,56 :: 		void dispTemp() {
;COCIMIC_FP_Compiler.c,57 :: 		Lcd_Out(1, 1, "Temp: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,58 :: 		delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_dispTemp1:
	DECFSZ     R13+0, 1
	GOTO       L_dispTemp1
	DECFSZ     R12+0, 1
	GOTO       L_dispTemp1
	NOP
;COCIMIC_FP_Compiler.c,59 :: 		Lcd_Out(1, 7, ltrim(txtTemp));
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
;COCIMIC_FP_Compiler.c,60 :: 		Lcd_Out(1, 10, "C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,61 :: 		delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_dispTemp2:
	DECFSZ     R13+0, 1
	GOTO       L_dispTemp2
	DECFSZ     R12+0, 1
	GOTO       L_dispTemp2
	NOP
;COCIMIC_FP_Compiler.c,62 :: 		}
L_end_dispTemp:
	RETURN
; end of _dispTemp

_fanControl:

;COCIMIC_FP_Compiler.c,64 :: 		void fanControl() {
;COCIMIC_FP_Compiler.c,65 :: 		if (tempValue > 30) {
	MOVF       _tempValue+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__fanControl14
	MOVF       _tempValue+0, 0
	SUBLW      30
L__fanControl14:
	BTFSC      STATUS+0, 0
	GOTO       L_fanControl3
;COCIMIC_FP_Compiler.c,66 :: 		PORTB.f1 = 1;
	BSF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,67 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;COCIMIC_FP_Compiler.c,68 :: 		PWM1_Set_Duty(100);
	MOVLW      100
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;COCIMIC_FP_Compiler.c,69 :: 		} else {
	GOTO       L_fanControl4
L_fanControl3:
;COCIMIC_FP_Compiler.c,70 :: 		PORTB.f1 = 0;
	BCF        PORTB+0, 1
;COCIMIC_FP_Compiler.c,71 :: 		PWM1_Stop();
	CALL       _PWM1_Stop+0
;COCIMIC_FP_Compiler.c,72 :: 		}
L_fanControl4:
;COCIMIC_FP_Compiler.c,73 :: 		}
L_end_fanControl:
	RETURN
; end of _fanControl

_dispSpd:

;COCIMIC_FP_Compiler.c,75 :: 		void dispSpd() {
;COCIMIC_FP_Compiler.c,76 :: 		Lcd_Out(2, 1, "Speed: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_COCIMIC_FP_Compiler+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;COCIMIC_FP_Compiler.c,77 :: 		delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_dispSpd5:
	DECFSZ     R13+0, 1
	GOTO       L_dispSpd5
	DECFSZ     R12+0, 1
	GOTO       L_dispSpd5
	NOP
;COCIMIC_FP_Compiler.c,78 :: 		Lcd_Out(2, 8, ltrim(txtSpd));
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
;COCIMIC_FP_Compiler.c,79 :: 		delay_ms(10);
	MOVLW      65
	MOVWF      R12+0
	MOVLW      238
	MOVWF      R13+0
L_dispSpd6:
	DECFSZ     R13+0, 1
	GOTO       L_dispSpd6
	DECFSZ     R12+0, 1
	GOTO       L_dispSpd6
	NOP
;COCIMIC_FP_Compiler.c,80 :: 		}
L_end_dispSpd:
	RETURN
; end of _dispSpd

_main:

;COCIMIC_FP_Compiler.c,82 :: 		void main() {
;COCIMIC_FP_Compiler.c,83 :: 		init();
	CALL       _init+0
;COCIMIC_FP_Compiler.c,85 :: 		while(1) {                         // Endless loop
L_main7:
;COCIMIC_FP_Compiler.c,86 :: 		readTemp();
	CALL       _readTemp+0
;COCIMIC_FP_Compiler.c,88 :: 		dispTemp();
	CALL       _dispTemp+0
;COCIMIC_FP_Compiler.c,90 :: 		fanControl();
	CALL       _fanControl+0
;COCIMIC_FP_Compiler.c,91 :: 		}
	GOTO       L_main7
;COCIMIC_FP_Compiler.c,92 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
