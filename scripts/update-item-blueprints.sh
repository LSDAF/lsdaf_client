#!/bin/bash

# Item types and rarities
types=("boots" "chestplates" "gloves" "helmets" "shields" "swords")
rarities=("epic" "legendary" "mythic")

# Map rarity to armor set
declare -A rarity_to_set
rarity_to_set["epic"]="Adamantine"
rarity_to_set["legendary"]="Angelic"
rarity_to_set["mythic"]="Nova"

for type in "${types[@]}"; do
    # Convert type to proper case for filename
    type_proper=$(echo "${type^}")  # Capitalize first letter
    singular_type=$type
    if [ "$type" != "boots" ] && [ "$type" != "gloves" ]; then
        singular_type=${type%s}  # Remove 's' for singular
    fi
    type_proper_singular=$(echo "${singular_type^}")  # Capitalize first letter

    for rarity in "${rarities[@]}"; do
        set_name="${rarity_to_set[$rarity]}"
        for num in 1 2; do
            blueprint_file="src/resources/items/blueprints/$type/$rarity/${rarity}_${singular_type}_${num}.tres"
            if [ -f "$blueprint_file" ]; then
                # Create new content
                uid=$(cat "$blueprint_file" | grep "uid=" | cut -d'"' -f2)
                new_content="[gd_resource type=\"Resource\" script_class=\"ItemBlueprint\" load_steps=3 format=3 uid=\"$uid\"]

[ext_resource type=\"Script\" path=\"res://src/models/items/item_blueprint/item_blueprint.gd\" id=\"1_dkkfm\"]
[ext_resource type=\"Texture2D\" uid=\"uid://placeholder\" path=\"res://asset/items/items/Armor_Singles/$set_name/${set_name}_${type_proper_singular}${num}.png\" id=\"2_xkkyj\"]

[resource]
script = ExtResource(\"1_dkkfm\")
rarity = $([ "$rarity" = "epic" ] && echo "3" || [ "$rarity" = "legendary" ] && echo "4" || echo "5")
level = 0
type = $([ "$type" = "boots" ] && echo "0" || [ "$type" = "chestplates" ] && echo "1" || [ "$type" = "gloves" ] && echo "2" || [ "$type" = "helmets" ] && echo "3" || [ "$type" = "shields" ] && echo "4" || echo "5")
name = \"${rarity^} ${type_proper_singular} ${num}\"
texture = ExtResource(\"2_xkkyj\")
id = \"${singular_type}_${rarity}_${num}\""

                # Write new content
                echo "$new_content" > "$blueprint_file"
                echo "Updated $blueprint_file"
            else
                echo "File not found: $blueprint_file"
            fi
        done
    done
done

echo "Done updating blueprints"
