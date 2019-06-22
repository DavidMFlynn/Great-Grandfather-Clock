;-----------------------------------------------------------------------------------------
; Stepper Driver Library
; File: StepperLib.inc
;    Date:          11/19/2015
;    File Version:  1.0d1
;    
; Written for PIC_Class by David M. Flynn
; dflynn.oxfordvue@gmail.com
; http://Github.com/DavidMFlynn
;=========================================================================================
;    History:
;
; 1.0d1   11/16/2013	First Rev'd version.  PIC16F1847 version.
;	Moved routines from main program.
;
;=========================================================================================
; Routines:
;
; ISR_MotorMove	Interupt service routine, Call if CCP1IF is set
; MotorTest	Optional motor test, useMotorTest
; GetStepTimeLo	Speed table low byte, W=Index >> W=Value
; GetStepTimeHi	Speed table high byte, W=Index >> W=Value
;
	ifndef useMotorTest
	constant	useMotorTest=0
	endif
;-----------------------------------------------------------------------------------------
; Variables: Put a beginning of main program
;
; Speed control constants
;
kMaxSpeed	EQU	.1	;a102 = 209 in/min
kUseDSTable	EQU	0
kUseVSTable	EQU	0	;starts at 5.4 in/min
kUseTable2	EQU	0	;2000 steps / inch
kUseTable5	EQU	0	;5000 steps / inch
;
; Stepper Driver Variables, somewhere in RAM
;	cblock
;
;	MotorFlagsX
;	MaxSpeedX		;0..kMaxSpeed
;	CurSpeedX
;	StepsToGoXLo
;	StepsToGoXHi
;	CurrentPositionX:2
;
;	endc
;MotorFlags Bits
;InMotion	EQU	0	;Set while motor is moving
;InPosition	EQU	1	;Set when move is done, clear to start move
;RevDirection	EQU	2	;Clr to got forward, Set to go reverse dir
;
;-----------------------------------------------------------------------------------------
; Interupt service routine
;  Call if CCP1IF is set
;
ISR_MotorMove	BTFSS	MotorFlagsX,InMotion	;Did we just move?
	GOTO	ISR_MM_NoMove	; No
	MOVLW	0x01
	BTFSS	MotorFlagsX,RevDirection	;Moving Reverse?
	GOTO	ISR_MM_Fwd	; No
; Decrement the position	
	SUBWF	CurrentPositionX,F	; Yes, Dec pos
	CLRW
	SUBWFB	CurrentPositionX+1,F
	GOTO	ISR_MM_StepsToGo
; Increment the position
ISR_MM_Fwd	ADDWF	CurrentPositionX,F
	CLRW
	ADDWFC	CurrentPositionX+1,F
;
ISR_MM_StepsToGo:
; Decrement step counter
	MOVLW	StepsToGoXHi
	CLRF	FSR0H
	CALL	DecTimer
	MOVF	StepsToGoXHi,W
	IORWF	StepsToGoXLo,W
	SKPNZ		;Was that the last step?
	BSF	MotorFlagsX,InPosition	; Yes, move done
;
;	
ISR_MM_NoMove:
	BANKSEL	CCP1CON
	CLRF	CCP1CON	;reset the CCP
;
	BANKSEL	LATA
	BCF	Step_Bit	;output off
;
	BANKSEL	CCP1CON
; set the time for the next step
	MOVLW	CurSpeedX
	MOVWF	FSR1L
	CLRF	FSR1H
	MOVF	INDF1,W
	CALL	GetStepTimeHi
	MOVWF	ISRScratch
	MOVF	INDF1,W
	CALL	GetStepTimeLo
	ADDWF	CCPR1L,F
	MOVF	ISRScratch,W
	ADDWFC	CCPR1H,F
;
;If InPosition then Idle else Pulse next cylcle
	MOVLW	low MotorFlagsX
	MOVWF	FSR1L
	BTFSC	INDF1,InPosition	;InPosition?
	GOTO	ISR_MotorMove_1	; Yes
	MOVLW	CCP1CON_Set	; No, we are moving
	BSF	INDF1,InMotion	;This cycle will output a pulse
	GOTO	ISR_MotorMove_2
;
ISR_MotorMove_1	MOVLW	CCP1CON_Run	;Idle the CCP w/o pulses
	BCF	INDF1,InMotion	;Not moving
