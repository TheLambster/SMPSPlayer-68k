		even
LoadZ80drv:
                nop
                movem.l d0-d7/a0-a6,-(a7)
                move.w	#$100,($A11100).l
                move.w	#$100,($A11200).l
		moveq	#0,d0
		lea	(Z80_Driver).l,a0
		lea	($A00000).l,a1
		move.l	(Z80_Size).l,d0
		sub.w	#1,d0

SoundDriver_Z80:
		move.b	(a0)+,(a1)+
		dbf	d0,SoundDriver_Z80
                move.w	#0,($A11200).l
                move.w	#$100,($A11200).l
                move.w	#0,($A11100).l
                movem.l (a7)+,d0-d7/a0-a6
                rts


PlaySound:                             
                move.b  d0,($FFFFF00A).w
				move.b  d0,$FFFF004F
				
                rts

; ---------------------------------------------------------------------------
; Subroutine to play a special sound/music (E0-E4)
;
; E0 - Fade out
; E1 - Sega
; E2 - Speed up
; E3 - Normal speed
; E4 - Stop
; ---------------------------------------------------------------------------

PlaySound_Special:
                move.b  d0,($FFFFF00B).w
		
                rts

PlaySound_Unk:
                move.b  d0,($FFFFF00C).w
				
                rts

Z80Process:                              
                move.w  #$100,($A11100).l ; stop the Z80
                nop
                nop
                nop

loc_71B5A:                             
                btst    #0,($A11100).l
                bne.s   loc_71B5A
                btst    #7,($A01FFD).l
                beq.s   loc_71B82
                move.w  #0,($A11100).l  ; start the Z80
                nop
                nop
                nop
                nop
                nop
                bra.s   Z80Process
; ---------------------------------------------------------------------------

loc_71B82:                             
                lea     ($FFF000).l,a6
                clr.b   $E(a6)
                tst.b   3(a6)           ; is music paused?
                bne.w   loc_71E50       ; if yes, branch
                subq.b  #1,1(a6)
                bne.s   loc_71B9E
                jsr     sub_7260C(pc)

loc_71B9E:                              
                move.b  4(a6),d0
                beq.s   loc_71BA8
                jsr     sub_72504(pc)

loc_71BA8:                              
                tst.b   $24(a6)
                beq.s   loc_71BB2
                jsr     sub_7267C(pc)

loc_71BB2:                              
                tst.w   $A(a6)          ; is music or sound being played?
                beq.s   loc_71BBC       ; if not, branch
                jsr     Sound_Play(pc)

loc_71BBC:                             
                cmpi.b  #-$80,9(a6)
                beq.s   loc_71BC8
                jsr     Sound_ChkValue(pc)

loc_71BC8:                              
                lea     $40(a6),a5
                tst.b   (a5)
                bpl.s   loc_71BD4
                jsr     sub_71C4E(pc)

loc_71BD4:                             
                clr.b   8(a6)
                moveq   #5,d7

loc_71BDA:                              
                adda.w  #$30,a5
                tst.b   (a5)
                bpl.s   loc_71BE6
                jsr     sub_71CCA(pc)

loc_71BE6:                              
                dbf     d7,loc_71BDA
                moveq   #2,d7

loc_71BEC:                              
                adda.w  #$30,a5
                tst.b   (a5)
                bpl.s   loc_71BF8
                jsr     sub_72850(pc)

loc_71BF8:                             
                dbf     d7,loc_71BEC
                move.b  #-$80,$E(a6)
                moveq   #2,d7

loc_71C04:                            
                adda.w  #$30,a5
                tst.b   (a5)
                bpl.s   loc_71C10
                jsr     sub_71CCA(pc)

loc_71C10:                              
                dbf     d7,loc_71C04
                moveq   #2,d7

loc_71C16:                              
                adda.w  #$30,a5
                tst.b   (a5)
                bpl.s   loc_71C22
                jsr     sub_72850(pc)

loc_71C22:                              
                dbf     d7,loc_71C16
                move.b  #$40,$E(a6)
                adda.w  #$30,a5
                tst.b   (a5)
                bpl.s   loc_71C38
                jsr     sub_71CCA(pc)

loc_71C38:                             
                adda.w  #$30,a5
                tst.b   (a5)
                bpl.s   loc_71C44
                jsr     sub_72850(pc)

loc_71C44:                              
                move.w  #0,($A11100).l  ; start the Z80
                rts
; End of function sub_71B4C


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71C4E:                              
                subq.b  #1,$E(a5)
                bne.s   locret_71CAA
                move.b  #-$80,8(a6)
                movea.l 4(a5),a4

loc_71C5E:                              
                moveq   #0,d5
                move.b  (a4)+,d5
                cmpi.b  #$E0,d5
                bcs.s   loc_71C6E
                jsr     sub_72A5A(pc)
                bra.s   loc_71C5E
; ---------------------------------------------------------------------------

loc_71C6E:                              
                tst.b   d5
                bpl.s   loc_71C84
                move.b  d5,$10(a5)
                move.b  (a4)+,d5
                bpl.s   loc_71C84
                subq.w  #1,a4
                move.b  $F(a5),$E(a5)
                bra.s   loc_71C88
; ---------------------------------------------------------------------------

loc_71C84:                             
                jsr     sub_71D40(pc)

loc_71C88:                             
                move.l  a4,4(a5)
                btst    #2,(a5)
                bne.s   locret_71CAA
                moveq   #0,d0
                move.b  $10(a5),d0
                cmpi.b  #-$80,d0
                beq.s   locret_71CAA
                btst    #3,d0
          ;      bne.s   loc_71CAC
                move.b  d0,($A01FFF).l

locret_71CAA:                         
                rts
; ---------------------------------------------------------------------------

loc_71CAC:                             
    ;            subi.b  #-$78,d0
     ;           move.b  byte_71CC4(pc,d0.w),d0
      ;          move.b  d0,($A000EA).l
       ;         move.b  #-$7D,($A01FFF).l
                rts
; End of function sub_71C4E

; ---------------------------------------------------------------------------
byte_71CC4:     dc.b $12, $15, $1C, $1D, $FF, $FF

; ��������������� S U B R O U T I N E ���������������������������������������


sub_71CCA:                              
                subq.b  #1,$E(a5)
                bne.s   loc_71CE0
                bclr    #4,(a5)
                jsr     sub_71CEC(pc)
                jsr     sub_71E18(pc)
                bra.w   loc_726E2
; ---------------------------------------------------------------------------

loc_71CE0:                              
                jsr     sub_71D9E(pc)
                jsr     sub_71DC6(pc)
                bra.w   loc_71E24
; End of function sub_71CCA


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71CEC:                              
                movea.l 4(a5),a4
                bclr    #1,(a5)

loc_71CF4:                            
                moveq   #0,d5
                move.b  (a4)+,d5
                cmpi.b  #$E0,d5
                bcs.s   loc_71D04
                jsr     sub_72A5A(pc)
                bra.s   loc_71CF4
; ---------------------------------------------------------------------------

loc_71D04:                             
                jsr     sub_726FE(pc)
                tst.b   d5
                bpl.s   loc_71D1A
                jsr     sub_71D22(pc)
                move.b  (a4)+,d5
                bpl.s   loc_71D1A
                subq.w  #1,a4
                bra.w   sub_71D60
; ---------------------------------------------------------------------------

loc_71D1A:                              
                jsr     sub_71D40(pc)
                bra.w   sub_71D60
; End of function sub_71CEC


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71D22:
                subi.b  #-$80,d5
                beq.s   loc_71D58
                add.b   8(a5),d5
                andi.w  #$7F,d5
                lsl.w   #1,d5
                lea     word_72790(pc),a0
                move.w  (a0,d5.w),d6
                move.w  d6,$10(a5)
                rts
; End of function sub_71D22


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71D40:                              ; CODE XREF: sub_71C4E:loc_71C84p ...
                move.b  d5,d0
                move.b  2(a5),d1

loc_71D46:                              ; CODE XREF: sub_71D40+Cj
                subq.b  #1,d1
                beq.s   loc_71D4E
                add.b   d5,d0
                bra.s   loc_71D46
; ---------------------------------------------------------------------------

loc_71D4E:                              ; CODE XREF: sub_71D40+8j
                move.b  d0,$F(a5)
                move.b  d0,$E(a5)
                rts
; End of function sub_71D40

; ---------------------------------------------------------------------------

loc_71D58:                              ; CODE XREF: sub_71D22+4j
                bset    #1,(a5)
                clr.w   $10(a5)

; ��������������� S U B R O U T I N E ���������������������������������������


sub_71D60:                              ; CODE XREF: sub_71CEC+2Aj ...
                move.l  a4,4(a5)
                move.b  $F(a5),$E(a5)
                btst    #4,(a5)
                bne.s   locret_71D9C
                move.b  $13(a5),$12(a5)
                clr.b   $C(a5)
                btst    #3,(a5)
                beq.s   locret_71D9C
                movea.l $14(a5),a0
                move.b  (a0)+,$18(a5)
                move.b  (a0)+,$19(a5)
                move.b  (a0)+,$1A(a5)
                move.b  (a0)+,d0
                lsr.b   #1,d0
                move.b  d0,$1B(a5)
                clr.w   $1C(a5)

locret_71D9C:                           ; CODE XREF: sub_71D60+Ej ...
                rts
