#!/bin/bash

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install the required packages
pip install --quiet -r requirements.txt

# Get a list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Run gdformat and gdlint on each staged file
gdlint_errors=()

for file in $STAGED_FILES; do
    if [[ $file == *.gd ]]; then
        echo "Running gdformat on $file..."
        gdformat "$file"
        echo "Running gdlint on $file..."
        if gdlint "$file"; then
          errored_files+=("$file")
        fi
    fi
done

if [ ${#gdlint_errors[@]} -ne 0 ]; then
  for error in "${gdlint_errors[@]}"; do
      echo " - Gdlint error: $error"
  done

  echo "Gdlint errors: [ ${#gdlint_errors[@]} ] found, aborting commit"
  exit 1
fi
# Optionally, you can add additional commands or checks here

# Add staged files to git
for file in $STAGED_FILES; do
    git add "$file"
done
