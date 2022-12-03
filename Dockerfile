# Docker file for the horror movies revenue inference project
# Xinru Lu | Dec 3, 2022

# use rocker/tidyverse as the base image and
FROM rocker/tidyverse

# install R packages
RUN apt-get update -qq && apt-get install build-essential && apt-get -y --no-install-recommends install \
  && install2.r --error \
    --deps TRUE \
    docopt \
    here \
    tidyverse \
    infer \
    ggthemes

# install the anaconda distribution of python
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda update -n base -c defaults conda

# put anaconda python in path
ENV PATH="/opt/conda/bin:${PATH}"

# install docopt python package
RUN conda install -y -c anaconda \ 
    docopt \
    jupyterlab
    
RUN conda install -y -c conda-forge feather-format