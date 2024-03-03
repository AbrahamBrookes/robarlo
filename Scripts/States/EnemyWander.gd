extends State
class_name EnemyWander

@export var enemy: CharacterBody3D
@export var move_speed := 10.0

var move_direction : Vector3
var wander_time : float

func randomize_wander():
	move_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
	wander_time = randf_range(1.0, 3.0)

func Enter(extra_data = null):
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta

	else:
		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity = move_direction * move_speed

 
