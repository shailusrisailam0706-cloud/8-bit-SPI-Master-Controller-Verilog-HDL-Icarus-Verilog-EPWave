# 8-bit SPI Master Controller

A digital design project implementing an **8-bit SPI (Serial Peripheral Interface) Master Controller** using **Verilog HDL**.

## Project Overview

This project implements an SPI Master capable of transmitting 8-bit serial data to an SPI slave device. The design includes clock generation, chip-select control, serial data transmission, and synchronous control logic.

The design was developed and verified using **Icarus Verilog** and **EPWave**.

## Features

* 8-bit serial data transmission
* SPI Master controller
* Configurable clock division
* Serial clock (`SCLK`) generation
* Chip-select (`CS`) control
* MOSI data transmission
* Synchronous RTL design
* Verilog testbench for functional verification
* Waveform verification using EPWave

## SPI Signals

| Signal    | Description                          |
| --------- | ------------------------------------ |
| `clk`     | System clock                         |
| `rst`     | Reset signal                         |
| `start`   | Starts an SPI transmission           |
| `data_in` | 8-bit parallel input data            |
| `sclk`    | SPI serial clock                     |
| `mosi`    | Master-Out Slave-In data             |
| `cs`      | Chip-select signal                   |
| `busy`    | Indicates an active transmission     |
| `done`    | Indicates completion of transmission |

## Design Flow

```text
Parallel Data
     |
     v
+----------------------+
|   SPI Master RTL     |
|                      |
| Clock Divider        |
| Control Logic        |
| Shift Register       |
| Chip Select Control  |
+----------------------+
     |
     v
Serial SPI Data
```

## Implementation

The SPI Master accepts an **8-bit parallel input** and transfers the data serially through the MOSI line.

A clock divider is used to generate the SPI clock from the system clock. The controller manages the transmission sequence, including chip-select activation, serial clock generation, bit shifting, and completion indication.

## Verification

A dedicated Verilog testbench was developed to verify the SPI Master functionality.

Simulation was performed using:

* **Icarus Verilog** – RTL compilation and simulation
* **EPWave** – waveform analysis

The simulation waveforms were checked for:

* Correct chip-select behavior
* Correct SPI clock generation
* Correct serial data transmission
* Correct bit sequencing
* Correct transmission completion

## Project Files

```text
8-bit-SPI-Master-Controller-Verilog/
│
├── design.sv
├── testbench.sv
├── README.md
└── waveform/
    └── simulation_waveform.png
```

## Tools Used

* Verilog HDL
* Icarus Verilog
* EPWave
* EDA Playground

## Key Concepts Demonstrated

* RTL Design
* Sequential Logic
* Finite State Machine / Control Logic
* Clock Division
* Shift Registers
* Serial Communication
* SPI Protocol
* Functional Verification
* Simulation and Waveform Analysis

## Result

The SPI Master Controller was successfully simulated and verified using the developed testbench, with the expected SPI control signals and serial data transmission observed in the simulation waveforms.

## Simulation Waveform

The SPI Master Controller was verified through behavioral simulation.
The waveform shows the system clock, reset, start signal, SPI clock,
chip-select, MOSI/MISO data transfer, busy and done signals during
8-bit SPI communication.

