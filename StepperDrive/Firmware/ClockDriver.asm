;====================================================================================================
;
;    Filename:      ClockDriver.asm
;    Date:          12/16/2018
;    File Version:  1.0.2
;    
;    Author:        David M. Flynn
;    Company:       Oxford V.U.E., Inc.
;    E-Mail:        dflynn@oxfordvue.com
;    Web Site:      http://www.oxfordvue.com/
;
;====================================================================================================
;    PICtoEasyDriver is a I2C interface and controller for the EasyDriver stepper driver.
;
;    History:
;
; 1.0.2   12/16/2016	Default setting for PICtoEasyDriver to drive a clock (1.5 RPM)
; 1.0.1   1/10/2016	Copied MS1, MS2, EN*, RST* bits to MotorFlagsX
;	Added Cmd_Enable and Cmd_Reset.
; 1.0     1/3/2016	Added S (MS1/MS1) command. Save min max in EEPROM.
;	Cleaned up some code. Added P2ED_Pn equates. Enabled watchdog timer.
; 1.0a1   12/7/2015	Beginning to work.  Relitive mode only.
; 1.0d1   4/4/2015	First code. 
;
;====================================================================================================
; Options
;
I2C_ADDRESS	EQU	0x3A	; Slave default address
SpdLimitMax	EQU	.95
DefaultMinSpd	EQU	.0	;0..SpdLimitMax-1
DefaultMaxSpd	EQU	.1	;0..SpdLimitMax
DefaultFlags	EQU	b'00000011'	;8th step mode
;
;I/O bits (for connectors, Left to Right)
P2ED_P2	EQU	2
P2ED_P3	EQU	3
P2ED_P8	EQU	1
P2ED_P9	EQU	0
;
;
;================================
; Commands received from the I2C Master
; Cmd Byte plus up to 3 data bytes
Cmd_BeginMove	EQU	'B'	;0x42,Sets InPosition=0
Cmd_Dir	EQU	'D'	;0x44,RevDirection=Data:7
Cmd_Enable	EQU	'E'	;0x45,Enable*=Data:7
Cmd_Reset	EQU	'F'	;0x46,Reset the driver.
Cmd_Home	EQU	'H'	;0x48,CurrentPositionX=0
Cmd_MaxSpd	EQU	'M'	;0x4D,MaxSpeedX
Cmd_MinSpd	EQU	'N'	;0x4E,MinSpeedX
Cmd_GPIO_DDR	EQU	'O'	;0x4F,TRISA:0..3
Cmd_PosAbs	EQU	'P'	;0x50,DestinationX
Cmd_GPIO_Dat	EQU	'Q'	;0x51,LATA:0..3
Cmd_MoveRel	EQU	'R'	;0x52,StepsToGoXLo,StepsToGoXHo
Cmd_StepRez	EQU	'S'	;0x53,Data:0=MS1,Data:1=MS2
Cmd_SetI2CAddr	EQU	'z'	;0x7A,Set I2C Address
;==================================
; Easy_Driver
;  EN*  Enable, Low to power motor
;  RST* Reset, Low to reset
;
; MS1   MS2
;  L     L    Full Step
;  H     L    Half Step
;  L     H    Quarter Step
;  H     H    Eigth Step
;
;====================================================================================================
;====================================================================================================
; What happens next:
;   At power up the system LED will blink.
;
;   Run clocwise at 40 steps per second, 8 Micro-Steps per step, 2400 Steps per second.
;
;====================================================================================================
;
;   Pin 1 (RA2/AN2) P2.2 I/O 2
;   Pin 2 (RA3/AN3) P3.2 I/O 3
;   Pin 3 (RA4/AN4) System LED/Switch (active low input/output)
;   Pin 4 (RA5/MCLR*) Vpp
;   Pin 5 (GND) Ground
;   Pin 6 (RB0) Step Direction (output)
;   Pin 7 (RB1/AN11/SDA1) I2C Data
;   Pin 8 (RB2/AN10/RX) MS2 (Output)
;   Pin 9 (RB3/CCP1) Pulse Output Step
;
;   Pin 10 (RB4/AN8/SLC1) I2C Clock
;   Pin 11 (RB5/AN7)  EN* (Output)
;   Pin 12 (RB6/AN5/CCP2) ICSPCLK
;   Pin 13 (RB7/AN6) ICSPDAT
;   Pin 14 (Vcc) +5 volts
;   Pin 15 (RA6) MS1 (Output)
;   Pin 16 (RA7/CCP2) RST* (Output)
;   Pin 17 (RA0) P9.2 I/O 0
;   Pin 18 (RA1) P8.2 I/O 1
;
;====================================================================================================
;
;
	list	p=16f1847,r=hex,W=1	; list directive to define processor
	nolist
	include	p16f1847.inc	; processor specific variable definitions
	list
