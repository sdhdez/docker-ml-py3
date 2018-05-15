FROM sdavidhdez/jupyterlab:latest
LABEL maintainer="Simon D. Hernandez <sdhdez@totum.one>"

ARG user=jupyterlab

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl gnupg \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y --no-install-recommends \
                nodejs \
                build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN jupyter labextension install jupyterlab_vim

RUN cd ~ && pip --no-cache-dir install nltk
RUN pip --no-cache-dir install tensorflow==1.7.1
RUN pip --no-cache-dir install keras
RUN pip --no-cache-dir install gensim
RUN pip --no-cache-dir install whoosh
RUN pip --no-cache-dir install numpy
RUN pip --no-cache-dir install python-crfsuite

RUN chown $user:$user -R /home/$user/*

USER $user
