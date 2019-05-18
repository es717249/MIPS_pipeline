.text
    addi $s2, $s2, 2
    lui $at, 0x00001001
    nop
    nop
    ori $s4,$at,0x000
    nop
    nop
    lw $t0,4($s4)

LOOP:
    add $s4,$s1,$s0
    nop
    nop
    sub $s4,$s3,$s4
    andi $t1,$t0,0xF
    nop
    nop
    ori $t1,$t1,0x1
    nop
    nop
    add $t1,$t1,$t2
    addi $s2,$s2,-1
    
    #Maybe is needed: andi $zero,$zero,0
    bne $s2,$zero,LOOP
    nop
    nop
    
