# Spec-Driven Development Environment Specification

## Overview
This document defines the setup for a cost-free, spec-driven development environment using **Roo Code** and a local LLM server to replace proprietary tools like Kiro.

## Hardware Architecture

### 1. LLM Inference Server (Machine 1)
*   **OS:** Windows 11 Pro
*   **CPU:** Intel i7-8850H (6 Cores)
*   **RAM:** 32GB
*   **GPU:** NVIDIA Quadro P2000 (4GB VRAM)
*   **Role:** Dedicated host for Ollama inference.

### 2. Roo Development Laptop (Machine 2)
*   **OS:** Windows 11 Pro
*   **CPU:** Intel i5-13500H
*   **RAM:** 32GB
*   **VRAM:** Integrated (128MB dedicated)
*   **Role:** Primary IDE workstation (VS Code + Roo Code).

---

## Setup Instructions: Machine 1 (LLM Server)

1.  **Automated Setup (Git Bash as Admin):**
    *   Run the LLM setup script:
        ```bash
        bash c:/Dev/setup/bash/install_ollama.sh
        ```
2.  **Restart Ollama:**
    *   Close Ollama from the Windows System Tray and relaunch it to apply the `OLLAMA_HOST` environment variable.
4.  **Model Deployment:**
    *   Run the model pull script to install all performance profiles:
        ```bash
        bash c:/Dev/setup/bash/pull_models.sh
        ```
    *   **Available Profiles:**
    *   **Speed Profile (Instant):** `ollama run qwen2.5-coder:7b`
        * *Use for: Routine coding, unit tests, and quick bug fixes.*
    *   **Balanced Profile (Recommended):** `ollama run qwen2.5-coder:14b`
        * *Use for: Standard Spec-Driven development. Better reasoning than 7B, faster than 32B.*
    *   **Intelligence Profile (Slow):** `ollama run qwen2.5-coder:32b`
        * *Use for: Initial architectural design and complex OpenAPI mappings where precision is more important than speed.*
    * *Note: All models coexist on disk. Ollama automatically manages memory loading/unloading when switching between profiles.*

    *Hardware Note: Machine 1 (8th Gen + P2000) excels at 7B models due to 4GB VRAM. Machine 2 (13th Gen) may perform better on 32B models despite having no dedicated GPU, thanks to higher DDR5 memory bandwidth.*

5. **Model Management Commands:**
    * **Check what is currently loaded:**
        ```bash
        ollama ps
        ```
    * **Force unload a model (to free RAM):**
        ```bash
        curl http://localhost:11434/api/generate -d '{"model": "qwen2.5-coder:32b", "keep_alive": 0}'
        ```

6. **Performance Tuning:**
    * **Native vs Docker:** Native installation is recommended for both machines. Docker introduces WSL2 virtualization overhead which slows down inference on limited hardware.
    * **CPU Thread Optimization:**
      Forcing Ollama to use specific physical core counts prevents hyper-threading bottlenecks and improves token consistency.

      1. **Create the Modelfiles:**
         Create a file at `c:\Dev\setup\qwen32b.Modelfile`:
         ```dockerfile
         FROM qwen2.5-coder:32b
         PARAMETER num_thread 6     # Matches physical cores of i7-8850H
         PARAMETER num_ctx 8192     # Reduces memory bandwidth pressure
         PARAMETER low_vram true    # Optimizes for the 4GB P2000 bottleneck
         SYSTEM "You are a spec-driven coding expert. Adhere strictly to OpenAPI definitions and Mermaid diagrams."
         ```
         Create a file at `c:\Dev\setup\qwen14b.Modelfile`:
         ```dockerfile
         FROM qwen2.5-coder:14b
         PARAMETER num_thread 8     # Optimized for Machine 2's hybrid architecture
         PARAMETER num_ctx 8192     # Optimizes context for 14B memory footprint
         PARAMETER low_vram false   # Set to true only if running on Machine 1
         SYSTEM "You are a spec-driven coding expert. Adhere strictly to OpenAPI definitions and Mermaid diagrams."
         ```

      2. **Create the Tuned Models in Git Bash:**
         ```bash
         ollama create qwen32b-tuned -f c:/Dev/setup/qwen32b.Modelfile
         ollama create qwen14b-tuned -f c:/Dev/setup/qwen14b.Modelfile
         ```
         ollama run qwen14b-tuned

      3. **Selection Logic:** 
         * Use `qwen32b-tuned` for complex schema design.
         * Use `qwen14b-tuned` for active implementation and code generation.

---

## Setup Instructions: Machine 2 (Dev Laptop)

1.  **Core Environment Setup:**
    *   Run the following scripts in order to ensure idempotency:
        1. `bash c:/Dev/setup/bash/install_git.sh`
        2. `bash c:/Dev/setup/bash/installation.sh` (Auto-installs Scoop if missing)
2.  **IDE Configuration:**
    *   Install **VS Code**.
    *   Install the **Roo Code** extension.
3.  **Connect Roo to Machine 1:**
    *   Open Roo Code Settings.
    *   **Provider:** Ollama.
    *   **Base URL:** `http://<MACHINE_1_IP>:11434`.
    *   **Model:** `qwen2.5-coder:32b`

---

## Spec-Driven Workflow
1.  **Visualize:** Draft API flows using **Mermaid** in Markdown files.
2.  **Spec:** Have Roo convert Mermaid diagrams into a formal `openapi.yaml`.
3.  **Validate:** Run `spectral lint openapi.yaml` for quality checks.
4.  **Mock:** Use `prism proxy openapi.yaml` for instant API simulation.
5.  **Generate:** Scaffold the project via `openapi-generator-cli`.
6.  **Implement:** Use Roo + Qwen2.5-Coder:32B to write the logic.
7.  **Verify:** Run `st run openapi.yaml` to ensure the code matches the spec.