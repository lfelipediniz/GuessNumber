# macros para criação do número randômico
.macro print_str (%addr)
    li a7, 4
    la a0, %addr
    ecall
.end_macro
            
.macro read_int 
    li a7, 5
    ecall	
.end_macro

#RANDINT DEFINES
    .eqv RNG_RETURN_R a0 #labels para registradores da função de criar números randômicos
    .eqv RNG_A_R a1
    .eqv RNG_C_R a2
    .eqv RNG_M_R a3 
    .eqv RNG_SEED_ADDR_R a4
    .eqv RNG_SEED_R a5
		
    .eqv RANDSEED_ECALL 42 #label para ecall de randseed
            
    .eqv RNG_A_VAL 34 #valor inicial para o a do algoritmo de randomização
    .eqv RNG_C_VAL 145
    .eqv RNG_M_VAL 99 #valor de módulo do algo. de rng, vai gerar uma seed final entre [0,99]        
        
        
#MAIN_GAME DEFINES
    .eqv USER_CHOICE_R  t0  #reg para guardar o input do usuário
    .eqv USER_GUESS_R t1 #reg para guardar o número adivinhado pelo usuário
    .eqv CORRECT_NUM_R s3  #reg para guardar o número correto
    .eqv ATTEMPSTS_COUNTER_R s4 #reg para guardar o número de tentativas
      
 
.data
end_msg: .asciz "\nTodas as tentativas...\n\n"
    
menu_message:   .asciz "\nBem-vindo ao GuessNumber! Voce consegue adivinhar o numero em que estou pensando?\n\n[1] Adivinhar um numero\n[0] Sair\n\nEscolha uma opcao: "

wrong_choice:   .asciz "\nEscolha invalida. Por favor, tente novamente.\n"
user_guess:     .asciz "\nTente adivinhar um numero entre 1-100: \n"
correct_guess:  .asciz "\n\nParabens, voce acertou!!!\n"
smaller_guess:  .asciz "\nSua resposta e menor que o numero correto\n"
bigger_guess:   .asciz "\nSua resposta e maior que o numero correto\n"
line_break:     .asciz "\n"
attempts_num:   .asciz "\nNumero de tentativas ate acertar: "

.text
.align 2
.globl main


main:
    jal randint #chama função de randint
    mv CORRECT_NUM_R, RNG_RETURN_R #guarda o valor aleatório

    # alocando nó inicial, não usado para armazenar dados mas como ponto de partida
    addi a7, zero, 9          # syscall para sbrk
    addi a0, zero, 8          # tamanho para um nó (4 bytes para inteiro, 4 para ponteiro next)
    ecall
    mv s0, a0                 # s0 sempre apontará para o início da lista
    sw zero, 0(s0)            # definindo valor inicial do nó para 0 (não realmente necessário)
    sw zero, 4(s0)            # definindo ponteiro next do nó inicial para NULL

menu:

# imprime mensagem do menu
    print_str menu_message

    # lê entrada do usuário
    read_int  #ecall de entrada do usuário
    mv USER_CHOICE_R , a0  # move o número lido para t0 para comparação

    # verifica a entrada do usuário e bifurca
    li t1, 1             # compara opção 1
    beq USER_CHOICE_R , t1, guess_number
    li t1, 0             # compara opção 0
    beq USER_CHOICE_R , t1, exit_game

    # se a entrada não corresponder a nenhum caso, imprime erro e salta de volta para o menu
    print_str wrong_choice
    j menu


guess_number:
    # imprime user_guess
    addi a7, zero, 4
    la a0, user_guess
    ecall

    # lê um inteiro do console
    addi a7, zero, 5
    ecall
    mv t1, a0  # move o inteiro lido para t1

	# copia t1 para USER_GUESS_R
	mv USER_GUESS_R, t1

    # printa o número que precisa ser adivinhado
    # addi a7, zero, 1
    # mv a0, CORRECT_NUM_R
    # ecall

	# compara o inteiro lido com CORRECT_NUM_R
    beq USER_GUESS_R, CORRECT_NUM_R, victory   #caso a tentativa do usuário for igual à resposta correta

	blt USER_GUESS_R, CORRECT_NUM_R, less_than #caso a tentativa do usuário for menor que a resposta correta
    j greater_than                             #se o número não for igual, nem menor, então é maior


    continue_guessing:

    # alocando memória para um novo nó
    addi a7, zero, 9
    addi a0, zero, 8
    ecall

    # armazena o inteiro de entrada no novo nó
    sw t1, 0(a0)

    # encontra o último nó
    mv t2, s0 # começa do início da lista

find_last:
    lw t3, 4(t2)              # carrega o endereço do próximo nó
    beqz t3, update_list      # se o próximo nó é NULL, o nó atual é o último
    mv t2, t3                 # move para o próximo nó
    j find_last

update_list:
    sw a0, 4(t2)              # atualiza o ponteiro next do último nó para o novo nó
    sw zero, 4(a0)            # define o ponteiro next do novo nó para NULL
    j guess_number            # volta para o loop de entrada

victory:
    # imprime mensagem de fim
    print_str end_msg

    # inicializa ATTEMPSTS_COUNTER_R com 0
    addi ATTEMPSTS_COUNTER_R, zero, 0

    # loop para imprimir a lista
    lw t2, 4(s0)              # carrega o primeiro nó real (pula o nó dummy inicial)

print_loop:
    beqz t2, exit_game        # se o nó é NULL, fim da lista
    lw t1, 0(t2)              # carrega o inteiro do nó
    
    # incrementa o contador de tentativas
    addi ATTEMPSTS_COUNTER_R, ATTEMPSTS_COUNTER_R, 1
    
    addi a7, zero, 1          # syscall para imprimir inteiro
    mv a0, t1
    ecall

	# imprime uma quebra de linha
	print_str line_break

    lw t2, 4(t2)              # move para o próximo nó
    j print_loop

less_than:
    print_str smaller_guess
    j continue_guessing

greater_than: 
    print_str bigger_guess
    j continue_guessing

exit_game:
    # imprime o número que precisa ser adivinhado
    addi a7, zero, 1
    mv a0, CORRECT_NUM_R
    ecall

    # imprIme os parabéns
    print_str correct_guess

    # imprime numero de tentativas
    print_str attempts_num

    # imprime o valor do contador de tentativas
    addi a7, zero, 1
    mv a0, ATTEMPSTS_COUNTER_R
    ecall

    li a7, 10             # chamada de sistema para sair
    ecall                 # realiza chamada de sistema

randint:
	li RNG_A_R, RNG_A_VAL #carrega valores que vão ser usados para gerar números randômicos
	li RNG_C_R, RNG_C_VAL
	li RNG_M_R, RNG_M_VAL	
	
	li a7, RANDSEED_ECALL #ecall de randseed
	ecall
	mv RNG_SEED_R, a0 #guarda a nova randomseed no registrador apropriado
		  
	mul RNG_SEED_R, RNG_SEED_R, RNG_A_R  #multiplica a seed por A
	add RNG_SEED_R, RNG_SEED_R, RNG_C_R  #adiciona C à seed
	rem RNG_SEED_R, RNG_SEED_R, RNG_M_R  #faz mod da seed por M
	
	addi RNG_RETURN_R, RNG_SEED_R, 1 #o registrador de retorno vai ter o valor da seed +1, já que a seed pode estar entre [0,99] e queremos [1,100]
	jr ra #retorna para o endereço de chamada