; End of function sub_71D60


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71D9E:                              ; CODE XREF: sub_71CCA:loc_71CE0p ...
                tst.b   $12(a5)
                beq.s   locret_71DC4
                subq.b  #1,$12(a5)
                bne.s   locret_71DC4
                bset    #1,(a5)
                tst.b   1(a5)
                bmi.w   loc_71DBE
                jsr     sub_726FE(pc)
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------

loc_71DBE:                              ; CODE XREF: sub_71D9E+14j
                jsr     sub_729A0(pc)
                addq.w  #4,sp

locret_71DC4:                           ; CODE XREF: sub_71D9E+4j ...
                rts
; End of function sub_71D9E


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71DC6:                              ; CODE XREF: sub_71CCA+1Ap ...
                addq.w  #4,sp
                btst    #3,(a5)
                beq.s   locret_71E16
                tst.b   $18(a5)
                beq.s   loc_71DDA
                subq.b  #1,$18(a5)
                rts
; ---------------------------------------------------------------------------

loc_71DDA:                              ; CODE XREF: sub_71DC6+Cj
                subq.b  #1,$19(a5)
                beq.s   loc_71DE2
                rts
; ---------------------------------------------------------------------------

loc_71DE2:                              ; CODE XREF: sub_71DC6+18j
                movea.l $14(a5),a0
                move.b  1(a0),$19(a5)
                tst.b   $1B(a5)
                bne.s   loc_71DFE
                move.b  3(a0),$1B(a5)
                neg.b   $1A(a5)
                rts
; ---------------------------------------------------------------------------

loc_71DFE:                              ; CODE XREF: sub_71DC6+2Aj
                subq.b  #1,$1B(a5)
                move.b  $1A(a5),d6
                ext.w   d6
                add.w   $1C(a5),d6
                move.w  d6,$1C(a5)
                add.w   $10(a5),d6
                subq.w  #4,sp

locret_71E16:                           ; CODE XREF: sub_71DC6+6j
                rts
; End of function sub_71DC6


; ��������������� S U B R O U T I N E ���������������������������������������


sub_71E18:                              ; CODE XREF: sub_71CCA+Ep
                btst    #1,(a5)
                bne.s   locret_71E48
                move.w  $10(a5),d6
                beq.s   loc_71E4A

loc_71E24:                              ; CODE XREF: sub_71CCA+1Ej
                move.b  $1E(a5),d0
                ext.w   d0
                add.w   d0,d6
                btst    #2,(a5)
                bne.s   locret_71E48
                move.w  d6,d1
                lsr.w   #8,d1
                move.b  #$A4,d0
                jsr     sub_72722(pc)
                move.b  d6,d1
                move.b  #$A0,d0
                jsr     sub_72722(pc)

locret_71E48:                           ; CODE XREF: sub_71E18+4j ...
                rts
; ---------------------------------------------------------------------------

loc_71E4A:                              ; CODE XREF: sub_71E18+Aj
                bset    #1,(a5)
                rts
; End of function sub_71E18

; ---------------------------------------------------------------------------

loc_71E50:                              ; CODE XREF: sub_71B4C+44j
                bmi.s   loc_71E94
                cmpi.b  #2,3(a6)
                beq.w   loc_71EFE
                move.b  #2,3(a6)
                moveq   #2,d3
                move.b  #$B4,d0
                moveq   #0,d1

loc_71E6A:                              ; CODE XREF: ROM:00071E74j
                jsr     sub_7272E(pc)
                jsr     sub_72764(pc)
                addq.b  #1,d0
                dbf     d3,loc_71E6A
                moveq   #2,d3
                moveq   #$28,d0

loc_71E7C:                              ; CODE XREF: ROM:00071E88j
                move.b  d3,d1
                jsr     sub_7272E(pc)
                addq.b  #4,d1
                jsr     sub_7272E(pc)
                dbf     d3,loc_71E7C
                jsr     sub_729B6(pc)
                bra.w   loc_71C44
; ---------------------------------------------------------------------------

loc_71E94:                              ; CODE XREF: ROM:loc_71E50j
                clr.b   3(a6)
                moveq   #$30,d3
                lea     $40(a6),a5
                moveq   #6,d4

loc_71EA0:                              ; CODE XREF: ROM:00071EBAj
                btst    #7,(a5)
                beq.s   loc_71EB8
                btst    #2,(a5)
                bne.s   loc_71EB8
                move.b  #$B4,d0
                move.b  $A(a5),d1
                jsr     sub_72722(pc)

loc_71EB8:                              ; CODE XREF: ROM:00071EA4j ...
                adda.w  d3,a5
                dbf     d4,loc_71EA0
                lea     $220(a6),a5
                moveq   #2,d4

loc_71EC4:                              ; CODE XREF: ROM:00071EDEj
                btst    #7,(a5)
                beq.s   loc_71EDC
                btst    #2,(a5)
                bne.s   loc_71EDC
                move.b  #$B4,d0
                move.b  $A(a5),d1
                jsr     sub_72722(pc)

loc_71EDC:                              ; CODE XREF: ROM:00071EC8j ...
                adda.w  d3,a5
                dbf     d4,loc_71EC4
                lea     $340(a6),a5
                btst    #7,(a5)
                beq.s   loc_71EFE
                btst    #2,(a5)
                bne.s   loc_71EFE
                move.b  #$B4,d0
                move.b  $A(a5),d1
                jsr     sub_72722(pc)

loc_71EFE:                              ; CODE XREF: ROM:00071E58j ...
                bra.w   loc_71C44
; ---------------------------------------------------------------------------
; Subroutine to play a sound or music track
; ---------------------------------------------------------------------------

; ��������������� S U B R O U T I N E ���������������������������������������


Sound_Play:                             ; CODE XREF: sub_71B4C+6Cp
                movea.l (Go_SoundTypes).l,a0
                lea     $A(a6),a1       ; load music track number
                move.b  0(a6),d3
                moveq   #2,d4

loc_71F12:                              ; CODE XREF: Sound_Play:loc_71F3Ej
                move.b  (a1),d0         ; move track number to d0
                move.b  d0,d1
                clr.b   (a1)+
                subi.b  #-$7F,d0
                bcs.s   loc_71F3E
                cmpi.b  #-$80,9(a6)
                beq.s   loc_71F2C
                move.b  d1,$A(a6)
                bra.s   loc_71F3E
; ---------------------------------------------------------------------------

loc_71F2C:                              ; CODE XREF: Sound_Play+22j
                andi.w  #$7F,d0
                move.b  (a0,d0.w),d2
                cmp.b   d3,d2
                bcs.s   loc_71F3E
                move.b  d2,d3
                move.b  d1,9(a6)        ; set music flag

loc_71F3E:                              ; CODE XREF: Sound_Play+1Aj ...
                dbf     d4,loc_71F12
                tst.b   d3
                bmi.s   locret_71F4A
                move.b  d3,0(a6)

locret_71F4A:                           ; CODE XREF: Sound_Play+42j
                rts
; End of function Sound_Play


; ��������������� S U B R O U T I N E ���������������������������������������


Sound_ChkValue:                         ; CODE XREF: sub_71B4C+78p
                moveq   #0,d7
                move.b  9(a6),d7
                beq.w   Sound_E4
                bpl.s   locret_71F8C
                move.b  #-$80,9(a6)     ; reset music flag
                cmpi.b  #-$61,d7
                bls.w   Sound_81to9F    ; music $81-$9F
                cmpi.b  #-$60,d7
                bcs.w   locret_71F8C
                cmpi.b  #-$31,d7
                bls.w   Sound_81to9f    ; sound $A0-$CF
                cmpi.b  #-$30,d7
                bcs.w   locret_71F8C
                cmpi.b  #-$20,d7
                bcs.w   Sound_81to9f    ; sound $D0-$DF
                cmpi.b  #$FF,d7
                bls.s   Sound_E0toE4    ; sound $E0-$E4

locret_71F8C:                           ; CODE XREF: Sound_ChkValue+Aj ...
                rts
; ---------------------------------------------------------------------------

Sound_E0toE4:                           ; CODE XREF: Sound_ChkValue+3Ej
                subi.b  #$FB,d7
                lsl.w   #2,d7
                jmp     Sound_ExIndex(pc,d7.w)
; ---------------------------------------------------------------------------

Sound_ExIndex:
                bra.w   Sound_E0
; ---------------------------------------------------------------------------
                bra.w   Sound_E1
; ---------------------------------------------------------------------------
                bra.w   Sound_E2
; ---------------------------------------------------------------------------
                bra.w   Sound_E3
; ---------------------------------------------------------------------------
                bra.w   Sound_E4
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Play "Say-gaa" PCM sound
; ---------------------------------------------------------------------------

Sound_E1:                               ; CODE XREF: Sound_ChkValue+50j
                move.b  #-$78,($A01FFF).l
                move.w  #0,($A11100).l  ; start the Z80
                move.w  #$11,d1

loc_71FC0:                              ; CODE XREF: Sound_ChkValue+7Ej
                move.w  #$FFFF,d0

loc_71FC4:                              ; CODE XREF: Sound_ChkValue+7Aj
                nop
                dbf     d0,loc_71FC4
                dbf     d1,loc_71FC0
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Play music track $81-$9F
; ---------------------------------------------------------------------------

Sound_81to9F:                           ; CODE XREF: Sound_ChkValue+16j
;                cmpi.b  #-$78,d7        ; is "extra life" music played?
;                bne.s   loc_72024       ; if not, branch
		bra.s loc_72024
                tst.b   $27(a6)
                bne.w   loc_721B6
                lea     $40(a6),a5
                moveq   #9,d0

