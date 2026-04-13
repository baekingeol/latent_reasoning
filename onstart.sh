#!/bin/bash
# This file is run on instance start. Output in /var/log/onstart.log

source /opt/conda/etc/profile.d/conda.sh
conda activate mull

echo "[onstart] flash-attn 설치 중 (GPU 필요, 시간이 걸립니다)..."
pip install flash-attn --no-build-isolation
echo "[onstart] flash-attn 설치 완료."
