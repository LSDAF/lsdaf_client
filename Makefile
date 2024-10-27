default: help


install-pre-commit:
	python3 -m venv .venv && source .venv/bin/activate
	pre-commit clean
	pre-commit install

install-venv:
	python3 -m venv .venv && source .venv/bin/activate
	pip install -r requirements.txt

help:
	@echo "> install-pre-commit   |----------------------------------|  Install pre-commit hooks"
	@echo "> install-venv         |----------------------------------|  Install virtual environment"