#!/bin/bash

#################### HELPER FUNCTIONS ####################

try_curl() {
    url=$1
    dest=$2
    command -v curl > /dev/null && curl -fL $url > $dest
}


try_wget() {
    url=$1
    dest=$2
    command -v wget > /dev/null && wget -O- $url > $dest
}


download() {
    echo "Downloading $1 to $2"
    if ! (try_curl $1 $2 || try_wget $1 $2); then
        echo "Could not download $1"
    fi
}

##########################################################


yay --noconfirm --needed -Syu

yay --noconfirm --needed -S \
    anki \
    python-openslide \
    visual-studio-code-bin \
    github-desktop-bin \
    urlview \
    p7zip \
    inkscape \
    texlive-most \

code --install-extension shan.code-settings-sync
code --install-extension ms-python.python

download https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh miniconda.sh

bash miniconda.sh -b
echo "# Added `date`:"
echo "export PATH=\"\$PATH:$HOME/miniconda3/bin\"" >> ~/.path
source ~/.path

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict

conda create -y --name ML01
conda init bash
source ~/.bashrc

conda activate ML01
conda install -y \
     	black \
     	cookiecutter \
     	cufflinks-py \
     	geopandas \
     	h5py \
     	hyperopt \
     	imbalanced-learn \
     	jsonpickle \
     	jupyter_contrib_nbextensions \
     	lightgbm \
     	plotly \
     	scikit-image \
     	seaborn \
     	shap \
conda clean -a -y
conda deactivate
