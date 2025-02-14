#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

# Create a virtual environment
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install the required packages
pip install --quiet -r requirements.txt

# Get a list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

# Run the checks
echo -e "${GREEN}Running GDToolkit checks...${NC}"
if ! ./scripts/gdtoolkit.sh $STAGED_FILES; then
    exit 1
fi

echo -e "${GREEN}Running architectural constraints checks...${NC}"
if ! ./scripts/strict-layers.sh $STAGED_FILES; then
    exit 1
fi

# All checks passed, add the files back to staging
for file in $STAGED_FILES; do
    git add "$file"
done

exit 0
