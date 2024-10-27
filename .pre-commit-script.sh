#!/bin/bash

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install the required packages
pip install -r requirements.txt

# Get a list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Run gdformat on each staged file
for file in $STAGED_FILES; do
    if [[ $file == *.gd || $file == *.gdscript ]]; then
        gdformat "$file"
    fi
done

# Optionally, you can add additional commands or checks here