FROM ubuntu:latest

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt update \
    && apt install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

RUN sudo apt update \
    && sudo apt install --no-install-recommends -y wget git python3 python3-venv libgl1 libglib2.0-0 \
    && sudo rm -rf /var/lib/apt/lists/*
RUN wget -q -P $HOME https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/webui.sh
RUN chmod u+x $HOME/webui.sh
EXPOSE 7860
ENV COMMANDLINE_ARGS="--listen"
CMD ["bash", "-c", "${HOME}/webui.sh"]