loc_71FE6:                              ; CODE XREF: Sound_ChkValue+A2j
                bclr    #2,(a5)
                adda.w  #$30,a5
                dbf     d0,loc_71FE6
                lea     $220(a6),a5
                moveq   #5,d0

loc_71FF8:                              ; CODE XREF: Sound_ChkValue+B4j
                bclr    #7,(a5)
                adda.w  #$30,a5
                dbf     d0,loc_71FF8
                clr.b   0(a6)
                movea.l a6,a0
                lea     $3A0(a6),a1
                move.w  #$87,d0

loc_72012:                              ; CODE XREF: Sound_ChkValue+C8j
                move.l  (a0)+,(a1)+
                dbf     d0,loc_72012
                move.b  #-$80,$27(a6)
                clr.b   0(a6)
                bra.s   loc_7202C
; ---------------------------------------------------------------------------

loc_72024:                              ; CODE XREF: Sound_ChkValue+8Aj
                clr.b   $27(a6)
                clr.b   $26(a6)

loc_7202C:                              ; CODE XREF: Sound_ChkValue+D6j
                jsr     sub_725CA(pc)
                movea.l (off_719A0).l,a4
                subi.b  #-$7F,d7
                move.b  (a4,d7.w),$29(a6)
                movea.l (Go_MusicIndex).l,a4
                lsl.w   #2,d7
                movea.l (a4,d7.w),a4
                moveq   #0,d0
                move.w  (a4),d0
                add.l   a4,d0
                move.l  d0,$18(a6)
                move.b  5(a4),d0
                move.b  d0,$28(a6)
                tst.b   $2A(a6)
                beq.s   loc_72068
                move.b  $29(a6),d0

loc_72068:                              ; CODE XREF: Sound_ChkValue+116j
                move.b  d0,2(a6)
                move.b  d0,1(a6)
                moveq   #0,d1
                movea.l a4,a3
                addq.w  #6,a4
                moveq   #0,d7
                move.b  2(a3),d7
                beq.w   loc_72114
                subq.b  #1,d7
                move.b  #$C0,d1
                move.b  4(a3),d4
                moveq   #$30,d6
                move.b  #1,d5
                lea     $40(a6),a1
                lea     byte_721BA(pc),a2

loc_72098:                              ; CODE XREF: Sound_ChkValue+174j
                bset    #7,(a1)
                move.b  (a2)+,1(a1)
                move.b  d4,2(a1)
                move.b  d6,$D(a1)
                move.b  d1,$A(a1)
                move.b  d5,$E(a1)
                moveq   #0,d0
                move.w  (a4)+,d0
                add.l   a3,d0
                move.l  d0,4(a1)
                move.w  (a4)+,8(a1)
                adda.w  d6,a1
                dbf     d7,loc_72098
                cmpi.b  #7,2(a3)
                bne.s   loc_720D8
       ;		jmp loc_720D8
	         moveq   #$2B,d0
                moveq   #0,d1
                jsr     sub_7272E(pc)
                bra.w   loc_72114
; ---------------------------------------------------------------------------

loc_720D8:                              ; CODE XREF: Sound_ChkValue+17Ej
                moveq   #$28,d0
                moveq   #6,d1
                jsr     sub_7272E(pc)
                move.b  #$42,d0
                moveq   #$7F,d1
                jsr     sub_72764(pc)
                move.b  #$4A,d0
                moveq   #$7F,d1
                jsr     sub_72764(pc)
                move.b  #$46,d0
                moveq   #$7F,d1
                jsr     sub_72764(pc)
                move.b  #$4E,d0
                moveq   #$7F,d1
                jsr     sub_72764(pc)
                move.b  #$B6,d0
                move.b  #$C0,d1
                jsr     sub_72764(pc)

loc_72114:                              ; CODE XREF: Sound_ChkValue+130j ...
                moveq   #0,d7
                move.b  3(a3),d7
                beq.s   loc_72154
                subq.b  #1,d7
                lea     $190(a6),a1
                lea     byte_721C2(pc),a2

loc_72126:                              ; CODE XREF: Sound_ChkValue+204j
                bset    #7,(a1)
                move.b  (a2)+,1(a1)
                move.b  d4,2(a1)
                move.b  d6,$D(a1)
                move.b  d5,$E(a1)
                moveq   #0,d0
                move.w  (a4)+,d0
                add.l   a3,d0
                move.l  d0,4(a1)
                move.w  (a4)+,8(a1)
                move.b  (a4)+,d0
                move.b  (a4)+,$B(a1)
                adda.w  d6,a1
                dbf     d7,loc_72126

loc_72154:                              ; CODE XREF: Sound_ChkValue+1CEj
                lea     $220(a6),a1
                moveq   #5,d7

loc_7215A:                              ; CODE XREF: Sound_ChkValue+232j
                tst.b   (a1)
                bpl.w   loc_7217C
                moveq   #0,d0
                move.b  1(a1),d0
                bmi.s   loc_7216E
                subq.b  #2,d0
                lsl.b   #2,d0
                bra.s   loc_72170
; ---------------------------------------------------------------------------

loc_7216E:                              ; CODE XREF: Sound_ChkValue+21Aj
                lsr.b   #3,d0

loc_72170:                              ; CODE XREF: Sound_ChkValue+220j
                lea     dword_722CC(pc),a0
                movea.l (a0,d0.w),a0
                bset    #2,(a0)

loc_7217C:                              ; CODE XREF: Sound_ChkValue+210j
                adda.w  d6,a1
                dbf     d7,loc_7215A
                tst.w   $340(a6)
                bpl.s   loc_7218E
                bset    #2,$100(a6)

loc_7218E:                              ; CODE XREF: Sound_ChkValue+23Aj
                tst.w   $370(a6)
                bpl.s   loc_7219A
                bset    #2,$1F0(a6)

loc_7219A:                              ; CODE XREF: Sound_ChkValue+246j
                lea     $70(a6),a5
                moveq   #5,d4

loc_721A0:                              ; CODE XREF: Sound_ChkValue+25Aj
                jsr     sub_726FE(pc)
                adda.w  d6,a5
                dbf     d4,loc_721A0
                moveq   #2,d4

loc_721AC:                              ; CODE XREF: Sound_ChkValue+266j
                jsr     sub_729A0(pc)
                adda.w  d6,a5
                dbf     d4,loc_721AC

loc_721B6:                              ; CODE XREF: Sound_ChkValue+90j
                addq.w  #4,sp
                rts
; ---------------------------------------------------------------------------
byte_721BA:     dc.b 6, 0, 1, 2, 4, 5, 6, 0 ; DATA XREF: Sound_ChkValue+148o
byte_721C2:     dc.b $80, $A0, $C0, 0   ; DATA XREF: Sound_ChkValue+1D6o
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Play normal sound effect
; ---------------------------------------------------------------------------

Sound_A0toCF:                           ; CODE XREF: Sound_ChkValue+26j
                tst.b   $27(a6)
                bne.w   loc_722C6
                tst.b   4(a6)
                bne.w   loc_722C6
                tst.b   $24(a6)
                bne.w   loc_722C6
                cmpi.b  #$B5,d7         ; is ring sound effect played?
                bne.s   Sound_notB5     ; if not, branch
                tst.b   $2B(a6)
                bne.s   loc_721EE
                move.b  #$CE,d7         ; play ring sound in left speaker

loc_721EE:                              ; CODE XREF: Sound_ChkValue+29Cj
                bchg    #0,$2B(a6)      ; change speaker

Sound_notB5:                            ; CODE XREF: Sound_ChkValue+296j
                cmpi.b  #-$59,d7        ; is "pushing" sound played?
                bne.s   Sound_notA7     ; if not, branch
                tst.b   $2C(a6)
                bne.w   locret_722C4
                move.b  #-$80,$2C(a6)

Sound_notA7:                            ; CODE XREF: Sound_ChkValue+2ACj
                movea.l (Go_SoundIndex).l,a0
                subi.b  #-$60,d7
                lsl.w   #2,d7
                movea.l (a0,d7.w),a3
                movea.l a3,a1
                moveq   #0,d1
                move.w  (a1)+,d1
                add.l   a3,d1
                move.b  (a1)+,d5
                move.b  (a1)+,d7
                subq.b  #1,d7
                moveq   #$30,d6

loc_72228:                              ; CODE XREF: Sound_ChkValue:loc_722A8j
                moveq   #0,d3
                move.b  1(a1),d3
                move.b  d3,d4
                bmi.s   loc_72244
                subq.w  #2,d3
                lsl.w   #2,d3
                lea     dword_722CC(pc),a5
                movea.l (a5,d3.w),a5
                bset    #2,(a5)
                bra.s   loc_7226E
; ---------------------------------------------------------------------------

loc_72244:                              ; CODE XREF: Sound_ChkValue+2E4j
                lsr.w   #3,d3
                lea     dword_722CC(pc),a5
                movea.l (a5,d3.w),a5
                bset    #2,(a5)
                cmpi.b  #-$40,d4
                bne.s   loc_7226E
                move.b  d4,d0
                ori.b   #$1F,d0
                move.b  d0,($C00011).l
                bchg    #5,d0
                move.b  d0,($C00011).l

