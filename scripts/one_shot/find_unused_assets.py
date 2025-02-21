#!/usr/bin/env python3
import os
import re
from pathlib import Path
from typing import Set, Dict, List

def find_all_assets(asset_dir: str) -> Set[str]:
    """Find all asset files in the asset directory."""
    # Common Godot asset extensions
    ASSET_EXTENSIONS = {
        '.png', '.jpg', '.jpeg', '.svg',  # Images
        '.wav', '.mp3', '.ogg',          # Audio
        '.ttf', '.otf',                  # Fonts
        '.import'                        # Godot import files
    }
    
    assets = set()
    for root, _, files in os.walk(asset_dir):
        for file in files:
            # Skip hidden files
            if file.startswith('.'):
                continue
                
            # Only include files with asset extensions
            if not any(file.endswith(ext) for ext in ASSET_EXTENSIONS):
                continue
                
            # Get the path relative to the project root
            rel_path = os.path.relpath(os.path.join(root, file), os.path.dirname(asset_dir))
            # Convert to res:// format
            res_path = f"res://{rel_path}"
            assets.add(res_path)
    return assets

def find_asset_references(search_dirs: List[str]) -> Set[str]:
    """Find all asset references in .gd, .tres, and .tscn files."""
    references = set()
    
    # Patterns to match asset references
    patterns = [
        r'res://[^"\')\s]+\.(png|jpg|jpeg|svg|ttf|wav|mp3|ogg)',  # Direct references
        r'load\(["\']res://[^"\']+\.(png|jpg|jpeg|svg|ttf|wav|mp3|ogg)["\']',  # load() calls
        r'preload\(["\']res://[^"\']+\.(png|jpg|jpeg|svg|ttf|wav|mp3|ogg)["\']',  # preload() calls
        r'path\s*=\s*["\']res://[^"\']+\.(png|jpg|jpeg|svg|ttf|wav|mp3|ogg)["\']',  # path assignments
    ]
    
    for directory in search_dirs:
        for root, _, files in os.walk(directory):
            for file in files:
                if not file.endswith(('.gd', '.tres', '.tscn')):
                    continue
                    
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        
                    for pattern in patterns:
                        matches = re.finditer(pattern, content)
                        for match in matches:
                            # Extract just the res:// path
                            path = re.search(r'res://[^"\')\s]+', match.group(0)).group(0)
                            references.add(path)
                except Exception as e:
                    print(f"Error reading {file_path}: {e}")
    
    return references

def group_unused_assets(unused_assets: Set[str]) -> Dict[str, List[str]]:
    """Group unused assets by their type/directory."""
    grouped = {}
    for asset in unused_assets:
        # Remove res:// prefix and split path
        parts = asset.replace('res://', '').split('/')
        if len(parts) > 1:
            # Use the first directory as group
            group = parts[0]
        else:
            group = 'root'
        
        if group not in grouped:
            grouped[group] = []
        grouped[group].append(asset)
    
    return grouped

def main():
    # Directories to search in
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
    asset_dir = os.path.join(project_root, 'asset')
    search_dirs = [
        os.path.join(project_root, 'src'),
        os.path.join(project_root, 'asset'),
        os.path.join(project_root, 'addons'),
    ]
    
    print("Finding all assets...")
    all_assets = find_all_assets(asset_dir)
    print(f"Found {len(all_assets)} assets")
    
    print("\nSearching for asset references...")
    references = find_asset_references(search_dirs)
    print(f"Found {len(references)} asset references")
    
    # Find unused assets
    unused_assets = all_assets - references
    
    # Group and display unused assets if any
    if unused_assets:
        print(f"\nFound {len(unused_assets)} unused assets:")
        grouped = group_unused_assets(unused_assets)
        
        for group, assets in sorted(grouped.items()):
            print(f"\n{group}/ ({len(assets)} files):")
            for asset in sorted(assets):
                print(f"  {asset}")
    
    # Print final status
    print("\n" + "=" * 60)
    if not unused_assets:
        print("✅ SUCCESS: No unused assets found!")
        return 0
    else:
        print(f"❌ FAILURE: Found {len(unused_assets)} unused assets")
        return 1

if __name__ == '__main__':
    exit(main())
