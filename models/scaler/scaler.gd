class_name Scaler
extends Resource

# From this idea https://stackoverflow.com/questions/76700683/what-formulas-to-use-for-clicker-incremental-games
@export var attack_exponent: float
@export var attack_coef: float
@export var attack_base: int

@export var hp_exponent: float
@export var hp_coef: float
@export var hp_base: int

func attack_from_difficulty(difficulty: float) -> int:
	return attack_coef * (difficulty ** attack_exponent) + attack_base

func hp_from_difficulty(difficulty: float) -> int:
	return hp_coef * (difficulty ** hp_exponent) + hp_base
