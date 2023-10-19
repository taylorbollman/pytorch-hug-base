FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
LABEL maintainer="Hugging Face"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y git libsndfile1-dev tesseract-ocr espeak-ng python3 python3-pip ffmpeg
RUN python3 -m pip install --no-cache-dir --upgrade pip

ARG REF=main
RUN git clone https://github.com/huggingface/transformers && cd transformers && git checkout $REF

# If set to nothing, will install the latest version
ARG PYTORCH=''
ARG TORCH_VISION=''
ARG TORCH_AUDIO=''
# Example: `cu102`, `cu113`, etc.
ARG CUDA='cu118'

RUN [ ${#PYTORCH} -gt 0 ] && VERSION='torch=='$PYTORCH'.*' ||  VERSION='torch'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA
RUN [ ${#TORCH_VISION} -gt 0 ] && VERSION='torchvision=='TORCH_VISION'.*' ||  VERSION='torchvision'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA
RUN [ ${#TORCH_AUDIO} -gt 0 ] && VERSION='torchaudio=='TORCH_AUDIO'.*' ||  VERSION='torchaudio'; python3 -m pip install --no-cache-dir -U $VERSION --extra-index-url https://download.pytorch.org/whl/$CUDA

# RUN python3 -m pip install --no-cache-dir -e ./transformers[dev-torch,testing,video]

RUN python3 -m pip uninstall -y tensorflow flax

RUN python3 -m pip install --no-cache-dir git+https://github.com/facebookresearch/detectron2.git pytesseract
RUN python3 -m pip install -U "itsdangerous<2.1.0"

# When installing in editable mode, `transformers` is not recognized as a package.
# this line must be added in order for python to be aware of transformers.
RUN cd transformers && python3 setup.py develop



# # Use Hugging Face's PyTorch GPU image as base
# FROM hub.docker.com/layers/huggingface/transformers-pytorch-gpu/latest/images/sha256-57dbbd230f11bed0c56c14d8491f6af1b16da7593fb54f7783d23f85df4a167d

# # Set working directory
# WORKDIR /code

# # Update apt-get, install needed tools, and clean up cache
# RUN apt-get update && \
#     apt-get install -y build-essential git && \
#     rm -rf /var/lib/apt/lists/*

# # Copy only the requirements.txt first to leverage Docker cache
# COPY ./requirements.txt /code/requirements.txt

# # Install Python dependencies
# RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# # Copy current directory to /code in the container
# COPY . .

# # Ensure /root/.ssh/ exists
# RUN mkdir -p /root/.ssh/

# # Move the authorized_keys file into place
# RUN mv /code/authorized_keys /root/.ssh/authorized_keys