ISR_MotorMove_2	MOVWF	CCP1CON
;
;	
	BANKSEL	MotorFlagsX		
	BTFSS	MotorFlagsX,InMotion	;Moving?
	GOTO	ISR_MM_GoSlow	; No
; Calculate time of next step
	BTFSC	MotorFlagsX,InPosition	;Last Step
	GOTO	ISR_MM_GoSlow	; Yes, set slowest speed
	MOVF	StepsToGoXHi,F
	SKPZ		;>= 256 steps to go?
	GOTO	ISR_MM_IncSpd
;
; if StepsToGoXLo>(CurSpeedX-MinSpeedX) then ISR_MM_IncSpd else ISR_MM_DecSpd
	MOVF	MinSpeedX,W
	SUBWF	CurSpeedX,W	;W=CurSpeedX-MinSpeedX
	MOVWF	ISRScratch
	MOVF	StepsToGoXLo,W
	SUBWF	CurSpeedX,W	;W=CurSpeedX-StepsToGoXLo
	BTFSS	STATUS,C	;StepsToGoXLo>=CurSpeedX?
	GOTO	ISR_MM_IncSpd	; Yes
;
ISR_MM_DecSpd	MOVF	CurSpeedX,W
	SUBWF	MinSpeedX,W
	SKPZ		;At slowest?
	DECF	CurSpeedX,F	; No, go slower
	GOTO	ISR_MotorMove_3	
;	
ISR_MM_IncSpd	MOVF	MaxSpeedX,W
	SUBWF	CurSpeedX,W
	SKPZ		;MaxSpeedX=CurSpeedX?
	INCF	CurSpeedX,F	; No, CurSpeedX++
	GOTO	ISR_MotorMove_3
;
ISR_MM_GoSlow	MOVF	MinSpeedX,W
	MOVWF	CurSpeedX
;	
ISR_MotorMove_3	BCF	PIR1,CCP1IF
	return
;
	if IsClockDriver
RunClock	movlb	0	;Bank 0
	btfss	MotorFlagsX,InPosition
	return
	movlw	0xFF
	movwf	StepsToGoXLo
	movwf	StepsToGoXHi
	BCF	MotorFlagsX,InPosition	;move it
;
	return
	endif
;
	if useMotorTest
;=========================================================================================
; Motor test
;
MotorTest:
	BANKSEL	MotorTestTmrH
	MOVF	MotorTestTmrH,W
	IORWF	MotorTestTmrL,W
	SKPZ
	GOTO	NOTZERO
;
	BTFSC	StartedIt
	GOTO	AlreadyDid
	BSF	StartedIt
;
; Start a 1 inch (2000 steps) move max speed = a46 (87.8 in/min)
;	MOVLW	.95	;195.4 in/min good
;	MOVLW	.102	;a102 209.8 in/min
	MOVLW	.95
	MOVWF	MaxSpeedX
DoItAgain	MOVLW	Low .6000
	MOVWF	StepsToGoXLo
	MOVLW	High .6000
	MOVWF	StepsToGoXHi
	BCF	MotorFlagsX,InPosition	;move it
;
AlreadyDid:
	BTFSS	MotorFlagsX,InPosition	;there yet?
	GOTO	NotYet
	BANKSEL	LATA
	MOVLW	Dir_BitMask
	XORWF	Dir_BitLat,F
	MOVLW	MotorFlagsX
	MOVWF	FSR0L
	CLRF	FSR0H
	BCF	INDF0,RevDirection
	BTFSC	Dir_Bit
	BSF	INDF0,RevDirection
;
	MOVLB	0x00
	BCF	StartedIt
	MOVLW	.200
	MOVWF	MotorTestTmrL
;
NotYet:
NOTZERO:
	return
	endif
;
	if IsClockDriver
GetStepTimeLo:
	BRW
	RETLW	Low .50000
	RETLW	Low .50000
;
GetStepTimeHi:
	BRW
	RETLW	High .50000
	RETLW	High .50000
	endif
;
	if kUseTable2
;=========================================================================================
; Speed tables for 2000 steps per inch at 0.5uS resolution, max kMaxSpeed=.125
; from 1 inch per minute (dead slow) accelerating 1.1x per step
; table "a" from 5.4 in/min (very slow) accelerating 1.1x per step
; table "b" from 29.1 in/min (slow) accelerating 1.05x per step
;
	ORG	0x0700	;put up in top of memory
