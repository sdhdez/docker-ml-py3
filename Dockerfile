FROM sdavidhdez/python36:latest
LABEL maintainer="Simon D. Hernandez <sdhdez@totum.one>"

RUN pip --no-cache-dir install jupyterlab

COPY run_jupyterlab.sh /

EXPOSE 8888

# User add
ARG UID=1000
ARG GID=1000
ARG user=jupyterlab
RUN useradd -u $UID -U -ms /bin/bash $user

# Environment
USER $user
ENV USER=/home/$user
ENV HOME=/home/$user
ENV APP=/home/$user/notebooks

# Application
RUN mkdir $APP
WORKDIR $APP

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
RUN pip --no-cache-dir install matplotlib
RUN pip --no-cache-dir install scikit-learn

RUN chown $user:$user -R /home/$user/*

USER $user

CMD ["/run_jupyterlab.sh", "--allow-root", "--no-browser", "--ip=0.0.0.0"]