loc_7226E:                              ; CODE XREF: Sound_ChkValue+2F6j ...
                movea.l dword_722EC(pc,d3.w),a5
                movea.l a5,a2
                moveq   #$B,d0

loc_72276:                              ; CODE XREF: Sound_ChkValue+32Cj
                clr.l   (a2)+
                dbf     d0,loc_72276
                move.w  (a1)+,(a5)
                move.b  d5,2(a5)
                moveq   #0,d0
                move.w  (a1)+,d0
                add.l   a3,d0
                move.l  d0,4(a5)
                move.w  (a1)+,8(a5)
                move.b  #1,$E(a5)
                move.b  d6,$D(a5)
                tst.b   d4
                bmi.s   loc_722A8
                move.b  #-$40,$A(a5)
                move.l  d1,$20(a5)

loc_722A8:                              ; CODE XREF: Sound_ChkValue+350j
                dbf     d7,loc_72228
                tst.b   $250(a6)
                bpl.s   loc_722B8
                bset    #2,$340(a6)

loc_722B8:                              ; CODE XREF: Sound_ChkValue+364j
                tst.b   $310(a6)
                bpl.s   locret_722C4
                bset    #2,$370(a6)

locret_722C4:                           ; CODE XREF: Sound_ChkValue+2B2j ...
                rts
; ---------------------------------------------------------------------------

loc_722C6:                              ; CODE XREF: Sound_ChkValue+27Ej ...
                clr.b   0(a6)
                rts
; ---------------------------------------------------------------------------
dword_722CC:    dc.l $FFF0D0            ; DATA XREF: Sound_ChkValue:loc_72170o ...
                dc.l 0
                dc.l $FFF100
                dc.l $FFF130
                dc.l $FFF190
                dc.l $FFF1C0
                dc.l $FFF1F0
                dc.l $FFF1F0
dword_722EC:    dc.l $FFF220
                dc.l 0
                dc.l $FFF250
                dc.l $FFF280
                dc.l $FFF2B0
                dc.l $FFF2E0
                dc.l $FFF310
                dc.l $FFF310
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Play GHZ waterfall sound
; ---------------------------------------------------------------------------

Sound_D0toDF:                           ; CODE XREF: Sound_ChkValue+36j
                tst.b   $27(a6)
                bne.w   locret_723C6
                tst.b   4(a6)
                bne.w   locret_723C6
                tst.b   $24(a6)
                bne.w   locret_723C6
                movea.l (Go_SoundD0).l,a0
                subi.b  #-$30,d7
                lsl.w   #2,d7
                movea.l (a0,d7.w),a3
                movea.l a3,a1
                moveq   #0,d0
                move.w  (a1)+,d0
                add.l   a3,d0
                move.l  d0,$20(a6)
                move.b  (a1)+,d5
                move.b  (a1)+,d7
                subq.b  #1,d7
                moveq   #$30,d6

loc_72348:                              ; CODE XREF: Sound_ChkValue:loc_72396j
                move.b  1(a1),d4
                bmi.s   loc_7235A
                bset    #2,$100(a6)
                lea     $340(a6),a5
                bra.s   loc_72364
; ---------------------------------------------------------------------------

loc_7235A:                              ; CODE XREF: Sound_ChkValue+400j
                bset    #2,$1F0(a6)
                lea     $370(a6),a5

loc_72364:                              ; CODE XREF: Sound_ChkValue+40Cj
                movea.l a5,a2
                moveq   #$B,d0

loc_72368:                              ; CODE XREF: Sound_ChkValue+41Ej
                clr.l   (a2)+
                dbf     d0,loc_72368
                move.w  (a1)+,(a5)
                move.b  d5,2(a5)
                moveq   #0,d0
                move.w  (a1)+,d0
                add.l   a3,d0
                move.l  d0,4(a5)
                move.w  (a1)+,8(a5)
                move.b  #1,$E(a5)
                move.b  d6,$D(a5)
                tst.b   d4
                bmi.s   loc_72396
                move.b  #-$40,$A(a5)

loc_72396:                              ; CODE XREF: Sound_ChkValue+442j
                dbf     d7,loc_72348
                tst.b   $250(a6)
                bpl.s   loc_723A6
                bset    #2,$340(a6)

loc_723A6:                              ; CODE XREF: Sound_ChkValue+452j
                tst.b   $310(a6)
                bpl.s   locret_723C6
                bset    #2,$370(a6)
                ori.b   #$1F,d4
                move.b  d4,($C00011).l
                bchg    #5,d4
                move.b  d4,($C00011).l

locret_723C6:                           ; CODE XREF: Sound_ChkValue+3C4j ...
                rts
; End of function Sound_ChkValue

; ---------------------------------------------------------------------------
                dc.l $FFF100
                dc.l $FFF1F0
                dc.l $FFF250
                dc.l $FFF310
                dc.l $FFF340
                dc.l $FFF370

; ��������������� S U B R O U T I N E ���������������������������������������


Snd_FadeOut1:                           ; CODE XREF: ROM:Sound_E0p
                clr.b   0(a6)
                lea     $220(a6),a5
                moveq   #5,d7

loc_723EA:                              ; CODE XREF: Snd_FadeOut1+96j
                tst.b   (a5)
                bpl.w   loc_72472
                bclr    #7,(a5)
                moveq   #0,d3
                move.b  1(a5),d3
                bmi.s   loc_7243C
                jsr     sub_726FE(pc)
                cmpi.b  #4,d3
                bne.s   loc_72416
                tst.b   $340(a6)
                bpl.s   loc_72416
                lea     $340(a6),a5
                movea.l $20(a6),a1
                bra.s   loc_72428
; ---------------------------------------------------------------------------

loc_72416:                              ; CODE XREF: Snd_FadeOut1+24j ...
                subq.b  #2,d3
                lsl.b   #2,d3
                lea     dword_722CC(pc),a0
                movea.l a5,a3
                movea.l (a0,d3.w),a5
                movea.l $18(a6),a1

loc_72428:                              ; CODE XREF: Snd_FadeOut1+34j
                bclr    #2,(a5)
                bset    #1,(a5)
                move.b  $B(a5),d0
                jsr     sub_72C4E(pc)
                movea.l a3,a5
                bra.s   loc_72472
; ---------------------------------------------------------------------------

loc_7243C:                              ; CODE XREF: Snd_FadeOut1+1Aj
                jsr     sub_729A0(pc)
                lea     $370(a6),a0
                cmpi.b  #-$20,d3
                beq.s   loc_7245A
                cmpi.b  #-$40,d3
                beq.s   loc_7245A
                lsr.b   #3,d3
                lea     dword_722CC(pc),a0
                movea.l (a0,d3.w),a0

loc_7245A:                              ; CODE XREF: Snd_FadeOut1+68j ...
                bclr    #2,(a0)
                bset    #1,(a0)
                cmpi.b  #-$20,1(a0)
                bne.s   loc_72472
                move.b  $1F(a0),($C00011).l

loc_72472:                              ; CODE XREF: Snd_FadeOut1+Cj ...
                adda.w  #$30,a5
                dbf     d7,loc_723EA
                rts
; End of function Snd_FadeOut1


; ��������������� S U B R O U T I N E ���������������������������������������


Snd_FadeOut2:                           ; CODE XREF: ROM:000724EAp
                lea     $340(a6),a5
                tst.b   (a5)
                bpl.s   loc_724AE
                bclr    #7,(a5)
                btst    #2,(a5)
                bne.s   loc_724AE
                jsr     loc_7270A(pc)
                lea     $100(a6),a5
                bclr    #2,(a5)
                bset    #1,(a5)
                tst.b   (a5)
                bpl.s   loc_724AE
                movea.l $18(a6),a1
                move.b  $B(a5),d0
                jsr     sub_72C4E(pc)

loc_724AE:                              ; CODE XREF: Snd_FadeOut2+6j ...
                lea     $370(a6),a5
                tst.b   (a5)
                bpl.s   locret_724E4
                bclr    #7,(a5)
                btst    #2,(a5)
                bne.s   locret_724E4
                jsr     loc_729A6(pc)
                lea     $1F0(a6),a5
                bclr    #2,(a5)
                bset    #1,(a5)
                tst.b   (a5)
                bpl.s   locret_724E4
                cmpi.b  #$E0,1(a5)
                bne.s   locret_724E4
                move.b  $1F(a5),($C00011).l

locret_724E4:                           ; CODE XREF: Snd_FadeOut2+38j ...
                rts
; End of function Snd_FadeOut2

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Fade out music
; ---------------------------------------------------------------------------

Sound_E0:                               ; CODE XREF: Sound_ChkValue:Sound_ExIndexj
                jsr     Snd_FadeOut1(pc)
                jsr     Snd_FadeOut2(pc)
                move.b  #3,6(a6)
                move.b  #$28,4(a6)
                clr.b   $40(a6)
                clr.b   $2A(a6)
                rts

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72504:                              ; CODE XREF: sub_71B4C+58p
                move.b  6(a6),d0
                beq.s   loc_72510
                subq.b  #1,6(a6)
                rts
; ---------------------------------------------------------------------------

loc_72510:                              ; CODE XREF: sub_72504+4j
                subq.b  #1,4(a6)
                beq.w   Sound_E4
                move.b  #3,6(a6)
                lea     $70(a6),a5
                moveq   #5,d7

loc_72524:                              ; CODE XREF: sub_72504+38j
                tst.b   (a5)
                bpl.s   loc_72538
                addq.b  #1,9(a5)
                bpl.s   loc_72534
                bclr    #7,(a5)
                bra.s   loc_72538
