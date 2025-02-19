SHELL := /bin/bash

default: help

format:
	gdformat .

find-format-error:
	find . -name "*.gd" -not -path "./addons/*" -exec sh -c 'echo "Formatting {}" && gdformat {}' \;

install-pre-commit:
	pre-commit clean
	pre-commit install

install-venv-help:
	@echo 'Run the following commands to install the virtual environment:'
	@echo 'python3 -m venv .venv'
	@echo 'source .venv/bin/activate'
	@echo 'pip install -r requirements.txt'

lint:
	gdlint .

tests-github-actions:
	godot --headless -s addons/gut/gut_cmdln.gd -gconfig=.gutconfig.github-actions.json

tests:
	godot --headless -s addons/gut/gut_cmdln.gd -gconfig=.gutconfig.default.json

# Run a specific test file
# Usage: make test TEST_FILE=res://src/store/reactive_store/__tests__/reactive_store_test.gd
test:
	godot --headless -s addons/gut/gut_cmdln.gd -gexit -gtest=$(TEST_FILE)

help:
	@echo "> format               |----------------------------------|  Apply gdformat to all files"
	@echo "> install-pre-commit   |----------------------------------|  Install pre-commit hooks"
	@echo "> install-venv-help    |----------------------------------|  Show help to install virtual environment"
	@echo "> lint                 |----------------------------------|  Run gdlint on all files"
	@echo "> tests-github-actions |----------------------------------|  Run all tests (for github actions)"
	@echo "> tests                |----------------------------------|  Run all tests"
	@echo "> test                 |----------------------------------|  Run a test file (suffix with the test script location)"