;
; Entry: W = speed table offset 0..kMaxSpeed
GetStepTimeLo:
	MOVLP	High GetStepTimeLo
	ADDWF	PCL,F
	if kUseDSTable
	RETLW	Low .60000	;1 in/min = 24000c/step
	RETLW	Low .54000
	RETLW	Low .48600
	RETLW	Low .43740
	RETLW	Low .39366
	RETLW	Low .35429
	RETLW	Low .31886
	RETLW	Low .28697
	RETLW	Low .25828
	RETLW	Low .23245
	RETLW	Low .20921
	RETLW	Low .18829
	RETLW	Low .16935
	RETLW	Low .15251
	RETLW	Low .13726
	RETLW	Low .12353	;15 4.86 in/min
	endif
	if kUseVSTable
	RETLW	Low .11118	;16/a0 5.4 in/min
	RETLW	Low .10006
	RETLW	Low .9006
	RETLW	Low .8105
	RETLW	Low .7295
	RETLW	Low .6565
	RETLW	Low .5908
	RETLW	Low .5318
	RETLW	Low .4785
	RETLW	Low .4307
	RETLW	Low .3877
	RETLW	Low .3489
	RETLW	Low .3140
	RETLW	Low .2826
	RETLW	Low .2543
	RETLW	Low .2289	;31/a15 26.21 in/min
	endif
	RETLW	Low .2060	;32/a16/b0 29.13 in/min 0.95x
	RETLW	Low .1957
	RETLW	Low .1859
	RETLW	Low .1766
	RETLW	Low .1678
	RETLW	Low .1594
	RETLW	Low .1514
	RETLW	Low .1439
	RETLW	Low .1367
	RETLW	Low .1298
	RETLW	Low .1233
	RETLW	Low .1172
	RETLW	Low .1113
	RETLW	Low .1057
	RETLW	Low .1005
	RETLW	Low .954	;47/a31/b15 62.9 in/min
	RETLW	Low .906	;48/a32/b16 66.2 in/min 0.98x
	RETLW	Low .888
	RETLW	Low .870
	RETLW	Low .853
	RETLW	Low .836
	RETLW	Low .819
	RETLW	Low .803
	RETLW	Low .787
	RETLW	Low .771
	RETLW	Low .755
	RETLW	Low .740	;58
	RETLW	Low .725
	RETLW	Low .711
	RETLW	Low .697
	RETLW	Low .683	;62/a46/b30 87.8 in/min
	RETLW	Low .669	;63/a47/b31 89.7 in/min
	RETLW	Low .662	;64/a48/b32 x.98
	RETLW	Low .656
	RETLW	Low .643
	RETLW	Low .630
	RETLW	Low .617
	RETLW	Low .605
	RETLW	Low .593
	RETLW	Low .581	;71/a55/b39 103.3 in/min
	RETLW	Low .569
	RETLW	Low .558
	RETLW	Low .547
	RETLW	Low .536
	RETLW	Low .525
	RETLW	Low .515
	RETLW	Low .505
	RETLW	Low .495	;79/a63/b47 121.2 in/min
	RETLW	Low .485	;80/a64/b48 123.7 in/min
	RETLW	Low .478	;x.985
	RETLW	Low .471
	RETLW	Low .464
	RETLW	Low .457
	RETLW	Low .450
	RETLW	Low .443
	RETLW	Low .436	;87/a71 
	RETLW	Low .429
	RETLW	Low .423
	RETLW	Low .417	;90/a74 
	RETLW	Low .411
	RETLW	Low .405	;92/a76 
	RETLW	Low .399	; 
	RETLW	Low .393
	RETLW	Low .387	;95/a79/b63 155 in/min
	RETLW	Low .381	;96/a80/b64 157.5 in/min
	RETLW	Low .375
	RETLW	Low .369
	RETLW	Low .363
	RETLW	Low .358	;100/a84/b68
	RETLW	Low .353
	RETLW	Low .348	;102/a86/b70
	RETLW	Low .343	;103/a87/b71 174.9 in/min
	RETLW	Low .338
	RETLW	Low .333
	RETLW	Low .328
	RETLW	Low .323	;185.7 in/min
	RETLW	Low .320	;x.99
	RETLW	Low .317
	RETLW	Low .314	;110
	RETLW	Low .311	;111
	RETLW	Low .307	;112/a95/b80 195.4 in/min
	RETLW	Low .304
	RETLW	Low .301
	RETLW	Low .298
	RETLW	Low .295
	RETLW	Low .292
	RETLW	Low .289
	RETLW	Low .286	;118/a102/b86 209.8 in/min
	RETLW	Low .283
	RETLW	Low .280
	RETLW	Low .277
	RETLW	Low .274
	RETLW	Low .271
	RETLW	Low .268	;125/a109/b93
