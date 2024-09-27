ORG 0000H ; ORIGIN
LJMP MAIN ; LONG JUMP TO MAIN 
	MOV P2, #0FFH ; SET PORT 2 AS AN INPUT
	SETB P3.2 ; SET PIN 3.2 AS AN INPUT 
	SETB P3.3 ; SET PIN 3.3 AS AN INPUT 
	MOV P0, #0FFH ; SET PORT 0 AS AN INPUT
	MOV P2, #00H ; SET PORT 1 AS AN OUTPUT
	ORG 0030H ; OROGIN OF THE INTERRUPT FOR EMERGENCY
	SETB P1.6 ; RUN THE LED & BUZZER
	ACALL DELAY_5 ; RUN THE BUZZER FOR 5 SECONDS
	CLR P1.0 ; STOP ALL THE MOTORS
	CLR P1.1
	CLR P1.2
	CLR P1.3
	CLR P1.4
	CLR P1.5
	RETI ; RETURN TO THE INTERRUPT
MAIN:
	MOV IE, #10001100B ; ENABLE THE INTERRUPT 
SLOT_SELECT: ; SLOT SELECTION
SLOT1: ; SELECTING SLOT1
	ACALL KEYPAD ; KEYPAD INITIALIZASTION
	CJNE A, #00000001B, SLOT2 ; COMPARE WHETHER OR NOT THE BUTTON IS DESIGNATE FOR SLOT 1. IF NOT, GO CHECK BUTTON YOU SELECTED IS FOR SLOT 2 OR NOT.
	LJMP CLR_SLOT1 ; CHECK TO SEE IF THE SELECTED SLOT OF 1 IS CLEAR IF THE BUTTON IS 1.
SLOT2:
	ACALL KEYPAD
	CJNE A, #00000010B, SLOT3
	LJMP CLR_SLOT2
SLOT3:
	ACALL KEYPAD
	CJNE A, #00000011B, SLOT1
	LJMP CLR_SLOT3
CLR_SLOT1: ; CLEARING THE SELECTION OF SLOT 1
	ACALL KEYPAD
	CJNE A, #00010000B, SLOT1_DWN ; GO TO SLOT SELECTION OR GO TO SLOT 1 TAKING DOWN IF THE CLEAR BUTTON IS Selected.
	LJMP SLOT_SELECT
CLR_SLOT2:
	ACALL KEYPAD
	CJNE A, #00010000B, SLOT2_DWN
	LJMP SLOT_SELECT
CLR_SLOT3:
	ACALL KEYPAD
	CJNE A, #00010000B, GO
GO: 	LJMP SLOT3_DWN
	LJMP SLOT_SELECT
SLOT1_DWN:
	ACALL KEYPAD
BTN_DWN1: CJNE A, #00000100B, BTN_DWN1 ;UNTIL THE SLOT 1 DOWN BUTTON IS PRESED, PERMANENTLY CHECK
	CLR P1.0 ; SET THE DIRECTION TO DOWNWARD
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L0: MOV R1, #200
L1: MOV R2, #230
L2: CLR P1.3
	ACALL DELAY
	SETB P1.3
	ACALL DELAY
	DJNZ R2, L2
	DJNZ R1, L1
	DJNZ R0, L0
	JB P0.0, CH1
	SJMP B1
B1:
	JNB P0.0, $
	ACALL DELAY_60
	SJMP SLOT1_UP
CH1:
	JB P0.0, $
	ACALL KEYPAD
BTN_UP1: CJNE A, #00000110B, BTN_UP1
	SJMP SLOT1_UP
SLOT1_UP:
	SETB P1.0 ; SET THE DIRECTION TO THE UPWARD 
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L0_VM1: MOV R2, #200
L1_VM1: MOV R1, #230
L2_VM1: CLR P1.3 ; ROTATE VM1 IN 50% PWM
	ACALL DELAY
	SETB P1.3
	ACALL DELAY
	DJNZ R1, L2_VM1
	DJNZ R2, L1_VM1
	DJNZ R0, L0_VM1
	LJMP MAIN ; LONG JUMP TO THE MAIN LABLE
SLOT2_DWN:
	ACALL KEYPAD
BTN_DWN2: CJNE A, #00000100B, BTN_DWN2 ;TILL THE SLOT 2 DOWN BUTTON IS PRESED, CHECK CONTINUOUSLY
	JB P0.3, DWN_2 ; VERIFY WHETHER THE SLOT BELOW (SLOT 5) IS OCCUPIED OR NOT.
	SJMP HM1_LFT ; IF THE ADDRESS FOR ROTATE HM1 TO THE LEFT (TO SLOT4) IS OCCUPIED
HM1_LFT:
	CLR P1.0 ; SET THE DIRECTION TO THE LEFTWARD 
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L0_HM1: MOV R2, #200
L1_HM1: MOV R1, #230
L2_HM1: CLR P1.4 ; ROTATE HM1 IN 50% PWM
	ACALL DELAY
	SETB P1.4
	ACALL DELAY
	DJNZ R1, L2_HM1
	DJNZ R2, L1_HM1
	DJNZ R0, L0_HM1
	SJMP DWN_2
DWN_2: CLR P1.0
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L0_VM2: MOV R2, #200
L1_VM2: MOV R1, #230
L2_VM2: CLR P1.1 ; ROTATE VM2 IN 50% PWM
	ACALL DELAY
	SETB P1.1
	ACALL DELAY
	DJNZ R1, L2_VM2
	DJNZ R2, L1_VM2
	DJNZ R0, L0_VM2
	JB P0.1, CH2
	SJMP B2
