![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)
# Tiny3D - Aspiring 3D Graphics Engine

This project implements a 3D graphics hardware pipeline to render the vertices of a cube to a VGA display with user control for the rotation of the cube around all axes.

## Core Components

**Vertex Processing State Machine** - Static, resting 3D coordinates of each of the 8 vertices are routed sequentially through a single math engine during the vertical blanking period of the VGA display to calculate the final coordinate positions of the vertices given an input angle for the X, Y, and Z axis. These input angles are controlled by the user through button inputs, which control the rotation of the cube like a digital joystick.

**Rotation Math** - A 3D rotation matrix is applied to each vertex for all three axes through a single optimized rotation engine. Coordinates are represented by 8 bits, and all math is performed as fixed-point. A hardwired 6-bit trigonometry lookup table fetches the respective sine and cosine fractional values as Q1.4 fixed-point numbers. Then, a collection of four 8x6 multipliers as well as an adder and subtracter apply the 3D rotation matrix to the vertex coordinates. The results of this arithmetic can be rearranged to give a rotation around either the X, Y, or Z axis.

**VGA Rasterization** - The vertices are displayed onto a VGA display through orthographic projection, which simply entails dropping the Z term when mapping to the 2D screen. Perspective projection would've been awesome here, but given the silicon area available, it was out of budget for this project.

## How to test

Once powered, the cube vertices will be rendered with its front face directly facing the screen. Rotate the cube by driving the input pins `ui_in[5:0]` high to indicate a direction to move the front face. This can be accomplished with buttons and pull-down resistors. `rst_n` will reset the cube to its original position facing the screen.

## External hardware

[Tiny Tapeout VGA Pmod](https://store.tinytapeout.com/products/TinyVGA-Pmod-p678647356). Additionally, 6 buttons with pull-down resistors to control the directional inputs on ports 0-5.

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.