;
	__CONFIG _CONFIG1,_FOSC_INTOSC & _WDTE_ON & _MCLRE_OFF & _IESO_OFF
;
;
; INTOSC oscillator: I/O function on CLKIN pin
; WDT enabled
; PWRT disabled
; MCLR/VPP pin function is digital input
; Program memory code protection is disabled
; Data memory code protection is disabled
; Brown-out Reset enabled
; CLKOUT function is disabled. I/O or oscillator function on the CLKOUT pin
; Internal/External Switchover mode is disabled
; Fail-Safe Clock Monitor is enabled
;
	__CONFIG _CONFIG2,_WRT_OFF & _PLLEN_ON & _LVP_OFF
;
; Write protection off
; 4x PLL disabled
; Stack Overflow or Underflow will cause a Reset
; Brown-out Reset Voltage (Vbor), low trip point selected.
; Low-voltage programming enabled
;
; '__CONFIG' directive is used to embed configuration data within .asm file.
; The lables following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.
;
	constant	oldCode=0
	constant	useI2CISR=1
	constant	useI2CWDT=1
	constant	useMotorTest=0
	constant	runTestAtStartup=0
	constant	UseEEParams=1
	constant	IsClockDriver=1	;for Great-Grandfather-Clock
;
#Define	_C	STATUS,C
#Define	_Z	STATUS,Z
;
;====================================================================================================
	nolist
	include	F1847_Macros.inc
	list
;
;
PortADDRBits	EQU	b'00111111'
PortAValue	EQU	b'11000000'
;
#Define	RA0_IO	LATA,0	;Output
#Define	RA1_IO	LATA,1	;Output
#Define	RA2_IO	LATA,2	;Output
#Define	RA3_IO	LATA,3	;Output RA3
#Define	SW1_In	PORTA,4	;SW1/LED1
#Define	RA5_In	PORTA,5	;unused Vpp
#Define	MS1_Out	LATA,6	;MS1 (Output)
#Define	RST_Out	LATA,7	;RST* (Output)
LED1_Bit	EQU	4	;LED1 (Active Low Output)
#Define	LED1_Tris	TRISA,LED1_Bit	;LED1 (Active Low Output)
;
Servo_AddrDataMask	EQU	0xF8
;
;
;    Port B bits
PortBDDRBits	EQU	b'11010010'	;LEDs Out Others In
PortBValue	EQU	b'00000100'
;
#Define	Dir_Bit	LATB,0	;Step Direction
#Define	RB1_In	PORTB,1	;I2C Data
#Define	MS2_Out	LATB,2	;MS2 (Output)
#Define	Step_Bit	LATB,3	;Step Output
#Define	RB4_In	PORTB,4	;I2C Clock
#Define	EN_ED	LATB,5	;EN* (Active Low Output)
#Define	RB6_In	PORTB,6	;ICSPCLK
#Define	RB7_In	PORTB,7	;ICSPDAT
;
Dir_BitMask	EQU	1
Dir_BitIMask	EQU	b'11111110'	;0xFE
Dir_BitLat	EQU	LATB
;
;========================================================================================
;========================================================================================
;
;Constants
All_In	EQU	0xFF
All_Out	EQU	0x00
;
;OSCCON_Value	EQU	b'01110010'	;8MHz
OSCCON_Value	EQU	b'11110000'	;32MHz
;T2CON_Value	EQU	b'01001110'	;T2 On, /16 pre, /10 post
T2CON_Value	EQU	b'01001111'	;T2 On, /64 pre, /10 post
PR2_Value	EQU	.125
;
; 0.5uS res counter from 8MHz OSC
CCP1CON_Run	EQU	b'00001010'	;interupt but don't change the pin
CCP1CON_Clr	EQU	b'00001001'	;Clear output on match
CCP1CON_Set	EQU	b'00001000'	;Set output on match
;T1CON_Val	EQU	b'00000001'	;PreScale=1,Fosc/4,Timer ON
T1CON_Val	EQU	b'00100001'	;PreScale=4,Fosc/4,Timer ON
;
LEDTIME	EQU	d'100'	;1.00 seconds
LEDErrorTime	EQU	d'10'
;
;
;
;================================================================================================
;***** VARIABLE DEFINITIONS
; there are 256 bytes of ram, Bank0 0x20..0x7F, Bank1 0xA0..0xEF, Bank2 0x120..0x16F
; there are 256 bytes of EEPROM starting at 0x00 the EEPROM is not mapped into memory but
;  accessed through the EEADR and EEDATA registers
;================================================================================================
;  Bank0 Ram 020h-06Fh 80 Bytes
;
	cblock	0x20 