B2:
	JNB P0.1, $
	ACALL DELAY_60
	SJMP SLOT2_UP
CH2:
	JB P0.1, $
	ACALL KEYPAD
BTN_UP2: CJNE A, #00000110B, BTN_UP2
	SJMP SLOT2_UP
SLOT2_UP:
	SETB P1.0 ; SET THE DIRECTION TO THE UPWARD & RIGHTWARD 
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L12_VM2: MOV R2, #200
L10_VM2: MOV R1, #230
L20_VM2: CLR P1.4 ; ROTATE VM2 IN 50% PWM
	ACALL DELAY
	SETB P1.4
	ACALL DELAY
	DJNZ R1, L20_VM2
	DJNZ R2, L10_VM2
	DJNZ R0, L12_VM2
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L33_HM1: MOV R2, #200
L11_HM1: MOV R1, #230
L22_HM1: CLR P1.1 ; ROTATE HM1 IN 50% PWM
	ACALL DELAY
	SETB P1.1
	ACALL DELAY
	DJNZ R1, L22_HM1
	DJNZ R2, L11_HM1
	DJNZ R0, L33_HM1
	LJMP MAIN ; LONG JUMP TO THE MAIN LABLE
SLOT3_DWN:
	ACALL KEYPAD
BTN_DWN3: CJNE A, #00000100B, BTN_DWN3 ;UNTIL THE SLOT 3 DOWN BUTTON IS PRESED, PERMANENTLY CHECK
	JB P0.3, DWN_2 ; VERIFY WHETHER OR NOT THE SLOT BELOW (SLOT 6) IS OCCUPIED.
	SJMP HM12_LFT ; IF THE ADDRESS FOR ROTATE HM1 & HM2 TO THE LEFT IS OCCUPIED
HM12_LFT:
	CLR P1.0 ; SET THE DIRECTION TO THE LEFWARD 
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L300_HM: MOV R2, #200
L100_HM: MOV R1, #230
L200_HM: CLR P1.1 ; ROTATE HM1 & HM2 IN 50% PWM
	CLR P1.2
	ACALL DELAY
	SETB P1.1
	SETB P1.2
	ACALL DELAY
	DJNZ R1, L200_HM
	DJNZ R2, L100_HM
	DJNZ R0, L300_HM
	SJMP DWN_3
DWN_3:
	CLR P1.0 ; SET THE DIRECTION TO THE DOWNWARD 
	MOV R0, #200 ; SET THE TIME FOR 10 SECONDS
L330_VM3: MOV R2, #200
L110_VM3: MOV R1, #230
L220_VM3: CLR P1.5 ; ROTATE VM3 IN 50% PWM
	ACALL DELAY
	SETB P1.5
	ACALL DELAY
	DJNZ R1, L220_VM3
	DJNZ R2, L110_VM3
	DJNZ R0, L330_VM3
	JB P0.2, CH3
	SJMP B3
B3:
	JNB P0.2, $
	ACALL DELAY_60
	SJMP SLOT3_UP
CH3:
	JB P0.2, $
	ACALL KEYPAD
BTN_UP3: CJNE A, #00000110B, BTN_UP3
	SJMP SLOT3_UP
SLOT3_UP:
	SETB P1.0 ; SET THE DIRECTION TO THE UPWARD & RIGHTWARD 
	MOV R0, #255 ; SET THE TIME FOR 10 SECONDS
L333_VM3: MOV R2, #200
L111_VM3: MOV R1, #240
L222_VM3: CLR P1.5 ; ROTATE VM3 IN 50% PWM
	ACALL DELAY
	SETB P1.5
	ACALL DELAY
	DJNZ R1, L222_VM3
	DJNZ R2, L111_VM3
	DJNZ R0, L333_VM3
	MOV R0, #255 ; SET THE TIME FOR 10 SECONDS
L333_HM: MOV R2, #200
L111_HM: MOV R1, #240
L222_HM: CLR P1.1 ; ROTATE HM1 & HM2 IN 50% PWM
	CLR P1.2
	ACALL DELAY
	SETB P1.1
	SETB P1.2
	ACALL DELAY
	DJNZ R1, L222_HM
	DJNZ R2, L111_HM
	DJNZ R0, L333_HM
	LJMP MAIN ; ADDRESS TO THE MAIN LABLE
KEYPAD: CLR 0A8H
	JB 0B2H, $
	MOV DPTR, #0FFF4H
	MOVX A, @DPTR
	SETB 0A8H
	RET
DELAY: MOV R4, #15
LOOP_6: DJNZ R4, LOOP_6
	RET
DELAY_5:
	MOV R0, #200
LOOP_4: MOV R1, #115
LOOP_5: DJNZ R1, LOOP_5
	DJNZ R0, LOOP_4
	RET
DELAY_60:
	MOV R4, #15
LOOP_2: MOV R5, #4
LOOP_1: MOV R6, #4
LOOP_0: MOV TMOD, #00000001B
	MOV TH0, #00H
	MOV TL0, #00H
	SETB TR0
	JNB TF0, $
	CLR TR0
	CLR TF0
	DJNZ R6, LOOP_0
	DJNZ R5, LOOP_1
	DJNZ R4, LOOP_2
	MOV TMOD, #00000001B
	MOV TH0, #02BH
	MOV TL0, #085H
	SETB TR0
	JNB TF0, $
	CLR TR0
	CLR TF0
	RET
	END