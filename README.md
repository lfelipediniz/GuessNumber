# GuessNumber

GuessNumber is  game designed in RISC-V Assembly, where the computer selects a random number between 1 and 100, and players attempt to guess this elusive number. With interactive hints such as "too high", "too low", or "correct", this game offers a challenge that sharpens your guessing skills.

## Features

### Random Number Generation
At the core of GuessNumber is a simple algorithm for generating a random number between 1 and 100. This number becomes the target for the player to guess, ensuring each game is a unique challenge.

### Player Interaction
Players engage directly with the game through an intuitive interface, entering their guesses in an attempt to uncover the hidden number. After each guess, immediate feedback is provided, indicating whether the guess was too high, too low, or spot-on.

### Flow Control
Through the use of flow control structures such as loops and conditionals, the game maintains a dynamic and responsive environment, guiding players through the guessing process until the correct number is identified.

### Attempt Tracking (Linked List)
A dynamically created linked list records each attempt made by the player, so he can better think about his next move.

## Getting Started

### Prerequisites

- [OpenJDK](https://openjdk.org/) or [Java](https://www.oracle.com/br/java/technologies/downloads/)
- [RARS](https://edisciplinas.usp.br/pluginfile.php/8159542/mod_folder/content/0/rars1_5.jar?forcedownload=1)


### Installation

1. Clone the repository

    ```bash
    git clone https://github.com/lfelipediniz/GuessNumber.git
    ```

2. Navigate to the project directory

    ```bash
    cd GuessNumber
    ```

### Usage

3. Run in terminal directly through
   
    ```bash
    java -jar rars1_5.jar nc main.asm
    ```
note that your RARS file may have another name

Or use RARS with its graphical interface: To run our code, open it in the **RARS** program. After opening it, press the F3 key on your keyboard. If everything goes well, press F5 and enjoy your agenda of appointments.

## Authors

| Names                          | USP Number |
| :----------------------------- | ---------- |
| Luiz Felipe Diniz Costa        | 13782032   |
| Cauê Paiva Lira                | 14675416   |
| Pedro Henrique Ferreira Silva  | 14677526   |
| Pedro Loro                     | 00000000   |

Project for the course ["Computer Organization and Architecture"](https://uspdigital.usp.br/jupiterweb/obterDisciplina?sgldis=SSC0902) at the Institute of Mathematics and Computer Science, University of Sao Paulo