;
	LED_Time
	LED_Count
	ISRScratch
;
	EEAddrTemp		;EEProm address to read or write
	EEDataTemp		;Data to be writen to EEProm
;
	Timer1Lo		;1st 16 bit timer
	Timer1Hi		; one second RX timeiout
	Timer2Lo		;2nd 16 bit timer
	Timer2Hi		;
	Timer3Lo		;3rd 16 bit timer
	Timer3Hi		;GP wait timer
	Timer4Lo		;4th 16 bit timer
	Timer4Hi		; Motor testing timer
;
	Flags		; for test software
	SendingIdx
;
; these are saved in eeprom
	I2CAddr
	MinSpd
	MaxSpd
	SysFlags
;
	DestinationX		;P: Position Absolute destination
;
; Stepper Driver Variables, these 9 bytes are sent to the I2C Master
	MotorFlagsX
	MinSpeedX
	MaxSpeedX
	CurSpeedX
	StepsToGoXLo
	StepsToGoXHi
	CurrentPositionX:2
	GPIOBits		;PORTA:0..3, SW1
;	
	endc
;
;MotorFlagsX Bits
InMotion	EQU	0	;Set while motor is moving
InPosition	EQU	1	;Set when move is done, clear to start move
RevDirection	EQU	2	;Clr to got forward, Set to go reverse dir
MS1_Status	EQU	3	;Current Value of MS1
MS2_Status	EQU	4	;Current Value of MS2
EN_Status	EQU	5	;Current Value of EN*
RST_Status	EQU	6	;Current Value of RST*
;
	if useMotorTest
MotorTestTmrL	EQU	Timer4Lo	;4th 16 bit timer
MotorTestTmrH	EQU	Timer4Hi
	endif
;
#Define	StartedIt	Flags,0
#Define	RunMotorTest	Flags,1
#Define	SW1_Flag	Flags,2
;
#Define	MS1_Flag	SysFlags,0
#Define	MS2_Flag	SysFlags,1
;
MS1_FlagBit	EQU	0
MS2_FlagBit	EQU	1
;
#Define	FirstRAMParam	I2CAddr
#Define	LastRAMParam	SysFlags
;
	if useI2CWDT
TimerI2C	EQU	Timer1Lo
	endif
;
;================================================================================================
;  Bank2 Ram 120h-16Fh 80 Bytes
;
; I2C Stuff is here
;Note: only upper 7 bits of address are used
RX_ELEMENTS	EQU	.8	; number of allowable array elements, in this case 16
TX_ELEMENTS	EQU	.10	; MotorFlagsX..CurrentPositionX+1
I2C_TX_Init_Val	EQU	0xAA	; value to load into transmit array to send to master
I2C_RX_Init_Val	EQU	0xAB	; value to load into received data array
;
	cblock	0x120   
	I2C_ARRAY_TX:TX_ELEMENTS	; array to transmit to master
	I2C_ARRAY_RX:RX_ELEMENTS 	; array to receive from master
	endc
