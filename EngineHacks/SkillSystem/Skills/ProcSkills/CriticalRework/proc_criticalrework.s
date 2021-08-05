.thumb
.macro blh to, reg=r3
  ldr \reg, =\to
  mov lr, \reg
  .short 0xf800
.endm
.equ d100Result, 0x802a52c
@ r0 is attacker, r1 is defender, r2 is current buffer, r3 is battle data
push {r4-r7,lr}
mov r4, r0 @attacker
mov r5, r1 @defender
mov r6, r2 @battle buffer
mov r7, r3 @battle data
ldr     r0,[r2]           @r0 = battle buffer                @ 0802B40A 6800     
lsl     r0,r0,#0xD                @ 0802B40C 0340     
lsr     r0,r0,#0xD        @Without damage data                @ 0802B40E 0B40     

@not miss
mov r1, #2 @miss
tst r0, r1
bne End

@if not crit reset damage
mov r1, #1
tst r0, r1
beq NoCrit

RegularCrit:

ldrh r0, [r7, #6] @attack
ldrh r1, [r7, #8] @def
sub r0, r1
lsl r1, r0, #1
add r0, r1
b CapCheck

@PierceCrit:
@ldrh r0, [r7, #6] @attack
@ldrh r1, [r7, #8] @def
@lsl r0, r0, #1
@sub r0, r1
@b CapCheck

NoCrit:
ldrh r0, [r7, #6] @attack
ldrh r1, [r7, #8] @def
sub r0, r1

CapCheck:
cmp r0, #0x7f @damage cap of 127
ble NotCap
mov r0, #0x7f
NotCap:
strh r0, [r7, #4] @final damage

End:

pop {r4-r7}
pop {r15}


.align
.ltorg
SkillTester:
@POIN SkillTester