; ---------------------------------------------------------------------------

loc_72534:                              ; CODE XREF: sub_72504+28j
                jsr     sub_72CB4(pc)

loc_72538:                              ; CODE XREF: sub_72504+22j ...
                adda.w  #$30,a5
                dbf     d7,loc_72524
                moveq   #2,d7

loc_72542:                              ; CODE XREF: sub_72504+60j
                tst.b   (a5)
                bpl.s   loc_72560
                addq.b  #1,9(a5)
                cmpi.b  #$10,9(a5)
                bcs.s   loc_72558
                bclr    #7,(a5)
                bra.s   loc_72560
; ---------------------------------------------------------------------------

loc_72558:                              ; CODE XREF: sub_72504+4Cj
                move.b  9(a5),d6
                jsr     sub_7296A(pc)

loc_72560:                              ; CODE XREF: sub_72504+40j ...
                adda.w  #$30,a5
                dbf     d7,loc_72542
                rts
; End of function sub_72504


; ��������������� S U B R O U T I N E ���������������������������������������


sub_7256A:                              ; CODE XREF: ROM:000725C2p ...
                moveq   #2,d3
                moveq   #$28,d0

loc_7256E:                              ; CODE XREF: sub_7256A+10j
                move.b  d3,d1
                jsr     sub_7272E(pc)
                addq.b  #4,d1
                jsr     sub_7272E(pc)
                dbf     d3,loc_7256E
                moveq   #$40,d0
                moveq   #$7F,d1
                moveq   #2,d4

loc_72584:                              ; CODE XREF: sub_7256A+2Ej
                moveq   #3,d3

loc_72586:                              ; CODE XREF: sub_7256A+26j
                jsr     sub_7272E(pc)
                jsr     sub_72764(pc)
                addq.w  #4,d0
                dbf     d3,loc_72586
                subi.b  #$F,d0
                dbf     d4,loc_72584
                rts
; End of function sub_7256A

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Stop music
; ---------------------------------------------------------------------------

Sound_E4:                               ; CODE XREF: Sound_ChkValue+6j ...
                moveq   #$2B,d0
                move.b  #-$80,d1
                jsr     sub_7272E(pc)
                moveq   #$27,d0
                moveq   #0,d1
                jsr     sub_7272E(pc)
                movea.l a6,a0
                move.w  #$E3,d0

loc_725B6:                              ; CODE XREF: ROM:000725B8j
                clr.l   (a0)+
                dbf     d0,loc_725B6
                move.b  #-$80,9(a6)     ; set music to $80 (silence)
                jsr     sub_7256A(pc)
                bra.w   sub_729B6

; ��������������� S U B R O U T I N E ���������������������������������������


sub_725CA:                              ; CODE XREF: Sound_ChkValue:loc_7202Cp
                movea.l a6,a0
                move.b  0(a6),d1
                move.b  $27(a6),d2
                move.b  $2A(a6),d3
                move.b  $26(a6),d4
                move.w  $A(a6),d5
                move.w  #$87,d0

loc_725E4:                              ; CODE XREF: sub_725CA+1Cj
                clr.l   (a0)+
                dbf     d0,loc_725E4
                move.b  d1,0(a6)
                move.b  d2,$27(a6)
                move.b  d3,$2A(a6)
                move.b  d4,$26(a6)
                move.w  d5,$A(a6)
                move.b  #-$80,9(a6)
                jsr     sub_7256A(pc)
                bra.w   sub_729B6
; End of function sub_725CA


; ��������������� S U B R O U T I N E ���������������������������������������


sub_7260C:                              ; CODE XREF: sub_71B4C+4Ep
                move.b  2(a6),1(a6)
                lea     $4E(a6),a0
                moveq   #$30,d0
                moveq   #9,d1

loc_7261A:                              ; CODE XREF: sub_7260C+12j
                addq.b  #1,(a0)
                adda.w  d0,a0
                dbf     d1,loc_7261A
                rts
; End of function sub_7260C

; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Speed up music
; ---------------------------------------------------------------------------

Sound_E2:                               ; CODE XREF: Sound_ChkValue+54j
                tst.b   $27(a6)
                bne.s   loc_7263E
                move.b  $29(a6),2(a6)
                move.b  $29(a6),1(a6)
                move.b  #-$80,$2A(a6)
                rts
; ---------------------------------------------------------------------------

loc_7263E:                              ; CODE XREF: ROM:00072628j
                move.b  $3C9(a6),$3A2(a6)
                move.b  $3C9(a6),$3A1(a6)
                move.b  #-$80,$3CA(a6)
                rts
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Change music back to normal speed
; ---------------------------------------------------------------------------

Sound_E3:                               ; CODE XREF: Sound_ChkValue+58j
                tst.b   $27(a6)
                bne.s   loc_7266A
                move.b  $28(a6),2(a6)
                move.b  $28(a6),1(a6)
                clr.b   $2A(a6)
                rts
; ---------------------------------------------------------------------------

loc_7266A:                              ; CODE XREF: ROM:00072656j
                move.b  $3C8(a6),$3A2(a6)
                move.b  $3C8(a6),$3A1(a6)
                clr.b   $3CA(a6)
                rts

; ��������������� S U B R O U T I N E ���������������������������������������


sub_7267C:                              ; CODE XREF: sub_71B4C+62p
                tst.b   $25(a6)
                beq.s   loc_72688
                subq.b  #1,$25(a6)
                rts
; ---------------------------------------------------------------------------

loc_72688:                              ; CODE XREF: sub_7267C+4j
                tst.b   $26(a6)
                beq.s   loc_726D6
                subq.b  #1,$26(a6)
                move.b  #2,$25(a6)
                lea     $70(a6),a5
                moveq   #5,d7

loc_7269E:                              ; CODE XREF: sub_7267C+32j
                tst.b   (a5)
                bpl.s   loc_726AA
                subq.b  #1,9(a5)
                jsr     sub_72CB4(pc)

loc_726AA:                              ; CODE XREF: sub_7267C+24j
                adda.w  #$30,a5
                dbf     d7,loc_7269E
                moveq   #2,d7

loc_726B4:                              ; CODE XREF: sub_7267C+54j
                tst.b   (a5)
                bpl.s   loc_726CC
                subq.b  #1,9(a5)
                move.b  9(a5),d6
                cmpi.b  #$10,d6
                bcs.s   loc_726C8
                moveq   #$F,d6

loc_726C8:                              ; CODE XREF: sub_7267C+48j
                jsr     sub_7296A(pc)

loc_726CC:                              ; CODE XREF: sub_7267C+3Aj
                adda.w  #$30,a5
                dbf     d7,loc_726B4
                rts
; ---------------------------------------------------------------------------

loc_726D6:                              ; CODE XREF: sub_7267C+10j
                bclr    #2,$40(a6)
                clr.b   $24(a6)
                rts
; End of function sub_7267C

; ---------------------------------------------------------------------------

loc_726E2:                              ; CODE XREF: sub_71CCA+12j
                btst    #1,(a5)
                bne.s   locret_726FC
                btst    #2,(a5)
                bne.s   locret_726FC
                moveq   #$28,d0
                move.b  1(a5),d1
                ori.b   #$F0,d1
                bra.w   sub_7272E
; ---------------------------------------------------------------------------

locret_726FC:                           ; CODE XREF: ROM:000726E6j ...
                rts

; ��������������� S U B R O U T I N E ���������������������������������������


sub_726FE:                              ; CODE XREF: sub_71CEC:loc_71D04p ...
                btst    #4,(a5)
                bne.s   locret_72714
                btst    #2,(a5)
                bne.s   locret_72714

loc_7270A:                              ; CODE XREF: Snd_FadeOut2+12p
                moveq   #$28,d0
                move.b  1(a5),d1
                bra.w   sub_7272E
; ---------------------------------------------------------------------------

locret_72714:                           ; CODE XREF: sub_726FE+4j ...
                rts
; End of function sub_726FE

; ---------------------------------------------------------------------------

loc_72716:                              ; CODE XREF: ROM:00072AE6j
                btst    #2,(a5)
                bne.s   locret_72720
                bra.w   sub_72722
; ---------------------------------------------------------------------------

locret_72720:                           ; CODE XREF: ROM:0007271Aj
                rts

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72722:                              ; CODE XREF: sub_71E18+22p ...
                btst    #2,1(a5)
                bne.s   loc_7275A
                add.b   1(a5),d0
; End of function sub_72722


; ��������������� S U B R O U T I N E ���������������������������������������


sub_7272E:                              ; CODE XREF: ROM:loc_71E6Ap ...
                move.b  ($A04000).l,d2
                btst    #7,d2
                bne.s   sub_7272E
                move.b  d0,($A04000).l
                nop
                nop
                nop

loc_72746:                              ; CODE XREF: sub_7272E+22j
                move.b  ($A04000).l,d2
                btst    #7,d2
                bne.s   loc_72746
                move.b  d1,($A04001).l
                rts
; End of function sub_7272E

; ---------------------------------------------------------------------------

loc_7275A:                              ; CODE XREF: sub_72722+6j
                move.b  1(a5),d2
                bclr    #2,d2
                add.b   d2,d0

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72764:                              ; CODE XREF: ROM:00071E6Ep ...
                move.b  ($A04000).l,d2
                btst    #7,d2
                bne.s   sub_72764
                move.b  d0,($A04002).l
                nop
                nop
                nop