;
;
;=======================================================================================================
;  Common Ram 70-7F same for all banks
;      except for ISR_W_Temp these are used for paramiter passing and temp vars
;=======================================================================================================
;
	cblock	0x70
	Param70
	Param71
	Param72
	Param73
	Param74
	Param75
	Param76
	Param77
	Param78
	Param79
	Param7A
	Param7B
	Param7C
	Param7D
	Param7E
	Param7F
	endc
;
#Define	INDEX_I2C	Param70	;I2C Data Pointer
#Define	TX_DataSize	Param71
#Define	GFlags	Param72
#Define	I2C_TXLocked	Param72,0	; Set/cleared by ISR, data is being sent
#Define	I2C_RXLocked	Param72,1	; Set/cleared by ISR, data is being received
#Define	I2C_NewRXData	Param72,2	; Set by ISR, The new data is here!
;
;=========================================================================================
;Conditions
HasISR	EQU	0x80	;used to enable interupts 0x80=true 0x00=false
;
;=========================================================================================
;==============================================================================================
; ID Locations
	__idlocs	0x10A1
;
;==============================================================================================
; EEPROM locations (NV-RAM) 0x00..0x7F (offsets)
	ORG	0xF000
	de	I2C_ADDRESS	;nvI2CAddr
	de	DefaultMinSpd	;nvMinSpd
	de	DefaultMaxSpd	;nvMaxSpd
	de	DefaultFlags	;MS2,MS1
;
	cblock	0x0000
;
	nvI2CAddr
	nvMinSpd
	nvMaxSpd
	nvSysFlags
;
	endc
;
#Define	nvFirstParamByte	nvI2CAddr
#Define	nvLastParamByte	nvSysFlags
;
;
;==============================================================================================
;==============================================================================================
;
;
	ORG	0x000	; processor reset vector
	CLRF	STATUS
	CLRF	PCLATH
  	goto	start	; go to beginning of program
;
;===============================================================================================
; *********************************************************************************************
;===============================================================================================
; Interupt Service Routine
;
; we loop through the interupt service routing every 0.008192 seconds
;
;
	ORG	0x004	; interrupt vector location
	clrf	BSR	; bank0
	clrf	PCLATH
;
;
; Timer 2
	BTFSS	PIR1,TMR2IF
	GOTO	TMR2_End
;Decrement timers until they are zero
; 
;------------------
; These routines run 100 times per second
;------------------
;Decrement timers until they are zero
; 
	CLRF	FSR0H
	call	DecTimer1	;if timer 1 is not zero decrement
	call	DecTimer2
	call	DecTimer3
	call	DecTimer4
;
;-----------------------------------------------------------------
; blink LED
;
	BANKSEL	TRISA
	BSF	LED1_Tris	;Input=LED off
	MOVLB	0
;
; Read SW1
	BCF	SW1_Flag
	BTFSS	SW1_In	;Button pressed?
	BSF	SW1_Flag	; Yes, it's active low
;
	MOVF	PORTA,W
	ANDLW	0x0F
	MOVWF	GPIOBits
	BTFSC	SW1_Flag
	BSF	GPIOBits,4
;
	DECFSZ	LED_Count,F
	GOTO	TMR2_Done
	MOVF	LED_Time,W
	MOVWF	LED_Count
	BANKSEL	TRISA
	BCF	LED1_Tris	;Output=LED on
;
	MOVLB	0
TMR2_Done	BCF	PIR1,TMR2IF
TMR2_End:	
;
;=========================================================================================
; I2C Com
	MOVLB	0x00
	btfsc	PIR1,SSP1IF 	;Is this a SSP interrupt?
	call	I2C_ISR	; Yes
	movlb	0
;-----------------------------------------------------------------------------------------
; I2C Bus Collision
IRQ_5	MOVLB	0x00
	btfss	PIR2,BCL1IF
	goto	IRQ_5_End

	banksel	SSP1BUF						
	movf	SSP1BUF,w	; clear the SSP buffer
	bsf	SSP1CON1,CKP	; release clock stretch
	movlb	0x00
	bcf	PIR2,BCL1IF	; clear the SSP interrupt flag
