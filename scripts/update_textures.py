import os
import re

def update_texture_in_file(file_path, new_texture_path):
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Remove atlas texture if present
    content = re.sub(r'\[ext_resource type="Texture2D"[^\]]*\][^\[]*\[sub_resource type="AtlasTexture"[^\]]*\][^\[]*atlas[^\[]*region[^\[]*', 
                    f'[ext_resource type="Texture2D" uid="uid://br1l5u58r8u28" path="{new_texture_path}" id="2_3aggy"]', 
                    content)
    
    # Update direct texture references
    content = re.sub(r'\[ext_resource type="Texture2D"[^\]]*\]', 
                    f'[ext_resource type="Texture2D" uid="uid://br1l5u58r8u28" path="{new_texture_path}" id="2_3aggy"]', 
                    content)
    
    # Update texture reference in resource section
    content = re.sub(r'texture = SubResource\("[^"]*"\)', 'texture = ExtResource("2_3aggy")', content)
    
    with open(file_path, 'w') as f:
        f.write(content)

def process_directory(base_dir):
    for root, _, files in os.walk(base_dir):
        for file in files:
            if not file.endswith('.tres'):
                continue
                
            file_path = os.path.join(root, file)
            item_type = os.path.basename(os.path.dirname(os.path.dirname(file_path)))
            
            if 'normal_' in file:
                if '_1.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Copper/Copper_{item_type.capitalize()}2.png"
                elif '_2.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Copper/Copper_{item_type.capitalize()}7.png"
            elif 'rare_' in file:
                if '_1.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Iron/Iron_{item_type.capitalize()}5.png"
                elif '_2.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Iron/Iron_{item_type.capitalize()}6.png"
            elif 'magic_' in file:
                if '_1.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Cobalt/Cobalt_{item_type.capitalize()}5.png"
                elif '_2.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Cobalt/Cobalt_{item_type.capitalize()}9.png"
            elif 'epic_' in file:
                if '_1.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Nova/Nova_{item_type.capitalize()}14.png"
                elif '_2.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Nova/Nova_{item_type.capitalize()}16.png"
            elif 'legendary_' in file:
                if '_1.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Platinum/Platinum_{item_type.capitalize()}11.png"
                elif '_2.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Platinum/Platinum_{item_type.capitalize()}17.png"
            elif 'mythic_' in file:
                if '_1.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Angelic/Angelic_{item_type.capitalize()}16.png"
                elif '_2.' in file:
                    texture_path = f"res://asset/items/items/Armor_Singles/Angelic/Angelic_{item_type.capitalize()}17.png"
            else:
                continue
                
            update_texture_in_file(file_path, texture_path)

if __name__ == '__main__':
    base_dir = 'src/resources/items/blueprints'
    process_directory(base_dir)
