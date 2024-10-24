extends Node

# CAUTION: Ideally, only use this class for:
# - events that are not related to a specific scene
# - events that come from static functions, like from services

signal current_stage_update(new_stage: int)
signal current_wave_update(new_wave: int)
signal inventory_update
signal quest_update
signal toast(message: String)