IRQ_5_End:
;
;--------------------------------------------------------------------
;===========================================
;
	MOVLB	0	;bank 0
	BTFSC	PIR1,CCP1IF	;CCP1 match?
	CALL	ISR_MotorMove
;
	retfie		; return from interrupt
;
;
;==============================================================================================
;==============================================================================================
;
	include	F1847_Common.inc
	include	I2C_SLAVE.inc
;
;==============================================================================================
;
start	MOVLB	0x01	; select bank 1
	bsf	OPTION_REG,NOT_WPUEN	; disable pullups on port B
	bcf	OPTION_REG,TMR0CS	; TMR0 clock Fosc/4
	bcf	OPTION_REG,PSA	; prescaler assigned to TMR0
	bsf	OPTION_REG,PS0	;111 8mhz/4/256=7812.5hz=128uS/Ct=0.032768S/ISR
	bsf	OPTION_REG,PS1	;101 8mhz/4/64=31250hz=32uS/Ct=0.008192S/ISR
	bsf	OPTION_REG,PS2
;
	MOVLB	0x01	; bank 1
	MOVLW	OSCCON_Value
	MOVWF	OSCCON
	movlw	b'00010111'	; WDT prescaler 1:65536 period is 2 sec (RESET value)
	movwf	WDTCON 	
;	
	MOVLB	0x03	; bank 3
	CLRF	ANSELA
	CLRF	ANSELB	;Digital I/O
;
; setup timer 1 for 0.5uS/count
;
	movlb	0	; bank 0
	MOVLW	T1CON_Val
	MOVWF	T1CON
	bcf	T1GCON,TMR1GE	;always count
;Setup T2 for 100/s
	MOVLW	T2CON_Value
	MOVWF	T2CON
	MOVLW	PR2_Value
	MOVWF	PR2
;
; setup data ports
	movlw	PortBValue
	movwf	PORTB	;init port B
	movlw	PortAValue
	movwf	PORTA
	MOVLB	0x01	; bank 1
	movlw	PortADDRBits
	movwf	TRISA
	movlw	PortBDDRBits	;setup for programer
	movwf	TRISB
;
; clear memory to zero
	CALL	ClearRam
;-----------------------
; Setup CCP1
	BANKSEL	CCP1CON	;bank 5
	CLRF	CCP1CON	;reset CCP1
	MOVLW	CCP1CON_Run
	MOVWF	CCP1CON
;Enable Interrupts
	BANKSEL	PIE1	;bank 1
	BSF	PIE1,TMR2IE
	bsf	PIE1,CCP1IE
;
	MOVLB	0x00	;bank 0
	MOVLW	LEDTIME
	MOVWF	LED_Time
;
	CLRWDT
	call	CopyToRam
; init motor variables
	CLRF	MotorFlagsX
	BSF	MotorFlagsX,InPosition	;Don't move
;
	CLRF	CurSpeedX
	CLRF	StepsToGoXLo
	CLRF	StepsToGoXHi
;Set motor speed and step mode from EEPROM data
	MOVF	MaxSpd,W
	MOVWF	MaxSpeedX
	movf	MinSpd,W
	movwf	MinSpeedX
;
	bcf	MotorFlagsX,EN_Status	;Enable drive
	bsf	MotorFlagsX,RST_Status	;Run mode
	call	Set_MS_Bits
;
; test for a bad I2C address
	movf	I2CAddr,W
	btfsc	WREG,0	;LSb most be clr
	MOVLW	I2C_ADDRESS
	movf	WREG,F
	SKPNZ
	MOVLW	I2C_ADDRESS
	movwf	I2CAddr
;
	CLRWDT
	call	Init_I2C	;setup I2C
;
	bsf	INTCON,PEIE	; enable periferal interupts
	bsf	INTCON,GIE	; enable interupts
;
;-----------------------------------------
; Init RAM
;
; init flags (boolean variables) to false
	CLRF	Flags
