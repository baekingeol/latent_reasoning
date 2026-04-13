FROM nvidia/cuda:12.5.1-devel-ubuntu22.04

SHELL ["/bin/bash", "-c"]

# ── Contents from bakingeol/lilab:1.01 ───────────────────────────────
RUN apt-get update && apt-get install -y \
    wget git bzip2 curl vim unzip \
    && rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH=/opt/conda/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# ─────────────────────────────────────────────────────────────────────

# Install git-lfs and build dependencies

RUN apt-get update && apt-get install -y git-lfs && rm -rf /var/lib/apt/lists/*
RUN git lfs install

# ── Copy mull project files ───────────────────────────────────────────

# ── Clone Video-R1 (tulerfeng) ────────────────────────────────────────
RUN git clone https://github.com/tulerfeng/Video-R1

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
RUN conda create -n mull python=3.11 -y

RUN conda run -n mull pip install \
    torch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 \
    --index-url https://download.pytorch.org/whl/cu124
RUN conda run -n mull pip install psutil ninja
RUN conda run -n mull pip install "transformers==4.57.1" "trl==0.16.0"


# ── Download Video-R1-COT-165k.json ──────────────────────────────────


WORKDIR /workspace/mull
