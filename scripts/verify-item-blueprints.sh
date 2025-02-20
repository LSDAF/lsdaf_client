#!/bin/bash

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
            echo "    $file:"
            if [ -f "$file" ]; then
                # Get the content after [resource]
                content=$(grep -A 10 "\[resource\]" "$file")
                echo "$content"
                echo ""
                
                # Extract ID and name
                id=$(echo "$content" | grep 'id = ' | cut -d'"' -f2)
                name=$(echo "$content" | grep 'name = ' | cut -d'"' -f2)
                
                # Extract texture rect
                rect=$(echo "$content" | grep 'region = ' | cut -d'(' -f2 | cut -d')' -f1)
                
                # Store values
                all_ids+=("$id")
                all_names+=("$name")
                all_rects+=("$rect")
                rect_files+=("$file")
            else
                echo "    MISSING FILE!"
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
            echo "DUPLICATE ID FOUND: ${all_ids[i]}"
            duplicates=1
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
            echo "DUPLICATE NAME FOUND: ${all_names[i]}"
            duplicates=1
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
            echo "DUPLICATE TEXTURE RECT FOUND: ${all_rects[i]}"
            echo "  In files:"
            echo "  - ${rect_files[i]}"
            echo "  - ${rect_files[j]}"
            duplicates=1
        fi
    done
done
if [ $duplicates -eq 0 ]; then
    echo "✅ No duplicate texture rectangles found"
fi
