class_name MobScaler
extends Resource

@export var attack_poln_coef_2: float
@export var attack_poln_coef_1: float
@export var attack_poln_coef_0: int

@export var hp_poln_coef_2: float
@export var hp_poln_coef_1: float
@export var hp_poln_coef_0: int


func attack_from_difficulty(difficulty: float) -> int:
	var result: float = (
		attack_poln_coef_2 * (pow(difficulty, 2))
		+ attack_poln_coef_1 * difficulty
		+ attack_poln_coef_0
	)
	return result


func hp_from_difficulty(difficulty: float) -> int:
	var result: float = (
		hp_poln_coef_2 * (pow(difficulty, 2)) + hp_poln_coef_1 * difficulty + hp_poln_coef_0
	)
	return result