;bad data
	if kUseDSTable==0
	RETLW	Low .265	;a110/b94 226.4 in/min
	RETLW	Low .262	
	RETLW	Low .259	
	RETLW	Low .256	
	RETLW	Low .253
	RETLW	Low .250
	RETLW	Low .248	;a116/b100
	RETLW	Low .246	
	RETLW	Low .244
	RETLW	Low .242
	RETLW	Low .240
	RETLW	Low .238
	RETLW	Low .236
	RETLW	Low .234
	RETLW	Low .232
	RETLW	Low .230	;a125/b109
	if kUseVSTable==0
	RETLW	Low .228	;b110 263.2 in/min end of VS table
	RETLW	Low .226	
	RETLW	Low .224
	RETLW	Low .222	;b113
	RETLW	Low .220	
	RETLW	Low .218
	RETLW	Low .216
	RETLW	Low .214
	RETLW	Low .212
	RETLW	Low .210
	RETLW	Low .208
	RETLW	Low .206
	RETLW	Low .204
	RETLW	Low .202
	RETLW	Low .200
	RETLW	Low .198	;b125 303 in/min end of HS table
	endif		; if kUseVSTable==0
	endif		; if kUseDSTable==0
	ORG	0x0780	;put up in top of memory
; Entry: W = speed table offset 0..kMaxSpeed
GetStepTimeHi:
	MOVLP	High GetStepTimeHi
	ADDWF	PCL,F
	if kUseDSTable
	RETLW	High .60000	;1 in/min = 24000c/step
	RETLW	High .54000
	RETLW	High .48600
	RETLW	High .43740
	RETLW	High .39366
	RETLW	High .35429
	RETLW	High .31886
	RETLW	High .28697
	RETLW	High .25828
	RETLW	High .23245
	RETLW	High .20921
	RETLW	High .18829
	RETLW	High .16935
	RETLW	High .15251
	RETLW	High .13726
	RETLW	High .12353	;15 4.86 in/min
	endif
	if kUseVSTable
	RETLW	High .11118	;16/a0 5.4 in/min
	RETLW	High .10006
	RETLW	High .9006
	RETLW	High .8105
	RETLW	High .7295
	RETLW	High .6565
	RETLW	High .5908
	RETLW	High .5318
	RETLW	High .4785
	RETLW	High .4307
	RETLW	High .3877
	RETLW	High .3489
	RETLW	High .3140
	RETLW	High .2826
	RETLW	High .2543
	RETLW	High .2289	;31/a15 26.21 in/min
	endif
	RETLW	High .2060	;32/a16/b0 29.13 in/min 0.95x
	RETLW	High .1957
	RETLW	High .1859
	RETLW	High .1766
	RETLW	High .1678
	RETLW	High .1594
	RETLW	High .1514
	RETLW	High .1439
	RETLW	High .1367
	RETLW	High .1298
	RETLW	High .1233
	RETLW	High .1172
	RETLW	High .1113
	RETLW	High .1057
	RETLW	High .1005
	RETLW	High .954	;47/a31/b15 62.9 in/min
	RETLW	High .906	;48/a32/b16 66.2 in/min 0.98x
	RETLW	High .888
	RETLW	High .870
	RETLW	High .853
	RETLW	High .836
	RETLW	High .819
	RETLW	High .803
	RETLW	High .787
	RETLW	High .771
	RETLW	High .755
	RETLW	High .740	;58
	RETLW	High .725
	RETLW	High .711
	RETLW	High .697
	RETLW	High .683	;62/a46/b30 87.8 in/min
	RETLW	High .669	;63/a47/b31 89.7 in/min
	RETLW	High .662	;64/a48/b32 x.98
	RETLW	High .656
	RETLW	High .643
	RETLW	High .630
	RETLW	High .617
	RETLW	High .605
	RETLW	High .593
	RETLW	High .581	;71/a55/b39 103.3 in/min
	RETLW	High .569
	RETLW	High .558
	RETLW	High .547
	RETLW	High .536
	RETLW	High .525
	RETLW	High .515
	RETLW	High .505
	RETLW	High .495	;79/a63/b47 121.2 in/min
	RETLW	High .485	;80/a64/b48 123.7 in/min
	RETLW	High .478	;x.985
	RETLW	High .471
	RETLW	High .464
	RETLW	High .457
	RETLW	High .450
	RETLW	High .443
	RETLW	High .436	;87/a71 
	RETLW	High .429
	RETLW	High .423
	RETLW	High .417	;90/a74 
	RETLW	High .411
	RETLW	High .405	;92/a76 
	RETLW	High .399	; 
	RETLW	High .393
	RETLW	High .387	;95/a79/b63 155 in/min
	RETLW	High .381	;96/a80/b64 157.5 in/min
	RETLW	High .375
	RETLW	High .369
	RETLW	High .363
	RETLW	High .358	;100/a84/b68
	RETLW	High .353
	RETLW	High .348	;102/a86/b70
	RETLW	High .343	;103/a87/b71
	RETLW	High .338
	RETLW	High .333
	RETLW	High .328
	RETLW	High .323	;185.7 in/min
	RETLW	High .320	;x.99
	RETLW	High .317
	RETLW	High .314
	RETLW	High .311
	RETLW	High .307	;112/a95/b79 195.4 in/min
	RETLW	High .304
	RETLW	High .301
	RETLW	High .298
	RETLW	High .295
	RETLW	High .292
	RETLW	High .289
	RETLW	High .286
	RETLW	High .283
	RETLW	High .280
	RETLW	High .277
	RETLW	High .274
	RETLW	High .271
	RETLW	High .268	;125/a109/b93
	
