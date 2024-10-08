*****************************************************************************
*                                                                           *
* 			Useful macros and constants
*                                                                           *
*****************************************************************************

SNDADD          EQU     $A04000
SNDDAT          EQU     $A04001
CNTLA           EQU     $A10008
CNTLB           EQU     $A1000A
CNTLC           EQU     $A1000C
CNTLAW          EQU     $A10009
CNTLBW          EQU     $A1000B
CNTLCW          EQU     $A10009
PPCNTL          EQU     $A1000D
PPDATA          EQU     $A10007
BUSREQ          EQU     $A11100
BUSRES          EQU     $A11200
Z80RAM          EQU     $A00000
VDATA           EQU     $C00000
VCTRL           EQU     $C00004



****************************************************************************
* MACRO         SetVdpRegister REGISTER,VALUE
* DESCRIPTION:  Puts a value into one of the Genesis's VDP registers.
*               Keeps a local copy in the VDP_SHADOW array - This macro
*               only works for CONSTANTS. Use SetVdpRegisterCode for
*               registers or variables.
* PARAMETERS:   Register #,
*               Value to place into the register
****************************************************************************
SetVdpRegister  MACRO
        MOVE.W  #$8000|(\1<<8)|\2,VCTRL ; check out the SEGA manual
        ENDM

****************************************************************************
* MACRO         SetVdpRegisterCode  REGISTER,VALUE
* DESCRIPTION:  Same as SetVdpRegister, but works with registers instead
*               of constants for the value. Will generate slightly more code.
* PARAMETERS:   Register #
*               CPU register containing the value to place into the register
****************************************************************************
SetVdpRegisterCode      MACRO
        and.w   #$00ff,\2               ; Mask off high part
        or.w    #$8000|(\1<<8),\2
        move.w  \2,VCTRL
        ENDM



****************************************************************************
* MACRO         AutoIncrement
* DESCRIPTION:  Sets the autoincrement register of the VDP - Is equivalent
*               to a SetVdpRegister call, but dosen't require the register #
* PARAMETERS:   .
****************************************************************************
AutoIncrement   MACRO
        SetVdpRegister  15,\1
        ENDM


****************************************************************************
* MACRO         VramWrtAddr
* DESCRIPTION:  Sets up the VDP for vram Write, calcs an address for
*               the VRAM write.
* PARAMETERS:   address of VRAM,
*               Where to store the result - long! (will typically be VCTRL)
****************************************************************************
VramWrtAddr  MACRO
        MOVE.L  #$40000000|((\1&$3fff)<<16)|((\1>>14)&3),\2
        ENDM


****************************************************************************
* MACRO         VSramWrtAddr
* DESCRIPTION:  Sets up the VDP for vsram Write, calcs an address for
*               the VSRAM write.
* PARAMETERS:   address of VSRAM,
*               Where to store the result - long! (will typically be VCTRL)
****************************************************************************
VSramWrtAddr  MACRO
        MOVE.L  #$40000010|((\1&$3fff)<<16)|((\1>>14)&3),\2
        ENDM


****************************************************************************
* MACRO         CramWrtAddr
* DESCRIPTION:  Sets up the VDP for CRAM Write, sets address
* PARAMETERS:   address of VRAM
*               Where to store the result - long! (will typically be VCTRL)
****************************************************************************
CramWrtAddr  MACRO
        MOVE.L  #$C0000000|((\1&$3fff)<<16)|((\1>>14)&3),\2
        ENDM


****************************************************************************
* MACRO         CalcVramWrtAddrCode
* DESCRIPTION:  Generates code to set the VRAM write address. This is
*               Different from VramWrtAddr, in that this macro generates
*               CODE for the shifts and stuff, and VramWrtAddr only works with
*               constants.
* PARAMETERS:   REGISTER containing new address in lower 16 bits - NOTE THAT
*                  THIS REGISTER IS CLOBBERED WITH A CALL TO THIS MACRO!
*               REGISTER to receive sega-ized format in all 32 bits
****************************************************************************
CalcVramWrtAddrCode MACRO
        move.w  \1,\2           ; Copy for lower 14 bits
        and.l   #$3fff,\2       ; mask
        lsl.l   #8,\2
        lsl.l   #8,\2           ; Shift up
        or.l    #$40000000,\2   ; Set bit that tells VDP it's a VRAM WRITE
        lsr.l   #8,\1
        lsr.l   #6,\1           ; Shift down 14 bits
        and.l   #$3,\1
        or.l    \1,\2           ; and combine
        ENDM

