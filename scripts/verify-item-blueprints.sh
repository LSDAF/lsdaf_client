#!/bin/bash

# Track failures and counters
texture_failures=0
missing_files=0
id_duplicates=0
name_duplicates=0
rect_duplicates=0

# Store errors for summary
declare -a error_messages

# Initialize counters
total_files=0
texture_rect_count=0
total_ids=0
total_names=0
total_rects=0

# Atlas texture constants
TEXTURE_WIDTH=32      # Width of each chunk in the atlas
TEXTURE_HEIGHT=32     # Height of each chunk in the atlas
TEXTURE_PADDING_LEFT=0  # Left padding within each chunk
TEXTURE_PADDING_TOP=0   # Top padding within each chunk

# Item types
types=("boots" "chestplates" "gloves" "helmets" "shields" "swords")
rarities=("epic" "legendary" "mythic")

# Arrays to store all IDs, names, and texture rects for uniqueness check
declare -a all_ids
declare -a all_names
declare -a all_rects
declare -a rect_files

echo "Checking all blueprints..."
echo ""

for type in "${types[@]}"; do
    echo "Checking $type..."
    for rarity in "${rarities[@]}"; do
        echo "  $rarity:"
        for num in 1 2; do
            # Remove 's' from type if it's not 'gloves'
            if [ "$type" != "gloves" ]; then
                singular_type=${type%s}
            else
                singular_type=$type
            fi
            file="src/resources/items/blueprints/$type/$rarity/${rarity}_${singular_type}_${num}.tres"
            total_files=$((total_files + 1))
            echo "    $file:"
            if [ -f "$file" ]; then
                # Get the full file content
                content=$(cat "$file")
                echo "$content"
                echo ""
                
                # Extract ID and name from [resource] section
                resource_content=$(echo "$content" | sed -n '/\[resource\]/,/^$/p')
                id=$(echo "$resource_content" | grep 'id = ' | cut -d'"' -f2)
                name=$(echo "$resource_content" | grep 'name = ' | cut -d'"' -f2)
                
                # Extract texture rect from [sub_resource] section
                rect=$(echo "$content" | grep 'region = Rect2' | sed -E 's/.*region = Rect2\(([^)]*)\).*/\1/')
                
                # Parse rect coordinates
                IFS=', ' read -r x y width height <<< "$rect"
                
                # Check texture rect alignment
                if ! [[ $x =~ ^[0-9]+$ ]] || ! [[ $y =~ ^[0-9]+$ ]] || ! [[ $width =~ ^[0-9]+$ ]] || ! [[ $height =~ ^[0-9]+$ ]]; then
                    error_messages+=("    ❌ Invalid texture rect format in $file: $rect")
                else
                    # Calculate which chunk this region starts in
                    chunk_start_x=$(( x / TEXTURE_WIDTH * TEXTURE_WIDTH ))
                    chunk_start_y=$(( y / TEXTURE_HEIGHT * TEXTURE_HEIGHT ))
                    
                    # Check if the region extends beyond its chunk
                    if (( x + width > chunk_start_x + TEXTURE_WIDTH )) || (( y + height > chunk_start_y + TEXTURE_HEIGHT )); then
                        error_messages+=("    ❌ Texture rect crosses chunk boundaries in $file. Region: $rect, Chunk: ($chunk_start_x, $chunk_start_y)")
                        texture_failures=1
                    fi
                    texture_rect_count=$((texture_rect_count + 1))
                fi
                
                # Store values
                all_ids+=("$id")
                all_names+=("$name")
                all_rects+=("$rect")
                rect_files+=("$file")
            else
                error_messages+=("    ❌ Missing file: $file")
                missing_files=1
            fi
        done
    done
done

echo ""
echo "Checking for duplicate IDs..."
duplicates=0
for i in "${!all_ids[@]}"; do
    for j in "${!all_ids[@]}"; do
        if [ $i -ne $j ] && [ "${all_ids[i]}" = "${all_ids[j]}" ]; then
            error_messages+=("    ❌ Duplicate ID found: ${all_ids[i]}")
            id_duplicates=1
        fi
    done
done
if [ $duplicates -eq 0 ]; then
    echo "✅ No duplicate IDs found"
fi

echo ""
echo "Checking for duplicate names..."
duplicates=0
for i in "${!all_names[@]}"; do
    for j in "${!all_names[@]}"; do
        if [ $i -ne $j ] && [ "${all_names[i]}" = "${all_names[j]}" ]; then
            error_messages+=("    ❌ Duplicate name found: ${all_names[i]}")
            name_duplicates=1
        fi
    done
done
if [ $duplicates -eq 0 ]; then
    echo "✅ No duplicate names found"
fi

echo ""
echo "Checking for duplicate texture rectangles..."
duplicates=0
for i in "${!all_rects[@]}"; do
    for j in "${!all_rects[@]}"; do
        if [ $i -ne $j ] && [ "${all_rects[i]}" = "${all_rects[j]}" ]; then
            error_messages+=("    ❌ Duplicate texture rect found in:")
            error_messages+=("      - ${rect_files[i]}")
            error_messages+=("      - ${rect_files[j]}")
            rect_duplicates=1
        fi
    done
done
if [ $duplicates -eq 0 ]; then
    echo "✅ No duplicate texture rectangles found"
fi

# Print errors if any exist
if [ ${#error_messages[@]} -gt 0 ]; then
    echo "=== Errors ==="
    echo ""
    for msg in "${error_messages[@]}"; do
        echo "$msg"
    done
fi

# Calculate success counts
successful_files=$((total_files - missing_files))
successful_rects=$((texture_rect_count - texture_failures))

# Print summary
echo ""
echo "=== Summary ==="
echo ""

# File check
if [ $missing_files -eq 0 ]; then
    echo "✅ All required files exist [$total_files/$total_files]"
else
    echo "❌ $missing_files missing files - [$successful_files/$total_files]"
fi

# Texture rect check
if [ $texture_failures -eq 0 ]; then
    echo "✅ All texture rects are properly contained [$texture_rect_count/$texture_rect_count]"
else
    echo "❌ $texture_failures texture rect issues - [$successful_rects/$texture_rect_count]"
fi

# Duplicate checks
if [ $id_duplicates -eq 0 ]; then
    echo "✅ No duplicate IDs found [${#all_ids[@]}/${#all_ids[@]}]"
else
    echo "❌ Found duplicate IDs - [$(( ${#all_ids[@]} - id_duplicates ))/${#all_ids[@]}]"
fi

if [ $name_duplicates -eq 0 ]; then
    echo "✅ No duplicate names found [${#all_names[@]}/${#all_names[@]}]"
else
    echo "❌ Found duplicate names - [$(( ${#all_names[@]} - name_duplicates ))/${#all_names[@]}]"
fi

if [ $rect_duplicates -eq 0 ]; then
    echo "✅ No duplicate texture rectangles found [${#all_rects[@]}/${#all_rects[@]}]"
else
    echo "❌ Found duplicate texture rectangles - [$(( ${#all_rects[@]} - rect_duplicates ))/${#all_rects[@]}]"
fi

# Compute final status
if [ $missing_files -gt 0 ] || [ $texture_failures -gt 0 ] || [ $id_duplicates -gt 0 ] || [ $name_duplicates -gt 0 ] || [ $rect_duplicates -gt 0 ]; then
    exit 1
else
    exit 0
fi