;bad data
	if kUseDSTable==0
	RETLW	High .265	;a110/b94 226.4 in/min
	RETLW	High .262	
	RETLW	High .259	;a111/b95
	RETLW	High .256	;a112/b96 
	RETLW	High .253
	RETLW	High .250
	RETLW	High .248	;a116/b100
	RETLW	High .246	
	RETLW	High .244
	RETLW	High .242
	RETLW	High .240
	RETLW	High .238
	RETLW	High .236
	RETLW	High .234
	RETLW	High .232
	RETLW	High .230	;a125/b109 
	if kUseVSTable==0
	RETLW	High .228	;b110 263.2 in/min end of VS table
	RETLW	High .226	
	RETLW	High .224
	RETLW	High .222
	RETLW	High .220	;b113
	RETLW	High .218
	RETLW	High .216
	RETLW	High .214
	RETLW	High .212
	RETLW	High .210
	RETLW	High .208
	RETLW	High .206
	RETLW	High .204
	RETLW	High .202
	RETLW	High .200
	RETLW	High .198	;b125 303 in/min end of HS table
	endif		; if kUseVSTable==0
	endif		; if kUseDSTable==0
	endif		;table for 2000 steps/inch
	if kUseTable5
;=========================================================================================
; Speed tables for 5000 steps per inch at 0.5uS resolution
; from 1 inch per minute (dead slow) accelerating 1.1x per step, max kMaxSpeed=58
; table "a" from 5.4 in/min (very slow), max kMaxSpeed=42
; table "b" from 29.1 in/min (slow), max kMaxSpeed=26
;
	ORG	0x0780	;put up in top of memory
