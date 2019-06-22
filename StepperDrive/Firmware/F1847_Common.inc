;=========================================================================================
; Commonly used routines PIC16F1847 version
;
;    Filename:      F1847 Common.inc
;    Date:          1/3/2016
;    File Version:  1.0.2
;
;    Author:        David M. Flynn
;    Company:       Oxford V.U.E., Inc.
;    E-Mail:        dflynn@oxfordvue.com
;    Web Site:      http://www.oxfordvue.com/
;
;=========================================================================================
;    History:
;
; 1.0.2 1/3/2016	Fixed read and write data EEPROM.
; 1.0.1 11/21/2015	Updates DecTimer.
; 1.0   11/16/2013	Updated from F648A Common.inc
;
;=========================================================================================
; Routines:
;
; ClearRam	(2+0) Clears all RAM, call once before initializing variables, FSR0
; CopyToRam	(1+0) copy param memory (EEPROM) to ram, call once, FSR0
; SaveParams	(1+0) copy ram to param memory (EEPROM), FSR0
;
;  Set FSR0H before calling these routines
; DecTimer4	(0+0) Decrement routine for 16 bit timers, FSR0
; DecTimer3
; DecTimer2
; DecTimer1
; DecTimer	(0+0) High byte of counter address in W
;
; TestT4_Zero	Test for 16 bit timers = zero
; TestT3_Zero	If Timer is zero return Z flag,1 else Z=0
; TestT2_Zero
; TestT1_Zero
;
; Delay10uS	(0+0)Delay uS    1 cycle = 1uS, 8Mhz clock version
; Delay100uS
; Delay40uS
; DelayWuS
;
; EEReadW	(0+0) Read EEPROM address in W
; EERead	(0+0) Read EEPROM address in EEAddrTemp
; EEWriteW	(0+0) Write EEPROM address in W, Data in EEDataTemp
; EEWrite	(0+0) Write EEPROM address in EEAdrTemp, Data in EEDataTemp, FSR0
;
;=========================================================================================
	ifndef UseEEParams
	constant UseEEParams=0
	endif
;=========================================================================================
; Clears all RAM
; Entry: none
; Exit: none
; RAM used: All
; Calls:(2+0) ClearRam_L2
;
ClearRam	MOVLB	0x00
	MOVLW	0x5F	;Clear 20h-7Eh, 95 bytes
	MOVWF	Param7F
	MOVLW	0x20
	MOVWF	FSR0
	CLRF	FSR0H
	CALL	ClearRam_L2
;
	MOVLW	0x50	;Clear A0h-EFh, 80 bytes
	MOVWF	Param7F
	MOVLW	0xA0
	MOVWF	FSR0
	CALL	ClearRam_L2
;
	INCF	FSR0H,F	
	CALL	ClearRam_2	;Banks 2,3
	INCF	FSR0H,F	
	CALL	ClearRam_2	;Banks 4,5
	INCF	FSR0H,F	;Banks 6,7
;	
ClearRam_2	MOVLW	0x50	;Clear 120h-16Fh, 80 bytes
	MOVWF	Param7F
	MOVLW	0x20
	MOVWF	FSR0
	CALL	ClearRam_L2
;
	MOVLW	0x50	;Clear A0h-EFh, 80 bytes
	MOVWF	Param7F
	MOVLW	0xA0
	MOVWF	FSR0
;
ClearRam_L2	CLRF	INDF0
	INCF	FSR0,F
	DECFSZ	Param7F,F
	GOTO	ClearRam_L2
	RETURN
;
	if UseEEParams
;==========================================================================
; copy param memory to ram
;
CopyToRam	MOVLW	nvFirstParamByte
	MOVWF	EEAddrTemp
	MOVLW	FirstRAMParam
	MOVWF	FSR0
	CLRF	FSR0H
CopyToRam_L1	CALL	EERead
	MOVWF	INDF0
	MOVLW	LastRAMParam
	SUBWF	FSR0,W
	SKPNZ
	RETURN
	INCF	FSR0,F
	INCF	EEAddrTemp,F
	BRA	CopyToRam_L1
;
;===========================================================================
; copy ram to param memory
;
SaveParams	movlb	0	;bank 0
	MOVLW	nvFirstParamByte
	MOVWF	EEAddrTemp
	MOVLW	low FirstRAMParam
	MOVWF	FSR0L
	MOVLW	high FirstRAMParam
	movwf	FSR0H
