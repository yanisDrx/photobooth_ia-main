#!/bin/bash
#cd ../stable-diffusion-webui

export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512
export CUDA_VISIBLE_DEVICES=0,1

echo "🚀 Lancement WebUI pour Photo Booth MDM 2025"
echo "Interface: http://127.0.0.1:7860"
echo "API: http://127.0.0.1:7860/docs"

./webui.sh \
  --api \
  --listen \
  --port 7860 \
  --no-half \
  --no-half-vae \
  --skip-python-version-check \
  --disable-nan-check \
  --enable-insecure-extension-access \
  --ckpt sd_xl_base_1.0.safetensors \
  --no-download-sd-model \
  --xformers \
  --opt-sdp-attention \
  --api-log