;
; Entry: W = speed table offset 0..kMaxSpeed
GetStepTimeLo:
	MOVLP	High GetStepTimeLo
	ADDWF	PCL,F
	if kUseDSTable
	RETLW	Low .24000	;1 in/min = 24000c/step
	RETLW	Low .21600
	RETLW	Low .19440
	RETLW	Low .17496
	RETLW	Low .15746
	RETLW	Low .14172
	RETLW	Low .12755
	RETLW	Low .11479
	RETLW	Low .10331
	RETLW	Low .9298
	RETLW	Low .8368
	RETLW	Low .7531
	RETLW	Low .6778
	RETLW	Low .6100
	RETLW	Low .5490
	RETLW	Low .4941	;15 4.86 in/min
	endif
	if kUseVSTable
	RETLW	Low .4447	;a0 5.4 in/min
	RETLW	Low .4003
	RETLW	Low .3602
	RETLW	Low .3242
	RETLW	Low .2918
	RETLW	Low .2626
	RETLW	Low .2363
	RETLW	Low .2127
	RETLW	Low .1914
	RETLW	Low .1722
	RETLW	Low .1551
	RETLW	Low .1396
	RETLW	Low .1256
	RETLW	Low .1130
	RETLW	Low .1017
	RETLW	Low .916	;31/a15 26.2 in/min
	endif
	RETLW	Low .824	;32/a16/b0 29.1 in/min
	RETLW	Low .742
	RETLW	Low .668
	RETLW	Low .601
	RETLW	Low .541
	RETLW	Low .487	;37/a21/b5 49.3 in/min
	RETLW	Low .438	;38/a22/b6 MAX for 8Mhz
	RETLW	Low .394
	RETLW	Low .355
	RETLW	Low .320	;41/a25/b9 75 in/min
	RETLW	Low .287
	RETLW	Low .259
	RETLW	Low .233
	RETLW	Low .210	;45/a29/b13 114.3 in/min
	RETLW	Low .189
	RETLW	Low .170	;47/a31/b15 141.2 in/min
	RETLW	Low .153
	RETLW	Low .138
	RETLW	Low .124	;50/a34/b18 193.5 in/min
	RETLW	Low .112	;51/a35/b19 214.3 in/min
	RETLW	Low .100	;52/a36/b20 240 in/min
	RETLW	Low .90	;53/a37/b21 266.7 in/min
	RETLW	Low .81	;54/a38/b22 296.3 in/min
	RETLW	Low .73	;55/a39/b23 328.8 in/min
	RETLW	Low .66	;56/a40/b24 363.6 in/min
	RETLW	Low .60	;57/a41/b25 400 in/min
	RETLW	Low .54	;58/a42/b26 444.4 in/min
;
; Entry: W = speed table offset 0..kMaxSpeed
GetStepTimeHi:
	MOVLP	High GetStepTimeHi
	ADDWF	PCL,F
	if kUseDSTable
	RETLW	High .24000	;1 in/min = 24000c/step
	RETLW	High .21600
	RETLW	High .19440
	RETLW	High .17496
	RETLW	High .15746
	RETLW	High .14172
	RETLW	High .12755
	RETLW	High .11479
	RETLW	High .10331
	RETLW	High .9298
	RETLW	High .8368
	RETLW	High .7531
	RETLW	High .6778
	RETLW	High .6100
	RETLW	High .5490
	RETLW	High .4941	;15 4.86 in/min
	endif
	if kUseVSTable
	RETLW	High .4447	;a0 5.4 in/min
	RETLW	High .4003
	RETLW	High .3602
	RETLW	High .3242
	RETLW	High .2918
	RETLW	High .2626
	RETLW	High .2363
	RETLW	High .2127
	RETLW	High .1914
	RETLW	High .1722
	RETLW	High .1551
	RETLW	High .1396
	RETLW	High .1256
	RETLW	High .1130
	RETLW	High .1017
	RETLW	High .916	;31/a15 26.2 in/min
	endif
	RETLW	High .824	;32/a16/b0 29.1 in/min
	RETLW	High .742
	RETLW	High .668
	RETLW	High .601
	RETLW	High .541
	RETLW	High .487	;37/a21/b5 49.3 in/min
	RETLW	High .438
	RETLW	High .394
	RETLW	High .355
	RETLW	High .320	;41/a25/b9 75 in/min
	RETLW	High .287
	RETLW	High .259
	RETLW	High .233
	RETLW	High .210	;45/a29/b13 114.3 in/min
	RETLW	High .189
	RETLW	High .170	;47/a31/b15 141.2 in/min
	RETLW	High .153
	RETLW	High .138
	RETLW	High .124	;50/a34/b18 193.5 in/min
	RETLW	High .112	;51/a35/b19 214.3 in/min
	RETLW	High .100	;52/a36/b20 240 in/min
	RETLW	High .90	;53/a37/b21 266.7 in/min
	RETLW	High .81	;54/a38/b22 296.3 in/min
	RETLW	High .73	;55/a39/b23 328.8 in/min
	RETLW	High .66	;56/a40/b24 363.6 in/min
	RETLW	High .60	;57/a41/b25 400 in/min
	RETLW	High .54	;58/a42/b26 444.4 in/min
	endif
;
; 
; 
;
;
;
;
;