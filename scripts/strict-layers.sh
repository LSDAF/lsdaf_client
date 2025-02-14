#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Checking architectural layer constraints..."

violations=0

check_file() {
    local file="$1"
    
    # Only check files in src directory
    if [[ ! $file =~ ^src/ ]]; then
        return 0
    fi

    # Skip files in the autoload directory as they might be services/data themselves
    if [[ $file == *"autoload"* ]]; then
        return 0
    fi
    
    # Skip test files
    if [[ $file == *"_test.gd" ]] || [[ $file == *"__tests__"* ]]; then
        return 0
    fi

    # Check if this is a service file
    is_service=0
    if [[ $file == *"service"* ]] || grep -q "class_name.*Service" "$file"; then
        is_service=1
    fi

    # Look for data access patterns in non-service files
    if [ $is_service -eq 0 ]; then
        # Check for direct data imports/extends and usage
        if grep -q "extends.*Data" "$file" || \
           grep -q "preload.*data/" "$file" || \
           grep -q "load.*data/" "$file" || \
           grep -q "@onready.*data/" "$file" || \
           grep -q "Data\." "$file" || \
           grep -q "\$Data\." "$file"; then
            echo -e "${RED}Error: Non-service file '$file' is accessing data layer${NC}"
            echo "Found data access in a non-service file. This violates the architectural constraint."
            echo "Only service classes should access data classes."
            return 1
        fi
    fi
    return 0
}

print_help() {
    echo "Strict Layers Script"
    echo "Usage: $0 [options] [files...]"
    echo "Checks architectural constraints on GDScript files"
    echo "Only allows Data access from Service classes"
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
    echo -e "${GREEN}No GDScript files to check.${NC}"
    exit 0
fi

while IFS= read -r file; do
    [ -z "$file" ] && continue
    if ! check_file "$file"; then
        violations=$((violations + 1))
    fi
done <<< "$files"

if [ $violations -gt 0 ]; then
    echo -e "${RED}Found $violations architectural violations${NC}"
    echo "Please fix the above issues and try committing again"
    exit 1
else
    echo -e "${GREEN}No architectural violations found${NC}"
    exit 0
fi
