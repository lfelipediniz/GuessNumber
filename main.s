# marcros para criação do número radomico
    .macro print_str (%addr)
        li a7,4
        la a0, %addr
        ecall
    .end_macro
            
    .macro read_int 
        li a7, 5
        ecall	
    .end_macro

         #RANDINT DEFINES
	.eqv RNG_RETURN_R a0 #labels para registradores da função de criar numeros randomicos
	.eqv RNG_A_R a1
	.eqv RNG_C_R a2
	.eqv RNG_M_R a3 
	.eqv RNG_SEED_ADDR_R a4
	.eqv RNG_SEED_R a5
		
	.eqv RANDSEED_ECALL 40 #label para ecall de randseet
		
	.eqv RNG_A_VAL 34 #valor inicial para o A do algoritmo de randomização
	.eqv RNG_C_VAL 145
	.eqv RNG_M_VAL 99 #valor de Módulo do algo. de RNG, vai gerar uma seed final entre [0,99]        
        
        
         #MAIN_GAME DEFINES
        .eqv USER_CHOICE_R t0  #reg pra guardar o input do user
        .eqv USER_GUESS_R t1 #reg pra guardar o numero adivinhado pelo user
        .eqv CORRECT_NUM_R s0  #reg pra guardar o numero correto
        

    .data
    .align 0
    menu_message:   .asciz "\nBem-vindo ao GuessNumber! Voce consegue adivinhar o numero em que estou pensando?\n\n[1] Adivinhar um número\n [2] Iniciar outro jogo\n[0] Sair\n\nEscolha uma opcao: "

    wrong_choice:   .asciz "\nEscolha invalida. Por favor, tente novamente.\n"
    user_guess:     .asciz "\nTente adivinhar um numero entre 1-100: \n"
    correct_guess:  .asciz "\nParabens, voce acertou!!!\n"
    smaller_guess:  .asciz "\nSua resposta e menor que o numero correto\n"
    bigger_guess:   .asciz "\nSua resposta e maior  que o numero correto\n"

    .text
    .align 2
    .globl main

# funções principais do jogo
main:
    # print menu message
    print_str menu_message

    # read user input
    read_int  #user input ecall
    mv USER_CHOICE_R , a0  # move read number into t0 for comparison

    jal randint #chama funcao de randint
    mv CORRECT_NUM_R , RNG_RETURN_R #guarda o valor aleatório

    # verifica a entrada do usuário e bifurca
    li t1, 1             # compara opção 1
    beq USER_CHOICE_R, t1, guess_number
    li t1, 2             # compara opção 2
    beq USER_CHOICE_R, t1,  start_game
    li t1, 0             # compara opção 0
    beq USER_CHOICE_R, t1, exit_game

    # se a entrada não corresponder a nenhum caso, imprime erro e salta de volta para o main
    print_str wrong_choice
    j main

#--------Funcoes da adivinhação--------
guess_number:
    print_str user_guess #printa a mensagem de adivinhar
    
    read_int  #le um inteiro do usuario
    mv USER_GUESS_R , a0 #guarda esse inteiro
    
    beq USER_GUESS_R, CORRECT_NUM_R, victory      #caso a tentativa do user for igual à resposta correta
    blt USER_GUESS_R, CORRECT_NUM_R, less_than    #caso a tentativa do user for menor que a resposta correta
    j greater_than                                #se o numero não for igual, nem menor, ele é maior

# função auxiliar da guess_number, caso o número seja menor que o correto
less_than:
    print_str smaller_guess
    j guess_number #usuario vai tentar adivinhar de novo

# função auxiliar da guess_number, caso o número seja maior que o correto
greater_than: 
    print_str bigger_guess
    j guess_number  #usuario vai tentar adivinhar de novo

# parabeniza o usuário, printa as tentativas anteriores e sai do jogo
victory:
    print_str correct_guess
    jal see_attempts #jump pra função de ver tentativas, pois o usuario deve ver seu historico de tentativas, vai retornar pra essa função depois
    j exit_game #jump pro final do jogo


#--------Funções de ver as tentativas do usuario e de usar a lista encadeada--------
see_attempts:
    # nada aqui ainda
    jr ra #retorna pra quem chamou a função



#--------Função de começar novo jogo
start_game:
    # nada aqui ainda
    # reseta lista linkada de tentativa, e jumpa pra main, ai vai ter um novo numero randomico gerado no comeco da main
    j main
    
#--------Função de terminar o jogo
exit_game:
    li a7, 10             # chamada de sistema para sair
    ecall                 # realiza chamada de sistema



# funções secundárias

# função para gerar um número inteiro aleatório com algoritmo:  Linear Congruential Generator (LCG)
randint:

	li RNG_A_R, RNG_A_VAL #carrega valores que vão ser usados para gerar numeros randomicos
	li RNG_C_R, RNG_C_VAL
	li RNG_M_R, RNG_M_VAL	
	
	li a7, RANDSEED_ECALL #ecall de randseed
	ecall
	mv RNG_SEED_R, a0 #guarda a nova randomseed no registrador apropiado
		  
	mul RNG_SEED_R, RNG_SEED_R, RNG_A_R  #multiplica a seed por A
	add RNG_SEED_R, RNG_SEED_R, RNG_C_R  #add C à seed
	rem RNG_SEED_R, RNG_SEED_R, RNG_M_R  #faz mod da seed por M
	
	addi RNG_RETURN_R, RNG_SEED_R, 1 # registrador de retorno vai ter o valor da seed +1 , já que a seed pode estar entre [0,99] e queremos [1,100]
	jr ra #retorna pro endereço de chamada


