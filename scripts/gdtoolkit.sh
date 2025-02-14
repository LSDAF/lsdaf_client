#!/bin/bash

# Activate virtual environment
if [ ! -f ".venv/bin/activate" ]; then
    echo "Error: Virtual environment not found. Please run 'python3 -m venv .venv' first."
    exit 1
fi

source .venv/bin/activate

# Colors for output
GREEN='\033[0;32m'    # Green color
RED='\033[0;31m'      # Red color
YELLOW='\033[0;33m'   # Yellow color
NC='\033[0m'          # No Color
BOLD='\033[1m'        # Bold text

gdlint_errors=()

check_file() {
    local file="$1"
    
    if [[ $file == *.gd ]]; then
        if [[ $file == addons/* ]]; then
            echo -e "${YELLOW}Skipping ${BOLD}$file${NC}"
            return 0
        fi
        echo -e "${GREEN}Running gdformat on ${BOLD}$file${NC}"
        gdformat "$file"
        echo -e "${GREEN}Running gdlint on ${BOLD}$file${NC}"
        gdlint_output=$(gdlint "$file" 2>&1)
        gdlint_exit_code=$?
        if [ $gdlint_exit_code -ne 0 ]; then
            gdlint_errors+=("$gdlint_output")
            echo -e " - ${RED}${BOLD}Gdlint error${NC}:${YELLOW}${BOLD} $gdlint_output${NC}"
            return 1
        fi
    fi
    return 0
}

print_help() {
    echo "GDToolkit Script"
    echo "Usage: $0 [options] [files...]"
    echo "Runs gdformat and gdlint on the specified GDScript files"
    echo ""
    echo "Options:"
    echo "  -d, --directory <path>  Recursively check all GDScript files in directory"
    echo "  -h, --help              Show this help message"
    echo ""
    echo "Arguments:"
    echo "  [files...]              Path to GDScript files to check"
    exit 1
}

# Show help if no arguments provided
if [ $# -eq 0 ]; then
    print_help
fi

# Process options and arguments
files=""
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--directory)
            if [ -z "$2" ]; then
                echo "Error: Directory path required"
                exit 1
            fi
            if [ ! -d "$2" ]; then
                echo "Error: '$2' is not a directory"
                exit 1
            fi
            # Find all .gd files in directory recursively
            while IFS= read -r file; do
                files="$files$file"$'\n'
            done < <(find "$2" -name "*.gd")
            shift 2
            ;;
        -h|--help)
            print_help
            ;;
        *)
            if [[ $1 == *.gd ]]; then
                if [ ! -f "$1" ]; then
                    echo "Error: File '$1' does not exist"
                    exit 1
                fi
                files="$files$1"$'\n'
            else
                echo "Warning: Skipping non-GDScript file '$1'"
            fi
            shift
            ;;
    esac
done

if [ -z "$files" ]; then
    echo -e "${GREEN}No files to check.${NC}"
    exit 0
fi

while IFS= read -r file; do
    [ -z "$file" ] && continue
    check_file "$file"
done <<< "$files"

if [ ${#gdlint_errors[@]} -ne 0 ]; then
    echo -e "${BOLD}Gdlint errors found, aborting${NC}"
    exit 1
fi

exit 0