;
	if runTestAtStartup
; wait 5 seconds before doing anything
	BANKSEL	Timer4Hi
	MOVLW	Low .500
	MOVWF	Timer4Lo
	MOVLW	High .500
	MOVWF	Timer4Hi
	BSF	RunMotorTest
	endif
;
	if IsClockDriver
	BANKSEL	Timer4Hi
	MOVLW	Low .500
	MOVWF	Timer4Lo
	MOVLW	High .500
	MOVWF	Timer4Hi
	BCF	RunMotorTest	
	endif
;
;=========================================================================================
;=========================================================================================
;  Main Loop
;
;=========================================================================================
MainLoop	CLRWDT
;
	CALL	I2C_Idle
	CALL	I2C_DataInturp
;
	CALL	I2C_DataSender
;
;
	movlb	0
	if useMotorTest
	BTFSC	RunMotorTest
	call	MotorTest
	endif
;
	if IsClockDriver
	call	TestT4_Zero
	SKPNZ
	BSF	RunMotorTest
;
	BTFSC	RunMotorTest
	call	RunClock
	endif
;
;Move test
	movlb	0
	btfss	SW1_Flag
	goto	MoveTest_End
	btfss	MotorFlagsX,InPosition
	goto	MoveTest_End
	
	movlw	low .800
	movwf	StepsToGoXLo
	movlw	high .800
	movwf	StepsToGoXHi
	BCF	MotorFlagsX,InPosition	;move it
MoveTest_End:
	
	goto	MainLoop
;
;
;=========================================================================================
;=========================================================================================
; Parse the incoming data and put it where it belongs
; Cmd Byte plus up to 3 data bytes
;
;Cmd_BeginMove	EQU	'B'	;0x42,Sets InPosition=0
;Cmd_Dir	EQU	'D'	;0x44,RevDirection=Data:7
;Cmd_Enable	EQU	'E'	;0x45,Enable*=Data:7
;Cmd_Reset	EQU	'F'	;0x46,Reset the driver.
;Cmd_Home	EQU	'H'	;0x48,CurrentPositionX=0
;Cmd_MaxSpd	EQU	'M'	;0x4D,MaxSpeedX
;Cmd_MinSpd	EQU	'N'	;0x4E,MinSpeedX
;Cmd_GPIO_DDR	EQU	'O'	;0x4F,TRISA:0..3
;Cmd_PosAbs	EQU	'P'	;0x50,DestinationX
;Cmd_GPIO_Dat	EQU	'Q'	;0x51,LATA:0..3
;Cmd_MoveRel	EQU	'R'	;0x52,StepsToGoXLo,StepsToGoXHo
;Cmd_StepRez	EQU	'S'	;0x53,Data:0=MS1,Data:1=MS2
;Cmd_SetI2CAddr	EQU	'z'	;0x7A,Set I2C Address
;
;
I2C_DataInturp	BTFSC	I2C_RXLocked	;Data is locked?
	RETURN		; Yes
	BTFSS	I2C_NewRXData	;Data is new?
	RETURN		; No
	BCF	I2C_NewRXData
;
	movlw	low I2C_ARRAY_RX
	movwf	FSR0L
	movlw	high I2C_ARRAY_RX
	movwf	FSR0H
	moviw	FSR0++
	MOVWF	Param78
;
;Cmd_BeginMove
	movlw	Cmd_BeginMove
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_BM_End
;
	btfss	MotorFlagsX,InPosition	;Already in motion?
	return		; Yes
	movf	StepsToGoXLo,W
	iorwf	StepsToGoXHi,W
	SKPNZ		;Is a move set?
	return		; No
	BCF	MotorFlagsX,InPosition	;move it
	return
I2C_DI_BM_End:
;Cmd_Home
	movlw	Cmd_Home
	subwf	Param78,W
	SKPZ
	bra	Cmd_Home_End
;
	clrf	CurrentPositionX
	clrf	CurrentPositionX+1
	return
Cmd_Home_End:
;Cmd_MoveRel
	movlw	Cmd_MoveRel
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_MoveRel_End
;
	moviw	FSR0++
	movwf	StepsToGoXLo
	moviw	FSR0++
	movwf	StepsToGoXHi
	return
