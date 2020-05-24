#!/bin/bash

set -e
set -u
set -x

cd $1

if [ -f "prepare.sh" ]; then
    echo "Running prepare.sh..."
    source prepare.sh
else
    echo "prepare.sh file does not exist, skipping..."
fi


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


if [ -f "setup.py" ]; then
    echo "Installing from setup.py..."
    pip install .
else
    echo "No setup.py found, skipping..."
fi


if [ python -c "import ploomber" ]; then
    echo "Ploomber is not installed"
    conda install pygraphviz --yes
    pip install "git+https://github.com/ploomber/ploomber.git#egg=ploomber[all]"
else
    echo "Ploomber already installed, skippping..."
fi


echo "Running pipeline from yaml spec..."
python -m ploomber.dag.DAGSpec pipeline.yaml --action build --log INFO

