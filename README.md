# Spartan6 - DSP48A1 — Digital Design Project

> **By:** Mazen Mohamed Hemdan

This project presents a **fully custom DSP48A1-based pipeline design** targeting the **Xilinx Spartan-6** FPGA family. It includes RTL development, simulation, linting, constraint specification, elaboration, synthesis, implementation, and bitstream generation.

---

## Full Design Reference

- This design is based on the **DSP48A1 documentation and usage guidelines** from AMD:
  [UG389 - Spartan-6 DSP48A1 Slice](https://docs.amd.com/v/u/en-US/ug389)

### Full Design Block
<img src="Images/full_design.png" width="50%" alt="Full Design Diagram"/>

---

## Objective

Design and verify a DSP-like pipeline architecture using **Verilog HDL** and AMD/Xilinx’s **DSP48A1** primitive, covering:
- 4 DSP paths
- Configurable pipeline stages
- Functional and timing verification
- Schematic exploration and wave analysis

---

## Tools & Technologies

- **Verilog HDL** — RTL Design  
- **QuestaSim** — Simulation  
- **QuestaLint** — Linting and static analysis  
- **Vivado Design Suite** — Elaboration, Synthesis, Implementation, Bitstream Generation  
- **Target FPGA:** Xilinx Spartan-6 (using DSP48A1 primitive)

---

## Project Structure

```
├── Constrain_File/     # .xdc / .ucf file for timing and pin constraints
├── Do_File/            # QuestaSim DO scripts for batch simulation
├── Images/             # Design images, waveforms, schematics, timing reports
├── RTL_Verilog/        # Source Verilog HDL files
├── Testbench_Code/     # Testbench and simulation code
├── Document.pdf        # Full project report (design + verification + results)
```

---

## Design Highlights

- Modular RTL architecture supporting 4 configurable DSP paths
- FSMs, muxes, arithmetic units, and pipelining
- 100 MHz clock constraint applied via UCF
- Formal/functional simulation of all DSP paths

---

## Verification: Waveforms per DSP Path

### Path 1
<div style="display: flex; gap: 10px;">
  <img src="Images/path1.png" width="48%" alt="Path 1 Schematic"/>
  <img src="Images/path1_wave.png" width="48%" alt="Path 1 Waveform"/>
</div>

### Path 2
<div style="display: flex; gap: 10px;">
  <img src="Images/path2.png" width="48%" alt="Path 2 Schematic"/>
  <img src="Images/path2_wave.png" width="48%" alt="Path 2 Waveform"/>
</div>

### Path 3
<div style="display: flex; gap: 10px;">
  <img src="Images/path3.png" width="48%" alt="Path 3 Schematic"/>
  <img src="Images/path3_wave.png" width="48%" alt="Path 3 Waveform"/>
</div>

### Path 4
<div style="display: flex; gap: 10px;">
  <img src="Images/path4.png" width="48%" alt="Path 4 Schematic"/>
  <img src="Images/path4_wave.png" width="48%" alt="Path 4 Waveform"/>
</div>

---

## Elaboration, Synthesis & Implementation (Vivado)

- ✅ Linting Passed — *0 Warnings, 0 Errors*
- ✅ Synthesis & Implementation — Successful
- 🎯 **Bitstream Generation** — Completed
- 📐 Includes both:
  - RTL schematic  
  - Post-synthesis schematic  

### RTL vs Synthesis Schematics
<div style="display: flex; gap: 10px;">
  <img src="Images/RTL_schematic.png" width="48%" alt="RTL Schematic"/>
  <img src="Images/Synthesis_schematic.png" width="48%" alt="Synthesis Schematic"/>
</div>

---

## ⏱ Timing Analysis (Vivado)

Achieved the following timing closure results:

- **Worst Negative Slack (Setup):** `+5.168 ns`  
- **Worst Negative Slack (Hold):** `+0.182 ns`  

### Timing Report Snapshot
<img src="Images/timing_report.png" width="50%" alt="Timing Report"/>

---

## Documentation

A detailed project report (`Document.pdf`) is included in the repository with:
- RTL design breakdown
- Testbench development
- Verification results
- DO files and constraint settings
- All Vivado reports

---

## Author

**Mazen Mohamed Hemdan**  
Bachelor of Computer Engineering  
Focus: Digital Design, Computer Architecture, Hardware Verification