I2C_DI_MoveRel_End:
;Cmd_PosAbs
	movlw	Cmd_PosAbs
	subwf	Param78,W
	SKPZ
	bra	Cmd_PosAbs_End
;
	moviw	FSR0++
	movwf	DestinationX
	moviw	FSR0++
	movwf	DestinationX+1
	movf	CurrentPositionX,W
	subwf	DestinationX,W
	movwf	Param79
	movf	CurrentPositionX+1,W
	subwfb	DestinationX+1,W
	movwf	Param7A
	
	btfss	Param7A,7
	bra	Cmd_PosAbs_PosMov
	bsf	MotorFlagsX,RevDirection
	clrf	StepsToGoXLo
	clrf	StepsToGoXHi
	movf	Param79,W
	subwf	StepsToGoXLo,F
	movf	Param7A,W
	subwfb	StepsToGoXHi,F
	return
;
Cmd_PosAbs_PosMov	bcf	MotorFlagsX,RevDirection
	movf	Param79,W
	movwf	StepsToGoXLo
	movf	Param7A,W
	movwf	StepsToGoXHi
;
	BCF	MotorFlagsX,InPosition	;move it
	return
;
Cmd_PosAbs_End:
;Cmd_Dir	
	movlw	Cmd_Dir
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_Dir_End
;
	BANKSEL	LATA	;bank 2
	movlw	Dir_BitIMask
	andwf	Dir_BitLat,W
	btfsc	INDF0,7
	iorlw	Dir_BitMask
	movwf	Dir_BitLat
	movlb	0	;bank 0
	bcf	MotorFlagsX,RevDirection
	btfsc	INDF0,7
	bsf	MotorFlagsX,RevDirection
	return
I2C_DI_Dir_End:
;Cmd_MaxSpd
	movlw	Cmd_MaxSpd	;MaxSpeedX
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_MaxSpd_End
;
	moviw	FSR0++
	movwf	Param78
	sublw	SpdLimitMax	;SpdLimitMax-W
	SKPNB		;New Min <= SpdLimitMax
	return		; No
	movf	Param78,W
	movwf	MaxSpeedX
	subwf	MaxSpd,W
	SKPNZ		;Changed?
	return		; No
	movf	MaxSpeedX,W
	movwf	MaxSpd
	goto	SaveParams
I2C_DI_MaxSpd_End:
;Cmd_MinSpd
	movlw	Cmd_MinSpd	;MinSpeedX
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_MinSpd_End
;
	moviw	FSR0++
	movwf	Param78
	sublw	SpdLimitMax-1	;SpdLimitMax-1-W
	SKPNB		;New Min < SpdLimitMax
	return		; No
	movf	Param78,W
	movwf	MinSpeedX
	subwf	MinSpd,W
	SKPNZ		;Changed?
	return		; No
	movf	MinSpeedX,W
	movwf	MinSpd
	goto	SaveParams
I2C_DI_MinSpd_End:
;Cmd_GPIO_DDR GPIO data direction
	movlw	Cmd_GPIO_DDR	;TRISA:0..3
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_GPIO_DDR_End
;
	movlb	1	;bank 1
	movlw	0x0F
	iorwf	TRISA,W	;default low buts to inputs
	movwf	Param78
	moviw	FSR0++
	iorlw	0xF0
	andwf	Param78,W
	movwf	TRISA	
	movlb	0	;bank 0
	return
I2C_DI_GPIO_DDR_End:
;Cmd_GPIO_Dat GPIO data
	movlw	Cmd_GPIO_Dat	;LATA:0..3
	subwf	Param78,W
	SKPZ
	bra	I2C_DI_GPIO_Dat_End
;
	movlb	2	;bank 2
	movlw	0x0F	;keep upper nibble
	iorwf	LATA,W	
	movwf	Param78
	moviw	FSR0++
	iorlw	0xF0	;keep lower nibble
	andwf	Param78,W
	movwf	LATA	
	movlb	0	;bank 0
	return
