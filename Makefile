default: help

format:
	source .venv/bin/activate && gdformat .

help:
	@echo "> format               |----------------------------------|  Apply gdformat to all files"
