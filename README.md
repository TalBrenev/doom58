# doom58

Have you ever wanted to play Doom on an FPGA board?
Today is your lucky day!

This is a game written in Verilog, for use on the Altera DE2 board.

Doom was originally a first person shooter. This was an attempt to recreate it
in Verilog, with circuits.

Copyright 2019 Tal Brenev, Alon Djurinsky, and Luke Zhang

The `keyboard.v` file was originally created by Eric Kalantyrski, Gordon
Levitsky, Case Ploeg, and Dennis Tismenko in [this project](https://github.com/gordielsky/snake).

## Features

The game has both a 2d mode and 3d mode.

2d mode is top down, while 3d mode is first-person.

The keyboard is used to control the player.

In 2d mode, a crosshair shows where the player is looking.

The game has collision detection, so the player cannot move past walls.

The game has 360 degree (or 256 bytian) raytracing, which allows 3D mode to work,
and allows the player to rotate in 2D mode.

## Things To Do

If you're crazy enough to try, you can complete some additional features in this project:
- Incorporate distance into 3D mode to improve the illusion of perspective
- Finish implementation of enemy movement
- Implement shooting, enemy death, and player death
- Implement level advancement (manual at the moment)

## The Design

The main controller in `main.v` controls and orchestrates the entire project.
It is basically a giant FSM, which instantiates module containing smaller FSMs.
It sends start signals to these modules, and receives done signals from them.
The main module also controls access to the grid memory and the VGA buffer.
