import os
import re

def update_texture_in_file(file_path, new_texture_path):
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Remove atlas texture if present and update to direct texture reference
    content = re.sub(r'\[ext_resource type="Texture2D"[^\]]*\][^\[]*\[sub_resource type="AtlasTexture"[^\]]*\][^\[]*atlas[^\[]*region[^\[]*', 
                    f'[ext_resource type="Texture2D" path="{new_texture_path}"]', 
                    content)
    
    # Update direct texture references
    content = re.sub(r'\[ext_resource type="Texture2D"[^\]]*\]', 
                    f'[ext_resource type="Texture2D" path="{new_texture_path}"]', 
                    content)
    
    with open(file_path, 'w') as f:
        f.write(content)

def process_directory(base_dir):
    for root, _, files in os.walk(base_dir):
        for file in files:
            if not file.endswith('.tres'):
                continue
                
            file_path = os.path.join(root, file)
            item_type = os.path.basename(os.path.dirname(os.path.dirname(file_path)))
            
            # Determine if it's a weapon (sword or shield)
            is_shield = item_type.lower() == 'shield'
            is_sword = item_type.lower() == 'sword'
            is_weapon = is_shield or is_sword
            base_path = "Weapon_Singles" if is_weapon else "Armor_Singles"
            
            # For swords, we use 'Weapon' instead of 'Sword' in the filename
            item_type_in_path = "Weapon" if is_sword else item_type
            
            if 'normal_' in file:
                if '_1.' in file:
                    number = "1" if is_shield else "2"
                    texture_path = f"res://asset/items/items/{base_path}/Copper/Copper_{item_type_in_path.capitalize()}{number}.png"
                elif '_2.' in file:
                    number = "3" if is_shield else "7"
                    texture_path = f"res://asset/items/items/{base_path}/Copper/Copper_{item_type_in_path.capitalize()}{number}.png"
            elif 'rare_' in file:
                if '_1.' in file:
                    number = "2" if is_shield else "5"
                    texture_path = f"res://asset/items/items/{base_path}/Iron/Iron_{item_type_in_path.capitalize()}{number}.png"
                elif '_2.' in file:
                    number = "4" if is_shield else "6"
                    texture_path = f"res://asset/items/items/{base_path}/Iron/Iron_{item_type_in_path.capitalize()}{number}.png"
            elif 'magic_' in file:
                if '_1.' in file:
                    number = "1" if is_shield else "5"
                    texture_path = f"res://asset/items/items/{base_path}/Cobalt/Cobalt_{item_type_in_path.capitalize()}{number}.png"
                elif '_2.' in file:
                    number = "3" if is_shield else "9"
                    texture_path = f"res://asset/items/items/{base_path}/Cobalt/Cobalt_{item_type_in_path.capitalize()}{number}.png"
            elif 'epic_' in file:
                if '_1.' in file:
                    number = "2" if is_shield else "14"
                    material = "Silver" if is_weapon else "Nova"
                    texture_path = f"res://asset/items/items/{base_path}/{material}/{material}_{item_type_in_path.capitalize()}{number}.png"
                elif '_2.' in file:
                    number = "4" if is_shield else "16"
                    material = "Silver" if is_weapon else "Nova"
                    texture_path = f"res://asset/items/items/{base_path}/{material}/{material}_{item_type_in_path.capitalize()}{number}.png"
            elif 'legendary_' in file:
                if '_1.' in file:
                    number = "1" if is_shield else "11"
                    texture_path = f"res://asset/items/items/{base_path}/Platinum/Platinum_{item_type_in_path.capitalize()}{number}.png"
                elif '_2.' in file:
                    number = "3" if is_shield else "17"
                    texture_path = f"res://asset/items/items/{base_path}/Platinum/Platinum_{item_type_in_path.capitalize()}{number}.png"
            elif 'mythic_' in file:
                if '_1.' in file:
                    number = "2" if is_shield else "16"
                    texture_path = f"res://asset/items/items/{base_path}/Angelic/Angelic_{item_type_in_path.capitalize()}{number}.png"
                elif '_2.' in file:
                    number = "4" if is_shield else "17"
                    texture_path = f"res://asset/items/items/{base_path}/Angelic/Angelic_{item_type_in_path.capitalize()}{number}.png"
            else:
                continue
                
            update_texture_in_file(file_path, texture_path)

if __name__ == '__main__':
    base_dir = 'src/resources/items/blueprints'
    process_directory(base_dir)
