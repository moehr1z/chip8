# CHIP 8

A CHIP-8 emulator in Ada/Spark.  
[Spark](https://en.wikipedia.org/wiki/SPARK_(programming_language)) is a subset of the [Ada](https://en.wikipedia.org/wiki/Ada_(programming_language)) programming language, which is subject to formal reasoning about the programs integrity and functional correctness.
It is intended for use in highly reliable, high integrity software (so kind of overkill here...).
Currently around 80% of the code is formally verified to be free of runtime errors.
The emulator uses [SDL](https://www.libsdl.org/) for audio, graphics and input and was tested with [Timendus Chip-8 test suite](https://github.com/Timendus/chip8-test-suite).

<img width="5130" height="2570" alt="chip8" src="https://github.com/user-attachments/assets/9a3da77a-4f78-4b9b-a6b3-f155b8edc84f" />

# Build and Run
The project requires the [Alire](https://alire.ada.dev/) package manager to build. 
After installing it just run `alr build` to compile the emulator.

You can then use the emulator by running `./bin/chip8 -r /path/to/rom` from within the project directory.
Use `./bin/chip8 -h` to see all available options.

# Compatibility
I tested it on Linux and there's a Github Workflow for Linux and Windows. 
I also tried to compile it for macOS, which didn't work straight away, so help is welcome here.

# Controls
The emulator provides the following keymap:

| | | | | | | | | |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 2 | 3 | C |    | 1 | 2 | 3 | 4 |
| 4 | 5 | 6 | D | => | Q | W | E | R |
| 7 | 8 | 9 | E |    | A | S | D | F |
| A | 0 | B | F |    | Z | X | C | V |

Special keys:  
`P` --- Pause the emulation
