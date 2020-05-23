#!/bin/sh

set -e
set -u
set -x

if [ -f "environment.yml" ]; then
    echo "Setting up conda environment..."
else
    echo "environment.yml file does not exist, skipping..."
fi


if [ -f "requirements.txt" ]; then
    echo "Installing requirements.txt..."
else
    echo "requirements.txt file does not exist, skipping..."
fi

conda --help