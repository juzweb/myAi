#!/bin/bash
set -euo pipefail

echo "Starting model downloads for Qwen2.5-Coder profiles..."

echo "--- Downloading 7B (Speed Profile: ~4.7GB) ---"
ollama pull qwen2.5-coder:7b

echo "--- Downloading 14B (Balanced Profile: ~9.0GB) ---"
ollama pull qwen2.5-coder:14b

echo "--- Downloading 32B (Intelligence Profile: ~19GB) ---"
ollama pull qwen2.5-coder:32b

echo "Successfully downloaded all Qwen2.5-Coder profiles."