SHELL := /bin/bash

default: help

format:
	gdformat .

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

help:
	@echo "> format               |----------------------------------|  Apply gdformat to all files"
	@echo "> install-pre-commit   |----------------------------------|  Install pre-commit hooks"
	@echo "> install-venv-help    |----------------------------------|  Show help to install virtual environment"
	@echo "> lint                 |----------------------------------|  Run gdlint on all files"
