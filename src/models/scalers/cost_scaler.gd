class_name CostScaler
extends Resource

# From this idea https://stackoverflow.com/questions/76700683/what-formulas-to-use-for-clicker-incremental-games
@export var cost_poln_coef_2: float
@export var cost_poln_coef_1: float
@export var cost_poln_coef_0: int


func cost_from_level(level: int) -> int:
	return cost_poln_coef_2 * (pow(level, 2)) + cost_poln_coef_1 * level + cost_poln_coef_0
