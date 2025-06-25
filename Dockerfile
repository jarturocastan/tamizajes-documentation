FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y curl ca-certificates python3 python3-pip && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g @anthropic-ai/claude-code && \
    pip3 install mkdocs mkdocs-material pymdown-extensions mkdocs-mermaid2-plugin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Permite definir UID y GID al construir o correr el contenedor
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g $GROUP_ID claude && \
    useradd -m -u $USER_ID -g $GROUP_ID -s /bin/bash claude

USER claude
WORKDIR /home/claude

CMD [ "bash" ] 