SaveParams_L1	movf	INDF0,W
	MOVWF	EEDataTemp
	CALL	EEWrite
	MOVLW	LastRAMParam	;last byte
	SUBWF	FSR0L,W
	SKPNZ
	RETURN
	INCF	FSR0L,F
	INCF	EEAddrTemp,F
	BRA	SaveParams_L1
;
	endif
;=====================================================================================================
;=========================================================================================================
; Decrement routine for 16 bit timers
; Set FSR0H before calling these routines.
;
DecTimer4	movlw	Timer4Hi
	bra	DecTimer
DecTimer3	movlw	Timer3Hi
	bra	DecTimer
DecTimer2	movlw	Timer2Hi
	bra	DecTimer
DecTimer1	movlw	Timer1Hi
;DecTimer
; entry: FSR=Timer(n)Hi
DecTimer	MOVWF	FSR0L
	MOVIW	FSR0--	;TimerNHi
	IORWF	INDF0,W	;TimerNLo
	SKPNZ
	RETURN
	MOVLW	0x01
	SUBWF	INDF0,F	;TimerNLo
	INCF	FSR0L,F
	CLRW
	SUBWFB	INDF0,F	;TimerNHi
	RETURN
;
;==============================================================================================
; Test for 16 bit timers = zero
;If Timer is zero return Z flag,1 else Z=0
;
TestT4_Zero	movf	Timer4Lo,W
	iorwf	Timer4Hi,W
	return
;
TestT3_Zero	movf	Timer3Lo,W
	iorwf	Timer3Hi,W
	return
;
TestT2_Zero	movf	Timer2Lo,W
	iorwf	Timer2Hi,W
	return
;
TestT1_Zero	movf	Timer1Lo,W
	iorwf	Timer1Hi,W
	return	
;
;======================================================================================
;Delay uS    1 cycle = 1uS, 8Mhz clock version
; RAM used: Param77
; Calls:(0) none
;
Delay10uS	MOVLW	0x05	;(2*3+5)/2=10
	bra	DelayWuS
Delay100uS	MOVLW	d'65'	;(28*3+5)/2=100
	bra	DelayWuS
Delay40uS	MOVLW	d'25'	;(11*3+5)=40
DelayWuS	MOVWF	Param77
DelayWuS_Loop	DECFSZ	Param77,F
	bra	DelayWuS_Loop
	RETURN
;
;==============================================================================================
; Read EEPROM
; entry: EEPROM address to read in W
;        Bank 0 selected
; exit: W=EEDATA, Bank 0 selected
;
EEReadW	movwf	EEAddrTemp
;
;==============================================================================================
; Read EEPROM
; entry: EEPROM address to read in EEAddrTemp
;        Bank 0 selected
; exit: W=EEDATA, Bank 0 selected
;
EERead	movf	EEAddrTemp,W
	MOVLB	3	;Bank 3
	movwf	EEADRL	;Address to read
	bcf	EECON1,CFGS
	bcf	EECON1,EEPGD
	bsf	EECON1,RD
	movf	EEDATL,W	;W=EEDAT
	MOVLB	0x00	;Bank 0
	return
;
;==============================================================================================
; Write EEPROM
; entry: EEPROM address to write in W
;        EEPROM data to write in EEDataTemp
;        Bank 0 selected
; exit: Bank 0 selected
;
EEWriteW	movwf	EEAddrTemp
;
;==============================================================================================
; Write EEPROM
; entry: EEPROM address to write in EEAdrTemp
;        EEPROM data to write in EEDataTemp
;        Bank 0 selected
; exit: Bank 0 selected
;
EEWrite	MOVF	EEAddrTemp,W
	MOVLB	0x03	;Bank 3
	movwf	EEADRL	;Address to write
	movlb	0	;bank 0
	movf	EEDataTemp,W
	MOVLB	3	;Bank 3
	movwf	EEDATL
	bcf	EECON1,CFGS
	bcf	EECON1,EEPGD
	bsf	EECON1,WREN
EEWrite_L1	bcf	INTCON,GIE	;Disale Ints
	btfsc	INTCON,GIE
	bra	EEWrite_L1
;begin required sequence
	movlw	0x55
	movwf	EECON2	;write 55
	movlw	0xAA
	movwf	EECON2	;write AA
	bsf	EECON1,WR	;Begin Write
;end required sequence
	bsf	INTCON,GIE
EEWrite_L2	btfsc	EECON1,WR	
	bra	EEWrite_L2
	bcf	EECON1,WREN	
	MOVLB	0x00	;Bank 0
	return
;
;	
;=========================================================================================
;=========================================================================================
;
;
;
