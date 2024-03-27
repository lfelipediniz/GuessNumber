	.data	# diretiva p/ início do seg de dados
	
	# exemplo de definição de um valor inteiro
	.align 2
	vlr_inteiro:	.word 157
	
	# definição da string
	.align 0
	string:		.asciz "Hello World"

	.text 		# diretiva p/ início do segmento de texto

	.globl main	# diretiva p/ usar rotulo em outro prog.

main:					
	.align 2	# alinha a memória para armazenar as instruções de 32 bits
	
	addi a7, x0, 4 	# Código do serviço 4 (impressão de string)
	la a0, string	# Carrega o endereço do 1o byte de "string" em a0
	ecall			# Chamada ao sistema para impressão da string

	addi a7, x0, 10	# Código do serviço que encerra
	ecall