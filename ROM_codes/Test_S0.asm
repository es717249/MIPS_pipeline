#mostrar aumento de S0

.text 
inicial:
	#lui $s0,0x1001
	#addi	$s0, $s0, 0			
	
	add $t0,$t0,0x00
	addi $t0,$t0,1 #1
	addi $t0,$t0,2 #2
	addi $t0,$t0,1 #3
	addi $t0,$t0,1 #4
	addi $t0,$t0,1 #5
	addi $t0,$t0,1 #6
	addi $t0,$t0,0

main:
	j inicial
