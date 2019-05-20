.text
	lui $s0,0x1001
	addi $s0,$s0,0x0000
	lw $s1,4($s0)
	sw $s1,8($s0)
	addi $s2,$s2,1
	addi $s3,$s3,1
	addi $s4,$s4,1
	