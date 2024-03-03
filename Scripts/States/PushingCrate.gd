extends State
# After leaning up against a pushble object (see the LeaningCrate state), the
# player will push the crate one grid square
class_name PushingCrate

var crate # the crate we are pushing

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mass = 10.0

@export var SPEED = 1.8
@export var LERP_SPEED = 0.15
var destination = Vector3.ZERO
var push_dir = Vector2.ZERO # cache the push dir so we can check if it changed
var push_vector = Vector3.ZERO # a vector3 representing the direction we are pushing

func Enter(extra_data = null):
	assert(!!extra_data, "we need to be passed a crate to push!")
	crate = extra_data
	stateMachine.travel("pushing_pushable")
	# cache the push_dir
	push_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south").round()
	# calculate where we'll be pushing to
	push_vector = Vector3(push_dir.x, 0, push_dir.y)
	destination = playerCharacter.position + push_vector
	playerCharacter.velocity = push_vector.normalized()


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	# if the crate has reached its destination, stop moving
	if crate.velocity == Vector3.ZERO:
		playerCharacter.velocity = Vector3.ZERO
		Transitioned.emit('Locomote')
	

