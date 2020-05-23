#!/bin/bash

set -e
set -u
set -x

if [ -f "environment.yml" ]; then
    echo "Setting up conda environment..."
    conda env create --file environment.yml --force --name env
    eval "$(conda shell.bash hook)"
    conda activate env
else
    echo "environment.yml file does not exist, skipping..."
fi


if [ -f "requirements.txt" ]; then
    echo "Installing requirements.txt..."
    pip install -r requirements.txt
else
    echo "requirements.txt file does not exist, skipping..."
fi
