FROM ubuntu:20.04
LABEL maintainer="Simon D. Hernandez <sdhdez@totum.one>"

# User add
ARG UID=1000
ARG GID=1000
ARG user=jupyterlab
RUN useradd -u $UID -U -ms /bin/bash $user

USER root

# Vim
# Python 3.X
# nodejs
# Cuda
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            vim \
            curl \
            gnupg \
            python3 \
            python3-dev \
            libpython3-dev \
            python3-venv \
            python-pip-whl \
            python3-pip \
            python3-pycurl \
            build-essential \
            libssl-dev \
            libffi-dev \
            libfreetype6-dev \
            libhdf5-serial-dev \
            libzmq3-dev \
            pkg-config \
            unzip \
            ca-certificates \
            locales \
            git \
    && \
    curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && \
    apt-get install -y --no-install-recommends \
            nodejs \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Links
RUN ln -s -f /usr/bin/python3 /usr/bin/python && \
    ln -s -f /usr/bin/pip3 /usr/bin/pip

# Pip update
RUN pip --no-cache-dir install --upgrade pip
RUN pip --no-cache-dir install --upgrade setuptools wheel

# Bash
RUN ln -sf /bin/bash /bin/sh

# Environment
ENV USER=/home/$user
ENV HOME=/home/$user
ENV APP=/home/$user/app

COPY run_jupyterlab.sh /

EXPOSE 8888

# Application
RUN mkdir $APP
WORKDIR $APP
RUN mkdir $HOME/.jupyter

# Change Owner
RUN chown $user:$user -R /home/$user/

USER $user

# Python basics
RUN pip --no-cache-dir install --upgrade --user nose2 pylint

# ML
RUN pip --no-cache-dir install --upgrade --user \
        numpy \
        scipy \
        matplotlib \
        ipython \
        jupyter \
        pandas \
        sympy \
        nbresuse \
        jupyterlab
# RUN pip --no-cache-dir install scispacy

# jupyterlab_vim
# RUN jupyter labextension install jupyterlab_vim

CMD ["/run_jupyterlab.sh", "--no-browser", "--ip=0.0.0.0"]
