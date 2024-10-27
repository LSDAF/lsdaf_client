#!/bin/bash

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install the required packages
echo "Installing requirements..."
pip install --quiet -r requirements.txt

# Get a list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Run gdformat on each staged file
for file in $STAGED_FILES; do
    if [[ $file == *.gd || $file == *.gdscript ]]; then
        echo "Running gdformat on $file..."
        gdformat "$file"
    fi
done

# Optionally, you can add additional commands or checks here

# Staged files
for file in $STAGED_FILES; do
    if [[ $file == *.gd || $file == *.gdscript ]]; then
        git add "$file"
    fi
done
