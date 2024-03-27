

.data
    menu_message:   .asciz "\nWelcome to GuessNumber! Can you guess the number I'm thinking of?\n\n[1] Guess a number\n[2] See Attempts\n[3] Start another game\n[0] Exit\n\nChoose an option: "
    wrong_choice:   .asciz "Invalid choice. Please try again.\n"

    .text
    .globl main

main:
    # print menu message
    la a0, menu_message  # load address of menu_message into a0
    li a7, 4              # system call for print string
    ecall                # make system call

    # read user input
    li a7, 5              # system call for read int
    ecall                # make system call
    mv t0, a0            # move read number into t0 for comparison

    # check user input and branch
    li t1, 1             # compare with option 1
    beq t0, t1, guess_number
    li t1, 2             # compare with option 2
    beq t0, t1, see_attempts
    li t1, 3             # compare with option 3
    beq t0, t1, start_game
    li t1, 0             # compare with option 0
    beq t0, t1, exit_game

    # if input doesnt match any case, print error and jump back to main
    la a0, wrong_choice
    li a7, 4
    ecall
    j main

guess_number:
    # nothing here yet
    j main

see_attempts:
    # nothing here yet
    j main

start_game:
    # nothing here yet
    j main

exit_game:
    # nothing here yet
    li a7, 10             # system call for exit
    ecall                 # make system call
