	#MACROS
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
    menu_message:   .asciz "\nWelcome to GuessNumber! Can you guess the number I'm thinking of?\n\n[1] Guess a number\n[2] See Attempts\n[3] Start another game\n[0] Exit\n\nChoose an option: "
    wrong_choice:   .asciz "Invalid choice. Please try again.\n"
    
    user_guess:   .asciz "\n Tente adivinhar um numero entre 1-100: \n"
    correct_guess:  .asciz "\nParabens, voce acertou!!!\n"
    smaller_guess:  .asciz "Sua resposta e menor que o numero correto\n"
    bigger_guess:  .asciz "Sua resposta e maior  que o numero correto\n"

    .text
    .align 2
    .globl main

main:
    # print menu message
    print_str menu_message

    # read user input
    read_int  #user input ecall
    mv USER_CHOICE_R , a0  # move read number into t0 for comparison
    
    jal randint #chama funcao de randint
    mv CORRECT_NUM_R , RNG_RETURN_R #guarda o valor aleatório

    # check user input and branch
    li t1, 1             # compare with option 1
    beq USER_CHOICE_R, t1, guess_number
    li t1, 2             # compare with option 2
    beq USER_CHOICE_R, t1, see_attempts
    li t1, 3             # compare with option 3
    beq USER_CHOICE_R, t1, start_game
    li t1, 0             # compare with option 0
    beq USER_CHOICE_R, t1, exit_game

    # if input doesnt match any case, print error and jump back to main
    print_str wrong_choice
    j main

guess_number:
    print_str user_guess #printa a mensagem de adivinhar
    
    read_int  #le um inteiro do usuario
    mv USER_GUESS_R , a0 #guarda esse inteiro
    
    beq USER_GUESS_R, CORRECT_NUM_R, victory_exit #caso a tentativa do user for igual à resposta correta
    blt USER_GUESS_R, CORRECT_NUM_R, less_than               #caso a tentativa do user for menor que a resposta correta
    j greater_than #se o numero não for igual, nem menor, ele é maior
    
less_than:
    print_str smaller_guess
    j guess_number
 
greater_than: 
    print_str bigger_guess
    j guess_number
    

   
    
	
   
end_guess:    
    j main

see_attempts:
    # nothing here yet
    j main

start_game:
    # nothing here yet
    j main


victory_exit:
    print_str correct_guess
    #printa mais info do user	
    li a7, 10             # system call for exit
    ecall 	

exit_game:
    # nothing here yet
    li a7, 10             # system call for exit
    ecall                 # make system call
    
    
    
  
#algoritmo:  Linear Congruential Generator (LCG)
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
	
	addi RNG_RETURN_R, RNG_SEED_R, 1 #registrador de retorno vai ter o valor da seed +1 , já que a seed pode estar entre [0,99] e queremos [1,100]
	jr ra #retorna pro endereço de chamada
