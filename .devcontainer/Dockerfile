# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.224.3/containers/codespaces-linux/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/universal:1-focal

# ** [Optional] Uncomment this section to install additional packages. **
USER root
#
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends

RUN curl -s https://fluxcd.io/install.sh | sudo bash
RUN curl -L https://github.com/openservicemesh/osm/releases/download/v1.1.0/osm-v1.1.0-Linux-amd64.tar.gz | tar -vxzf - | sudo mv ./linux-amd64/osm /usr/local/bin

USER codespace


