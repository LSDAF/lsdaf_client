import os
import re

def update_texture_in_file(file_path, new_texture_path):
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Find the load_steps count to determine proper ID
    load_steps_match = re.search(r'load_steps=(\d+)', content)
    if not load_steps_match:
        print(f'Warning: Could not find load_steps in {file_path}')
        return
        
    # Find existing resource IDs to determine the next available ID
    existing_ids = re.findall(r'id="(\d+)_[^"]+"', content)
    next_id = '2'  # Default to 2 since script is usually 1
    if existing_ids:
        used_numbers = [int(id_num) for id_num in existing_ids]
        next_id = str(min(set(range(1, max(used_numbers) + 2)) - set(used_numbers)))
    
    # Generate a new unique resource ID suffix (5 chars, lowercase alphanumeric)
    import random
    import string
    id_suffix = ''.join(random.choices(string.ascii_lowercase + string.digits, k=5))
    new_id = f'{next_id}_{id_suffix}'
    
    # Remove atlas texture if present and update to direct texture reference with ID
    content = re.sub(r'\[ext_resource type="Texture2D"[^\]]*\][^\[]*\[sub_resource type="AtlasTexture"[^\]]*\][^\[]*atlas[^\[]*region[^\[]*', 
                    f'[ext_resource type="Texture2D" path="{new_texture_path}" id="{new_id}"]', 
                    content)
    
    # Update direct texture references with ID
    content = re.sub(r'\[ext_resource type="Texture2D"[^\]]*\]', 
                    f'[ext_resource type="Texture2D" path="{new_texture_path}" id="{new_id}"]', 
                    content)
    
    # Update the texture variable in [resource] section to use the new ID
    resource_section = re.search(r'\[resource\][^\[]*', content)
    if resource_section:
        resource_content = resource_section.group(0)
        # Update or add the texture line
        if 'texture = ' in resource_content:
            content = re.sub(r'texture = [^\n]*', 
                            f'texture = ExtResource("{new_id}")', 
                            content)
        else:
            # Add texture line right after [resource]
            content = re.sub(r'\[resource\]\s*', 
                            f'[resource]\ntexture = ExtResource("{new_id}")', 
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
            print(f"Processing file: {file_path}")
            print(f"Item type: {item_type}")
            
            # Determine if it's a weapon (sword or shield)
            is_shield = item_type.lower() == 'shields'
            is_sword = item_type.lower() == 'swords'
            is_weapon = is_shield or is_sword
            base_path = "Weapon_Singles" if is_weapon else "Armor_Singles"
            print(f"Is sword: {is_sword}, Is shield: {is_shield}, Base path: {base_path}")
            
            # For swords, we use 'Weapon' instead of 'Sword' in the filename
            # For shields, we use 'Shield' in the filename
            if is_sword:
                item_type_in_path = "Weapon"
            elif is_shield:
                item_type_in_path = "Shield"
            else:
                item_type_in_path = item_type
            
            if 'normal_' in file:
                if '_1.' in file:
                    number = "1" if is_shield else "2"
                    texture_path = f"res://asset/items/items/{base_path}/Copper/Copper_{item_type_in_path.capitalize()}{number}.png"
                    print(f"Generated texture path: {texture_path}")
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
