#!/usr/bin/env python3
import os
import re
import sys
import argparse
from pathlib import Path
from typing import Set, Dict, List, Tuple

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
        r'path="(res://[^"]+\.(png|jpg|jpeg|svg|ttf|wav|mp3|ogg))"'
    ]
    
    print("\nSearching in directories:")
    for directory in search_dirs:
        print(f"- {directory}")
        for root, _, files in os.walk(directory):
            for file in files:
                if not file.endswith(('.gd', '.tres', '.tscn')):
                    continue
                    
                file_path = os.path.join(root, file)
                try:
                    print(f"Searching file: {file_path}")
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        
                    for pattern in patterns:
                        matches = re.finditer(pattern, content)
                        for match in matches:
                            # Use the capture group
                            path = match.group(1)
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

def delete_unused_assets(unused_assets: Set[str], project_root: str) -> Tuple[int, List[str]]:
    """Delete the unused asset files and their .import files. Returns count of deleted files and errors."""
    deleted_count = 0
    errors = []
    
    for asset in unused_assets:
        # Convert res:// path to filesystem path
        file_path = os.path.join(project_root, asset.replace('res://', ''))
        import_path = file_path + '.import'
        
        # Delete the asset file
        try:
            if os.path.exists(file_path):
                os.remove(file_path)
                deleted_count += 1
        except Exception as e:
            errors.append(f"Failed to delete {file_path}: {e}")
            
        # Delete the .import file if it exists
        try:
            if os.path.exists(import_path):
                os.remove(import_path)
                deleted_count += 1
        except Exception as e:
            errors.append(f"Failed to delete {import_path}: {e}")
    
    return deleted_count, errors

def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description='Find and optionally delete unused assets in the project.')
    parser.add_argument('--fix', action='store_true', help='Delete unused assets')
    parser.add_argument('--no-interactive', action='store_true', help='Skip confirmation prompts')
    args = parser.parse_args()
    
    # Directories to search in
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
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
    
    # Find unused assets (excluding .import files from the report)
    unused_assets = {asset for asset in all_assets - references if not asset.endswith('.import')}
    
    # Group and display unused assets if any
    if unused_assets:
        print(f"\nFound {len(unused_assets)} unused assets:")
        grouped = group_unused_assets(unused_assets)
        
        for group, assets in sorted(grouped.items()):
            print(f"\n{group}/ ({len(assets)} files):")
            for asset in sorted(assets):
                print(f"  {asset}")
        
        # Delete files if --fix is specified
        if args.fix:
            # Ask for confirmation in interactive mode
            if not args.no_interactive and sys.stdin.isatty():
                response = input(f"\nDo you want to delete {len(unused_assets)} unused assets? [y/N] ")
                if response.lower() != 'y':
                    print("\nAborted.")
                    return 1
            
            deleted_count, errors = delete_unused_assets(unused_assets, project_root)
            
            # Report results
            print(f"\nDeleted {deleted_count} unused assets")
            if errors:
                print("\nErrors occurred:")
                for error in errors:
                    print(f"  {error}")
    
    # Print final status
    print("\n" + "=" * 60)
    if not unused_assets:
        print("✅ SUCCESS: No unused assets found!")
        return 0
    else:
        if args.fix:
            print(f"❌ FAILURE: Found {len(unused_assets)} unused assets and attempted to delete them")
        else:
            print(f"❌ FAILURE: Found {len(unused_assets)} unused assets")
        return 1

if __name__ == '__main__':
    exit(main())