loc_7277C:                              ; CODE XREF: sub_72764+22j
                move.b  ($A04000).l,d2
                btst    #7,d2
                bne.s   loc_7277C
                move.b  d1,($A04003).l
                rts
; End of function sub_72764

; ---------------------------------------------------------------------------
word_72790:     dc.w $25E, $284, $2AB, $2D3, $2FE, $32D, $35C, $38F, $3C5
                                        ; DATA XREF: sub_71D22+10o
                dc.w $3FF, $43C, $47C, $A5E, $A84, $AAB, $AD3, $AFE, $B2D
                dc.w $B5C, $B8F, $BC5, $BFF, $C3C, $C7C, $125E, $1284
                dc.w $12AB, $12D3, $12FE, $132D, $135C, $138F, $13C5, $13FF
                dc.w $143C, $147C, $1A5E, $1A84, $1AAB, $1AD3, $1AFE, $1B2D
                dc.w $1B5C, $1B8F, $1BC5, $1BFF, $1C3C, $1C7C, $225E, $2284
                dc.w $22AB, $22D3, $22FE, $232D, $235C, $238F, $23C5, $23FF
                dc.w $243C, $247C, $2A5E, $2A84, $2AAB, $2AD3, $2AFE, $2B2D
                dc.w $2B5C, $2B8F, $2BC5, $2BFF, $2C3C, $2C7C, $325E, $3284
                dc.w $32AB, $32D3, $32FE, $332D, $335C, $338F, $33C5, $33FF
                dc.w $343C, $347C, $3A5E, $3A84, $3AAB, $3AD3, $3AFE, $3B2D
                dc.w $3B5C, $3B8F, $3BC5, $3BFF, $3C3C, $3C7C

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72850:                              ; CODE XREF: sub_71B4C+A8p ...
                subq.b  #1,$E(a5)
                bne.s   loc_72866
                bclr    #4,(a5)
                jsr     sub_72878(pc)
                jsr     sub_728DC(pc)
                bra.w   loc_7292E
; ---------------------------------------------------------------------------

loc_72866:                              ; CODE XREF: sub_72850+4j
                jsr     sub_71D9E(pc)
                jsr     sub_72926(pc)
                jsr     sub_71DC6(pc)
                jsr     sub_728E2(pc)
                rts
; End of function sub_72850


; ��������������� S U B R O U T I N E ���������������������������������������


sub_72878:                              ; CODE XREF: sub_72850+Ap
                bclr    #1,(a5)
                movea.l 4(a5),a4

loc_72880:                              ; CODE XREF: sub_72878+16j
                moveq   #0,d5
                move.b  (a4)+,d5
                cmpi.b  #-$20,d5
                bcs.s   loc_72890
                jsr     sub_72A5A(pc)
                bra.s   loc_72880
; ---------------------------------------------------------------------------

loc_72890:                              ; CODE XREF: sub_72878+10j
                tst.b   d5
                bpl.s   loc_728A4
                jsr     sub_728AC(pc)
                move.b  (a4)+,d5
                tst.b   d5
                bpl.s   loc_728A4
                subq.w  #1,a4
                bra.w   sub_71D60
; ---------------------------------------------------------------------------

loc_728A4:                              ; CODE XREF: sub_72878+1Aj ...
                jsr     sub_71D40(pc)
                bra.w   sub_71D60
; End of function sub_72878


; ��������������� S U B R O U T I N E ���������������������������������������


sub_728AC:                              ; CODE XREF: sub_72878+1Cp
                subi.b  #-$7F,d5
                bcs.s   loc_728CA
                add.b   8(a5),d5
                andi.w  #$7F,d5
                lsl.w   #1,d5
                lea     word_729CE(pc),a0
                move.w  (a0,d5.w),$10(a5)
                bra.w   sub_71D60
; ---------------------------------------------------------------------------

loc_728CA:                              ; CODE XREF: sub_728AC+4j
                bset    #1,(a5)
                move.w  #$FFFF,$10(a5)
                jsr     sub_71D60(pc)
                bra.w   sub_729A0
; End of function sub_728AC


; ��������������� S U B R O U T I N E ���������������������������������������


sub_728DC:                              ; CODE XREF: sub_72850+Ep
                move.w  $10(a5),d6
                bmi.s   loc_72920
; End of function sub_728DC


; ��������������� S U B R O U T I N E ���������������������������������������


sub_728E2:                              ; CODE XREF: sub_72850+22p
                move.b  $1E(a5),d0
                ext.w   d0
                add.w   d0,d6
                btst    #2,(a5)
                bne.s   locret_7291E
                btst    #1,(a5)
                bne.s   locret_7291E
                move.b  1(a5),d0
                cmpi.b  #-$20,d0
                bne.s   loc_72904
                move.b  #-$40,d0

loc_72904:                              ; CODE XREF: sub_728E2+1Cj
                move.w  d6,d1
                andi.b  #$F,d1
                or.b    d1,d0
                lsr.w   #4,d6
                andi.b  #$3F,d6
                move.b  d0,($C00011).l
                move.b  d6,($C00011).l

locret_7291E:                           ; CODE XREF: sub_728E2+Cj ...
                rts
; End of function sub_728E2

; ---------------------------------------------------------------------------

loc_72920:                              ; CODE XREF: sub_728DC+4j
                bset    #1,(a5)
                rts

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72926:                              ; CODE XREF: sub_72850+1Ap
                tst.b   $B(a5)
                beq.w   locret_7298A

loc_7292E:                              ; CODE XREF: sub_72850+12j
                move.b  9(a5),d6
                moveq   #0,d0
                move.b  $B(a5),d0
                beq.s   sub_7296A
                movea.l (Go_PSGIndex).l,a0
                subq.w  #1,d0
                lsl.w   #2,d0
                movea.l (a0,d0.w),a0
                move.b  $C(a5),d0
                move.b  (a0,d0.w),d0
                addq.b  #1,$C(a5)
                btst    #7,d0
                beq.s   loc_72960
                cmpi.b  #-$80,d0
                beq.s   loc_7299A

loc_72960:                              ; CODE XREF: sub_72926+32j
                add.w   d0,d6
                cmpi.b  #$10,d6
                bcs.s   sub_7296A
                moveq   #$F,d6
; End of function sub_72926


; ��������������� S U B R O U T I N E ���������������������������������������


sub_7296A:                              ; CODE XREF: sub_72504+58p ...
                btst    #1,(a5)
                bne.s   locret_7298A
                btst    #2,(a5)
                bne.s   locret_7298A
                btst    #4,(a5)
                bne.s   loc_7298C

loc_7297C:                              ; CODE XREF: sub_7296A+26j ...
                or.b    1(a5),d6
                addi.b  #$10,d6
                move.b  d6,($C00011).l

locret_7298A:                           ; CODE XREF: sub_72926+4j ...
                rts
; ---------------------------------------------------------------------------

loc_7298C:                              ; CODE XREF: sub_7296A+10j
                tst.b   $13(a5)
                beq.s   loc_7297C
                tst.b   $12(a5)
                bne.s   loc_7297C
                rts
; End of function sub_7296A

; ---------------------------------------------------------------------------

loc_7299A:                              ; CODE XREF: sub_72926+38j
                subq.b  #1,$C(a5)
                rts

; ��������������� S U B R O U T I N E ���������������������������������������


sub_729A0:                              ; CODE XREF: sub_71D9E:loc_71DBEp ...
                btst    #2,(a5)
                bne.s   locret_729B4

loc_729A6:                              ; CODE XREF: Snd_FadeOut2+44p
                move.b  1(a5),d0
                ori.b   #$1F,d0
                move.b  d0,($C00011).l

locret_729B4:                           ; CODE XREF: sub_729A0+4j
                rts
; End of function sub_729A0


; ��������������� S U B R O U T I N E ���������������������������������������


sub_729B6:                              ; CODE XREF: ROM:00071E8Cp ...
                lea     ($C00011).l,a0
                move.b  #-$61,(a0)
                move.b  #-$41,(a0)
                move.b  #-$21,(a0)
                move.b  #-1,(a0)
                rts
; End of function sub_729B6

; ---------------------------------------------------------------------------
word_729CE:     dc.w $356, $326, $2F9, $2CE, $2A5, $280, $25C, $23A, $21A
                                        ; DATA XREF: sub_728AC+10o
                dc.w $1FB, $1DF, $1C4, $1AB, $193, $17D, $167, $153, $140
                dc.w $12E, $11D, $10D, $FE, $EF, $E2, $D6, $C9, $BE, $B4
                dc.w $A9, $A0, $97, $8F, $87, $7F, $78, $71, $6B, $65
                dc.w $5F, $5A, $55, $50, $4B, $47, $43, $40, $3C, $39
                dc.w $36, $33, $30, $2D, $2B, $28, $26, $24, $22, $20
                dc.w $1F, $1D, $1B, $1A, $18, $17, $16, $15, $13, $12
                dc.w $11, 0

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72A5A:                              ; CODE XREF: sub_71C4E+1Ap ...
                subi.w  #$E0,d5
                lsl.w   #2,d5
                jmp     loc_72A64(pc,d5.w)
; End of function sub_72A5A

; ---------------------------------------------------------------------------

loc_72A64:
                bra.w   loc_72ACC
; ---------------------------------------------------------------------------
                bra.w   loc_72AEC
