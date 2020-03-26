FROM ubuntu:18.04
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
            build-essential \
            libfreetype6-dev \
            libhdf5-serial-dev \
            libzmq3-dev \
            pkg-config \
            unzip \
            ca-certificates \
            locales \
            python3-pycurl \
            nodejs \
            npm \
    && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - \
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

# Python basics
RUN pip --no-cache-dir install \
        nose2 \
        pylint

# JupyterLab
RUN pip --no-cache-dir install jupyterlab

# jupyterlab_vim
# RUN jupyter labextension install jupyterlab_vim

# ML
RUN cd ~ && pip --no-cache-dir install nltk
RUN pip --no-cache-dir install python-crfsuite
RUN pip --no-cache-dir install whoosh
RUN pip --no-cache-dir install numpy
RUN pip --no-cache-dir install matplotlib
RUN pip --no-cache-dir install scikit-learn
RUN pip --no-cache-dir install tensorflow
RUN pip --no-cache-dir install keras
RUN pip --no-cache-dir install gensim
RUN pip --no-cache-dir install pandas
RUN pip --no-cache-dir install spacy
RUN pip --no-cache-dir install torch torchvision

# Change Owner
RUN chown $user:$user -R /home/$user/.*

# Environment
ENV USER=/home/$user
ENV HOME=/home/$user
ENV APP=/home/$user/app

COPY run_jupyterlab.sh /

EXPOSE 8888

# Application
RUN mkdir $APP
WORKDIR $APP

USER $user

CMD ["/run_jupyterlab.sh", "--no-browser", "--ip=0.0.0.0"]
