# How to use gdscript-toolkit
https://github.com/Scony/godot-gdscript-toolkit

1. Generate a venv using https://packaging.python.org/en/latest/guides/installing-using-pip-and-virtual-environments/#create-a-new-virtual-environment

2. Once you have a `.venv` folder, activate it, and run 
```pip install -r /path/to/requirements.txt```

3. Check https://github.com/Scony/godot-gdscript-toolkit for more usage details

4. If by running something you have this error : 
```ModuleNotFoundError: No module named 'pkg_resources'```
Refer to https://github.com/ManimCommunity/manim/issues/3585 and run
```pip install setuptools```