;
I2C_DI_GPIO_Dat_End:
;Cmd_SetI2CAddr I2C Address
	movlw	Cmd_SetI2CAddr
	subwf	Param78,W
	SKPZ
	bra	Cmd_SetI2CAddr_End
;
	moviw	FSR0++
	movwf	Param78
	subwf	I2CAddr,W
	SKPNZ		;Changed?
	return		; No
	movf	Param78,W
	movwf	I2CAddr
	goto	SaveParams	;reboot required to use it.
;
Cmd_SetI2CAddr_End:
;Cmd_Enable 0x45,Enable*=Data:7
	movlw	Cmd_Enable
	subwf	Param78,W
	SKPZ
	bra	Cmd_Enable_End
	moviw	FSR0++
	movwf	Param78
	bcf	MotorFlagsX,EN_Status	;Enabled
	btfss	Param78,7
	bsf	MotorFlagsX,EN_Status	;Disabled
	goto	Set_MS_Bits
Cmd_Enable_End:
;
;Cmd_Reset 0x46,Reset the driver.
	movlw	Cmd_Reset
	subwf	Param78,W
	SKPZ
	bra	Cmd_Reset_End
	bsf	MotorFlagsX,RST_Status
	movlb	2
	bcf	RST_Out
	nop
	nop
	nop
	nop
	bsf	RST_Out
;
	movlb	0
	return
Cmd_Reset_End:
;
;Cmd_StepRez 0x53,Data:0=MS1,Data:1=MS2
	movlw	Cmd_StepRez
	subwf	Param78,W
	SKPZ
	bra	Cmd_StepRez_End
;
	moviw	FSR0++
	movwf	Param78
	subwf	SysFlags,W
	SKPNZ		;Changed?
	return		; No
	movf	Param78,W
	movwf	SysFlags
	call	Set_MS_Bits
	goto	SaveParams
Cmd_StepRez_End:
	RETURN
;
;==============================================================
;
Set_MS_Bits	movlw	low SysFlags
	movwf	FSR1L
	movlw	high SysFlags
	movwf	FSR1H
;
	movlb	2	;bank 2
	btfss	INDF1,MS1_FlagBit
	bcf	MS1_Out
	btfsc	INDF1,MS1_FlagBit
	bsf	MS1_Out	;LATA/B
	btfss	INDF1,MS2_FlagBit
	bcf	MS2_Out
	btfsc	INDF1,MS2_FlagBit
	bsf	MS2_Out
;
	movlw	low MotorFlagsX
	movwf	FSR1L
	movlw	high MotorFlagsX
	movwf	FSR1H
;
	btfss	INDF1,EN_Status
	bcf	EN_ED
	btfsc	INDF1,EN_Status
	bsf	EN_ED
;
	btfss	INDF1,RST_Status
	bcf	RST_Out
	btfsc	INDF1,RST_Status
	bsf	RST_Out	
;
	movlb	0	;bank 0
; copy to MotorFlagsX
	bcf	MotorFlagsX,MS1_Status
	btfsc	SysFlags,MS1_FlagBit
	bsf	MotorFlagsX,MS1_Status
	bcf	MotorFlagsX,MS2_Status
	btfsc	SysFlags,MS2_FlagBit
	bsf	MotorFlagsX,MS2_Status
;
	return
;==============================================================
;
; Send all stepper data to master (9 bytes)
;
I2C_DataSender	movlb	0	; bank 0
	BTFSC	I2C_TXLocked	;Locked?
	RETURN		; Yes
;
	movlw	low I2C_ARRAY_TX
	movwf	FSR0L
	movlw	high I2C_ARRAY_TX
	movwf	FSR0H
;
	movlw	low MotorFlagsX
	movwf	FSR1L
	movlw	high MotorFlagsX
	movwf	FSR1H
;
	movlw	0x09
	movwf	Param78
I2C_DataSender_L1	moviw	FSR1++
	movwi	FSR0++
	decfsz	Param78,F
	goto	I2C_DataSender_L1
;
	RETURN
;
;=========================================================================================
;=========================================================================================
;
;
;
;
	include	StepperLib.inc
;
	END
;
