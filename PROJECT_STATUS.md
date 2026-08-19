# Progetto: spGPU 2D Multicore FPGA (Stato del Progetto)

Questo documento riassume lo stato architetturale, hardware e software del progetto **spGPU Multicore** implementato su **FPGA Pynq-Z1**, da utilizzare come riferimento rapido per nuove chat e sessioni di sviluppo.

---

## 1. Panoramica del Sistema

* **Target Hardware**: Digilent / TUL Pynq-Z1 (`xc7z020clg400-1`).
* **Architettura GPU**: spGPU 2D Multicore tiled con **10 Core di calcolo** paralleli (`spCORE`) e **10 Tile di memoria VRAM** dual-port BRAM (`tile.vhd`).
* **Risoluzione & Display**: Risoluzione logica $320 \times 240$, output video standard 640x480 @ 60 Hz tramite controller HDMI/VGA a 25.0 MHz (pixel clock) e 125.0 MHz (serial clock).
* **Processing System (CPU)**: Dual-core ARM Cortex-A9 (Zynq-7000) programmato in bare-metal C.
* **Canale di Comunicazione**: AXI DMA in Simple Mode per lo streaming di istruzioni grafiche a 64 bit dal software ARM allo `spScheduler` della GPU.
* **Nota Hardware Scheda**: La porta micro-USB JTAG è danneggiata; la programmazione della scheda avviene copiando il file bootabile **`BOOT.bin`** su scheda micro-SD.

---

## 2. Architettura Hardware (PL - Vivado 2023.1)

### Moduli VHDL Principali:
1. **`tile.vhd`** (`multicore.srcs/sources_1/imports/luca/MyProjects/spGPU/multicore/RTL/tile.vhd`):
   * Gestisce il double-buffering ($320 \times 24$ per tile) con memoria Dual-Port BRAM.
   * Coordinate locali sicure $0 \dots 23$ con protezione anti-underflow/overflow su `hit_w` e `hit_r`.
   * FSM di Swap sincronizzata al VSYNC con auto-cancellazione a sfondo bianco del back-buffer.
2. **`sp-scheduler.vhd`** (`multicore.srcs/sources_1/imports/luca/spGPU/RTL/scheduler/sp-scheduler.vhd`):
   * Distribuzione istruzioni ai 10 core con calcolo del range di tile interessate (`v_core_start` e `v_core_end`).
   * Boundary checking con clamping a `VIDEO_Y` (240) e 0 per evitare underflow/overflow su cerchi, linee e triangoli.
   * Gestione di tutti gli opcode grafici (incluso `DRAWTRIANGLE_F`).
3. **`sp-analyzer.vhd`** (`multicore.srcs/sources_1/imports/Scaricati/sp-analyzer.vhd`):
   * Conta gli swap hardware ogni secondo e genera un impulso `int_pin` da 1 ciclo ogni 1.000.000 µs (1 Hz).
   * Espone il valore FPS su bus a 10 bit verso `axi_gpio_0`.
4. **`sp-gpu.vhd`** (`multicore.srcs/sources_1/imports/luca/spGPU/RTL/sp-gpu.vhd`):
   * Top-level della GPU.
   * Genera l'impulso `vsync_pin` sul fronte di discesa (`1 -> 0`) del VSYNC video (60 Hz).

---

## 3. Mappatura Interrupt Hardware e Software

| Sorgente Hardware | Linea Block Design | ID GIC Zynq-7000 | Tipo Trigger | Funzione Software / Handler |
|---|---|---|---|---|
| `spANALYZER / int_pin` | `xlconcat_0/In0` -> `IRQ_F2P[0]` | **61** (`CORE0NIRQ_INT_ID`) | Rising Edge (`0x03`) | `Core0nIRQ_Handler`: legge gli FPS dal GPIO e notifica la stampa a terminale ogni secondo. |
| `spgpu / vsync_pin` | `xlconcat_0/In1` -> `IRQ_F2P[1]` | **62** (`VSYNC_INT_ID`) | Rising Edge (`0x03`) | `VSync_Handler`: alza `g_vsync_occurred = 1`, sbloccando `WaitForVsync()` ad ogni frame. |

---

## 4. Software Bare-Metal (`/home/luca/Documenti/vitis_workspace/app1/src/main.c`)

* **Pacing Hardware a 60 FPS**:
  ```c
  void WaitForVsync(void) {
      while (!g_vsync_occurred) {
          // Attende l'interrupt VSYNC ID 62 dalla GPU
      }
      g_vsync_occurred = 0;
  }
  ```
* **Loop di Animazione e Fisica**:
  * Ad ogni iterazione, la CPU esegue `WaitForVsync()`: garantisce che la fisica avanzi a passo costante ($\Delta t = 1/60\text{ s}$) senza saturare la FIFO e senza frame skip.
  * Calcolo fisica con collisioni elastiche tra 10 palline e clamping sui bordi dello schermo ($320 \times 240$).
  * Chiamate di rendering `DrawCircleF(...)` via AXI DMA e `SwapBuffers()`.
  * Stampa a console UART (115200 baud): `FPS (HW): 60 | Frames (VSYNC): 60`.

---

## 5. Struttura del Repository e File Chiave

```
/home/luca/MyProjects/spGPU/multicore/fpga/
├── build_boot_bin.sh             <-- Script automatico build software e generazione BOOT.bin
├── GEMINI.md                     <-- Regole di progetto e direttive di autonomia per l'AI
├── PROJECT_STATUS.md             <-- Questo documento di stato
├── multicore.xpr                 <-- Progetto Vivado 2023.1
├── spgpu_fixed.xsa               <-- Piattaforma hardware esportata con bitstream
├── vhdl_fixed/                   <-- Copia sincronizzata dei sorgenti VHDL corretti
│   ├── tile.vhd
│   ├── sp-scheduler.vhd
│   ├── sp-analyzer.vhd
│   ├── sp-gpu.vhd
│   └── ...
├── multicore.srcs_backup/        <-- Backup dei sorgenti VHDL originali pre-modifiche
└── multicore.srcs/               <-- Sorgenti attivi del progetto Vivado

/home/luca/Documenti/vitis_workspace/
├── app1/src/main.c               <-- Sorgente applicativo C principale
├── app1/src/sp_lib.c             <-- Libreria driver DMA / GPU (SetColor, DrawCircleF, SwapBuffers, ecc.)
└── app1/Debug/BOOT.bin           <-- File binario finale da copiare su micro-SD
```

---

## 6. Come Compilare e Generare il `BOOT.bin`

Per ricompilare il software o dopo aver aggiornato l'hardware:
```bash
cd /home/luca/MyProjects/spGPU/multicore/fpga
./build_boot_bin.sh
```
Il comando:
1. Controlla il bitstream più recente da Vivado.
2. Compila i file `.c` con il cross-compiler ARM GCC.
3. Invoca `bootgen` e scrive il file `/home/luca/Documenti/vitis_workspace/app1/Debug/BOOT.bin`.