; ---------------------------------------------------------------------------
                bra.w   loc_72AF2
; ---------------------------------------------------------------------------
                bra.w   loc_72AF8
; ---------------------------------------------------------------------------
                bra.w   loc_72B14
; ---------------------------------------------------------------------------
                bra.w   loc_72B9E
; ---------------------------------------------------------------------------
                bra.w   loc_72BA4
; ---------------------------------------------------------------------------
                bra.w   loc_72BAE
; ---------------------------------------------------------------------------
                bra.w   loc_72BB4
; ---------------------------------------------------------------------------
                bra.w   loc_72BBE
; ---------------------------------------------------------------------------
                bra.w   loc_72BC6
; ---------------------------------------------------------------------------
                bra.w   loc_72BD0
; ---------------------------------------------------------------------------
                bra.w   loc_72BE6
; ---------------------------------------------------------------------------
                bra.w   loc_72BEE
; ---------------------------------------------------------------------------
                bra.w   loc_72BF4
; ---------------------------------------------------------------------------
                bra.w   loc_72C26
; ---------------------------------------------------------------------------
                bra.w   loc_72D30
; ---------------------------------------------------------------------------
                bra.w   loc_72D52
; ---------------------------------------------------------------------------
                bra.w   loc_72D58
; ---------------------------------------------------------------------------
                bra.w   loc_72E06
; ---------------------------------------------------------------------------
                bra.w   loc_72E20
; ---------------------------------------------------------------------------
                bra.w   loc_72E26
; ---------------------------------------------------------------------------
                bra.w   loc_72E2C
; ---------------------------------------------------------------------------
                bra.w   loc_72E38
; ---------------------------------------------------------------------------
                bra.w   loc_72E52
; ---------------------------------------------------------------------------
                bra.w   loc_72E64
; ---------------------------------------------------------------------------

loc_72ACC:                              ; CODE XREF: ROM:loc_72A64j
                move.b  (a4)+,d1
                tst.b   1(a5)
                bmi.s   locret_72AEA
                move.b  $A(a5),d0
                andi.b  #$37,d0
                or.b    d0,d1
                move.b  d1,$A(a5)
                move.b  #-$4C,d0
                bra.w   loc_72716
; ---------------------------------------------------------------------------

locret_72AEA:                           ; CODE XREF: ROM:00072AD2j
                rts
; ---------------------------------------------------------------------------

loc_72AEC:                              ; CODE XREF: ROM:00072A68j
                move.b  (a4)+,$1E(a5)
                rts
; ---------------------------------------------------------------------------

loc_72AF2:                              ; CODE XREF: ROM:00072A6Cj
                move.b  (a4)+,7(a6)
                rts
; ---------------------------------------------------------------------------

loc_72AF8:                              ; CODE XREF: ROM:00072A70j
                moveq   #0,d0
                move.b  $D(a5),d0
                movea.l (a5,d0.w),a4
                move.l  #0,(a5,d0.w)
                addq.w  #2,a4
                addq.b  #4,d0
                move.b  d0,$D(a5)
                rts
; ---------------------------------------------------------------------------

loc_72B14:                              ; CODE XREF: ROM:00072A74j
                movea.l a6,a0
                lea     $3A0(a6),a1
                move.w  #$87,d0

loc_72B1E:                              ; CODE XREF: ROM:00072B20j
                move.l  (a1)+,(a0)+
                dbf     d0,loc_72B1E
                bset    #2,$40(a6)
                movea.l a5,a3
                move.b  #$28,d6
                sub.b   $26(a6),d6
                moveq   #5,d7
                lea     $70(a6),a5

loc_72B3A:                              ; CODE XREF: ROM:00072B60j
                btst    #7,(a5)
                beq.s   loc_72B5C
                bset    #1,(a5)
                add.b   d6,9(a5)
                btst    #2,(a5)
                bne.s   loc_72B5C
                moveq   #0,d0
                move.b  $B(a5),d0
                movea.l $18(a6),a1
                jsr     sub_72C4E(pc)

loc_72B5C:                              ; CODE XREF: ROM:00072B3Ej ...
                adda.w  #$30,a5
                dbf     d7,loc_72B3A
                moveq   #2,d7

loc_72B66:                              ; CODE XREF: ROM:00072B7Cj
                btst    #7,(a5)
                beq.s   loc_72B78
                bset    #1,(a5)
                jsr     sub_729A0(pc)
                add.b   d6,9(a5)

loc_72B78:                              ; CODE XREF: ROM:00072B6Aj
                adda.w  #$30,a5
                dbf     d7,loc_72B66
                movea.l a3,a5
                move.b  #-$80,$24(a6)
                move.b  #$28,$26(a6)
                clr.b   $27(a6)
                move.w  #0,($A11100).l
                addq.w  #8,sp
                rts
; ---------------------------------------------------------------------------

loc_72B9E:                              ; CODE XREF: ROM:00072A78j
                move.b  (a4)+,2(a5)
                rts
; ---------------------------------------------------------------------------

loc_72BA4:                              ; CODE XREF: ROM:00072A7Cj
                move.b  (a4)+,d0
                add.b   d0,9(a5)
                bra.w   sub_72CB4
; ---------------------------------------------------------------------------

loc_72BAE:                              ; CODE XREF: ROM:00072A80j
                bset    #4,(a5)
                rts
; ---------------------------------------------------------------------------

loc_72BB4:                              ; CODE XREF: ROM:00072A84j
                move.b  (a4),$12(a5)
                move.b  (a4)+,$13(a5)
                rts
; ---------------------------------------------------------------------------

loc_72BBE:                              ; CODE XREF: ROM:00072A88j
                move.b  (a4)+,d0
                add.b   d0,8(a5)
                rts
; ---------------------------------------------------------------------------

loc_72BC6:                              ; CODE XREF: ROM:00072A8Cj
                move.b  (a4),2(a6)
                move.b  (a4)+,1(a6)
                rts
; ---------------------------------------------------------------------------

loc_72BD0:                              ; CODE XREF: ROM:00072A90j
                lea     $40(a6),a0
                move.b  (a4)+,d0
                moveq   #$30,d1
                moveq   #9,d2

loc_72BDA:                              ; CODE XREF: ROM:00072BE0j
                move.b  d0,2(a0)
                adda.w  d1,a0
                dbf     d2,loc_72BDA
                rts
; ---------------------------------------------------------------------------

loc_72BE6:                              ; CODE XREF: ROM:00072A94j
                move.b  (a4)+,d0
                add.b   d0,9(a5)
                rts
; ---------------------------------------------------------------------------

loc_72BEE:                              ; CODE XREF: ROM:00072A98j
                clr.b   $2C(a6)
                rts
; ---------------------------------------------------------------------------

loc_72BF4:                              ; CODE XREF: ROM:00072A9Cj
                bclr    #7,(a5)
                bclr    #4,(a5)
                jsr     sub_726FE(pc)
                tst.b   $250(a6)
                bmi.s   loc_72C22
                movea.l a5,a3
                lea     $100(a6),a5
                movea.l $18(a6),a1
                bclr    #2,(a5)
                bset    #1,(a5)
                move.b  $B(a5),d0
                jsr     sub_72C4E(pc)
                movea.l a3,a5

loc_72C22:                              ; CODE XREF: ROM:00072C04j
                addq.w  #8,sp
                rts
; ---------------------------------------------------------------------------

loc_72C26:                              ; CODE XREF: ROM:00072AA0j
                moveq   #0,d0
                move.b  (a4)+,d0
                move.b  d0,$B(a5)
                btst    #2,(a5)
                bne.w   locret_72CAA
                movea.l $18(a6),a1
                tst.b   $E(a6)
                beq.s   sub_72C4E
                movea.l $20(a5),a1
                tst.b   $E(a6)
                bmi.s   sub_72C4E
                movea.l $20(a6),a1

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72C4E:                              ; CODE XREF: Snd_FadeOut1+54p ...
                subq.w  #1,d0
                bmi.s   loc_72C5C
                move.w  #$19,d1

loc_72C56:                              ; CODE XREF: sub_72C4E+Aj
                adda.w  d1,a1
                dbf     d0,loc_72C56

loc_72C5C:                              ; CODE XREF: sub_72C4E+2j
                move.b  (a1)+,d1
                move.b  d1,$1F(a5)
                move.b  d1,d4
                move.b  #-$50,d0
                jsr     sub_72722(pc)
                lea     byte_72D18(pc),a2
                moveq   #$13,d3

loc_72C72:                              ; CODE XREF: sub_72C4E+2Cj
                move.b  (a2)+,d0
                move.b  (a1)+,d1
                jsr     sub_72722(pc)
                dbf     d3,loc_72C72
                moveq   #3,d5
                andi.w  #7,d4
                move.b  byte_72CAC(pc,d4.w),d4
                move.b  9(a5),d3

loc_72C8C:                              ; CODE XREF: sub_72C4E+4Cj
                move.b  (a2)+,d0
                move.b  (a1)+,d1
                lsr.b   #1,d4
                bcc.s   loc_72C96
                add.b   d3,d1

loc_72C96:                              ; CODE XREF: sub_72C4E+44j
                jsr     sub_72722(pc)
                dbf     d5,loc_72C8C
                move.b  #-$4C,d0
                move.b  $A(a5),d1
                jsr     sub_72722(pc)

locret_72CAA:                           ; CODE XREF: ROM:00072C32j
                rts
; End of function sub_72C4E

