# ARMv8 CPU
## Overview
This project implements a basic ARMv8 single-cycle CPU using Verilog, focusing on core datapath and control logic. The processor executes a subset of the ARMv8 instruction set and demonstrates a complete end-to-end CPU design, including instruction decoding, arithmetic/logic execution, memory access, and register writeback.  
  
The design emphasizes correctness, modularity, and testability, with each major hardware component implemented and verified independently before full processor integration.

## Architecture
Instruction Set: ARMv8 (subset)  
  
Execution Model: Single-cycle datapath  
  
HDL: Verilog  

## Components
Arithmetic Logic Unit (ALU)  
- Supports arithmetic, logical, and comparison operations required by the instruction subset.  
  
Sign Extender  
- Handles immediate field extension for multiple instruction formats.  
  
Instruction Decoder  
- Extracts opcode fields and generates control signals.   
  
Control Unit (Single-Cycle Control)  
- Produces all datapath control signals for instruction execution in one cycle.  
  
Register File  
- Multi-ported register file with synchronous write and combinational read.  
  
Program Counter (PC) Logic   
- Branch and sequential PC update support  
  
Multiplexers and Logic Gates  
- Used extensively for datapath selection and control routing.  
  
Data Memory  
- Supports load and store operations with verified address and data behavior.  
  
Top-Level Processor Module  
- Integrates all components into a functioning ARMv8 CPU.    

## Verification and Testing  
Developed custom Verilog testbenches for:  
- Individual components (ALU, register file, memory, control)  
- Full processor execution  

Verified:
- Correct instruction decoding  
- Accurate register and memory behavior  
- Proper control signal generation  

Debugged timing and logic issues through waveform inspection  