; ---------------------------------------------------------------------------
byte_72CAC:     dc.b 8, 8, 8, 8, $A, $E, $E, $F

; ��������������� S U B R O U T I N E ���������������������������������������


sub_72CB4:                              ; CODE XREF: sub_72504:loc_72534p ...
                btst    #2,(a5)
                bne.s   locret_72D16
                moveq   #0,d0
                move.b  $B(a5),d0
                movea.l $18(a6),a1
                tst.b   $E(a6)
                beq.s   loc_72CD8
                movea.l $20(a6),a1
                tst.b   $E(a6)
                bmi.s   loc_72CD8
                movea.l $20(a6),a1

loc_72CD8:                              ; CODE XREF: sub_72CB4+14j ...
                subq.w  #1,d0
                bmi.s   loc_72CE6
                move.w  #$19,d1

loc_72CE0:                              ; CODE XREF: sub_72CB4+2Ej
                adda.w  d1,a1
                dbf     d0,loc_72CE0

loc_72CE6:                              ; CODE XREF: sub_72CB4+26j
                adda.w  #$15,a1
                lea     byte_72D2C(pc),a2
                move.b  $1F(a5),d0
                andi.w  #7,d0
                move.b  byte_72CAC(pc,d0.w),d4
                move.b  9(a5),d3
                bmi.s   locret_72D16
                moveq   #3,d5

loc_72D02:                              ; CODE XREF: sub_72CB4:loc_72D12j
                move.b  (a2)+,d0
                move.b  (a1)+,d1
                lsr.b   #1,d4
                bcc.s   loc_72D12
                add.b   d3,d1
                bcs.s   loc_72D12
                jsr     sub_72722(pc)

loc_72D12:                              ; CODE XREF: sub_72CB4+54j ...
                dbf     d5,loc_72D02

locret_72D16:                           ; CODE XREF: sub_72CB4+4j ...
                rts
; End of function sub_72CB4

; ---------------------------------------------------------------------------
byte_72D18:     dc.b $30, $38, $34, $3C, $50, $58, $54, $5C, $60, $68
                                        ; DATA XREF: sub_72C4E+1Eo
                dc.b $64, $6C, $70, $78, $74, $7C, $80, $88, $84, $8C
byte_72D2C:     dc.b $40, $48, $44, $4C ; DATA XREF: sub_72CB4+36o
; ---------------------------------------------------------------------------

loc_72D30:                              ; CODE XREF: ROM:00072AA4j
                bset    #3,(a5)
                move.l  a4,$14(a5)
                move.b  (a4)+,$18(a5)
                move.b  (a4)+,$19(a5)
                move.b  (a4)+,$1A(a5)
                move.b  (a4)+,d0
                lsr.b   #1,d0
                move.b  d0,$1B(a5)
                clr.w   $1C(a5)
                rts
; ---------------------------------------------------------------------------

loc_72D52:                              ; CODE XREF: ROM:00072AA8j
                bset    #3,(a5)
                rts
; ---------------------------------------------------------------------------

loc_72D58:                              ; CODE XREF: ROM:00072AACj
                bclr    #7,(a5)
                bclr    #4,(a5)
                tst.b   1(a5)
                bmi.s   loc_72D74
                tst.b   8(a6)
                bmi.w   loc_72E02
                jsr     sub_726FE(pc)
                bra.s   loc_72D78
; ---------------------------------------------------------------------------

loc_72D74:                              ; CODE XREF: ROM:00072D64j
                jsr     sub_729A0(pc)

loc_72D78:                              ; CODE XREF: ROM:00072D72j
                tst.b   $E(a6)
                bpl.w   loc_72E02
                clr.b   0(a6)
                moveq   #0,d0
                move.b  1(a5),d0
                bmi.s   loc_72DCC
                lea     dword_722CC(pc),a0
                movea.l a5,a3
                cmpi.b  #4,d0
                bne.s   loc_72DA8
                tst.b   $340(a6)
                bpl.s   loc_72DA8
                lea     $340(a6),a5
                movea.l $20(a6),a1
                bra.s   loc_72DB8
; ---------------------------------------------------------------------------

loc_72DA8:                              ; CODE XREF: ROM:00072D96j ...
                subq.b  #2,d0
                lsl.b   #2,d0
                movea.l (a0,d0.w),a5
                tst.b   (a5)
                bpl.s   loc_72DC8
                movea.l $18(a6),a1

loc_72DB8:                              ; CODE XREF: ROM:00072DA6j
                bclr    #2,(a5)
                bset    #1,(a5)
                move.b  $B(a5),d0
                jsr     sub_72C4E(pc)

loc_72DC8:                              ; CODE XREF: ROM:00072DB2j
                movea.l a3,a5
                bra.s   loc_72E02
; ---------------------------------------------------------------------------

loc_72DCC:                              ; CODE XREF: ROM:00072D8Aj
                lea     $370(a6),a0
                tst.b   (a0)
                bpl.s   loc_72DE0
                cmpi.b  #-$20,d0
                beq.s   loc_72DEA
                cmpi.b  #-$40,d0
                beq.s   loc_72DEA

loc_72DE0:                              ; CODE XREF: ROM:00072DD2j
                lea     dword_722CC(pc),a0
                lsr.b   #3,d0
                movea.l (a0,d0.w),a0

loc_72DEA:                              ; CODE XREF: ROM:00072DD8j ...
                bclr    #2,(a0)
                bset    #1,(a0)
                cmpi.b  #-$20,1(a0)
                bne.s   loc_72E02
                move.b  $1F(a0),($C00011).l

loc_72E02:                              ; CODE XREF: ROM:00072D6Aj ...
                addq.w  #8,sp
                rts
; ---------------------------------------------------------------------------

loc_72E06:                              ; CODE XREF: ROM:00072AB0j
                move.b  #-$20,1(a5)
                move.b  (a4)+,$1F(a5)
                btst    #2,(a5)
                bne.s   locret_72E1E
                move.b  -1(a4),($C00011).l

locret_72E1E:                           ; CODE XREF: ROM:00072E14j
                rts
; ---------------------------------------------------------------------------

loc_72E20:                              ; CODE XREF: ROM:00072AB4j
                bclr    #3,(a5)
                rts
; ---------------------------------------------------------------------------

loc_72E26:                              ; CODE XREF: ROM:00072AB8j
                move.b  (a4)+,$B(a5)
                rts
; ---------------------------------------------------------------------------

loc_72E2C:                              ; CODE XREF: ROM:00072ABCj ...
                move.b  (a4)+,d0
                lsl.w   #8,d0
                move.b  (a4)+,d0
                adda.w  d0,a4
                subq.w  #1,a4
                rts
; ---------------------------------------------------------------------------

loc_72E38:                              ; CODE XREF: ROM:00072AC0j
                moveq   #0,d0
                move.b  (a4)+,d0
                move.b  (a4)+,d1
                tst.b   $24(a5,d0.w)
                bne.s   loc_72E48
                move.b  d1,$24(a5,d0.w)

loc_72E48:                              ; CODE XREF: ROM:00072E42j
                subq.b  #1,$24(a5,d0.w)
                bne.s   loc_72E2C
                addq.w  #2,a4
                rts
; ---------------------------------------------------------------------------

loc_72E52:                              ; CODE XREF: ROM:00072AC4j
                moveq   #0,d0
                move.b  $D(a5),d0
                subq.b  #4,d0
                move.l  a4,(a5,d0.w)
                move.b  d0,$D(a5)
                bra.s   loc_72E2C
; ---------------------------------------------------------------------------

loc_72E64:                              ; CODE XREF: ROM:00072AC8j
                move.b  #-$78,d0
                move.b  #$F,d1
                jsr     sub_7272E(pc)
                move.b  #-$74,d0
                move.b  #$F,d1
                bra.w   sub_7272E
                include "./S1DRV/SMPS2ASM.asm"



;=============================================
;Data
;==============================================

	even




Go_SoundTypes:
		dc.l SoundTypes         
Go_SoundD0:
		dc.l SoundD0Index      
Go_MusicIndex:
		dc.l MusicIndex        
Go_SoundIndex:
		dc.l SoundIndex         
off_719A0:
		dc.l byte_71A94        
Go_PSGIndex:	
		dc.l PSG_Index         

; ---------------------------------------------------------------------------
; PSG instruments used in music
; ---------------------------------------------------------------------------
PSG_Index:	
	include ./ASM/PSGIndex.asm	; PSG Envelope Pointers
	include ./ASM/PSG_Inst.asm	; PSG Volume Envelopes


byte_71A94:     dc.b 7, $72, $73, $26, $15, 8, $FF, 5
	even

; ---------------------------------------------------------------------------
; Music Pointers
; ---------------------------------------------------------------------------
	include ./ASM/AMOUNT.ASM	; Music Amount (Equate!!!)

	include ./ASM/MUSICPTR.ASM	; Music Pointers

; ---------------------------------------------------------------------------
; Type of sound being played ($90 = music; $70 = normal sound effect)
; ---------------------------------------------------------------------------
SoundTypes:
        incbin  ./ASM/SNDTYPE.BIN	; Sound Types ($90 etc)

	even
	include ./ASM/SONGLIST.ASM	; Songlist (Incbins/Includes)

; ---------------------------------------------------------------------------
; Sound effect pointers
; ---------------------------------------------------------------------------
SoundIndex: 	
SoundD0Index:   
SegaPCM: 
