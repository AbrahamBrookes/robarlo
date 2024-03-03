extends State
class_name Jumping

# This state is entered when the player presses the jump key. 
# The player jumps up and then as they arc back down to the floor they
# start to fall. We can use their speed on the Y axis to blend our
# jumping up/falling down animation

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var mass = 10
@export var jump_power = 20
@export var air_speed = 15
@export var LERP_SPEED = 0.35
var number_of_jumps = 0
@export var max_number_of_jumps = 3


func Enter(extra_data = null):
	if( number_of_jumps < max_number_of_jumps ):
		stateMachine.travel("Jumping")
		var force = playerCharacter.velocity
		force.y = jump_power
		playerCharacter.velocity = force
		number_of_jumps += 1

func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	# Add the gravity.
	if not playerCharacter.is_on_floor():
		playerCharacter.velocity.y -= gravity * _delta * mass
		playerCharacter.check_grab_wall()
	else:
		# player has hit the ground, transition back to locomote
		Transitioned.emit("Locomote")
		# and reset num jumps
		number_of_jumps = 0
	
	# if the player presses jump, jump
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit("Jumping")

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	if input_dir:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, input_dir.x * air_speed, LERP_SPEED)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, input_dir.y * air_speed, LERP_SPEED)
		
		# rotate to face direction
		## add the direction to the current position
		var lookat_location = playerCharacter.global_transform.origin + Vector3(input_dir.x, 0, input_dir.y)
		## lookat that location
		playerCharacter.look_at(lookat_location, Vector3.UP)
	else:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, 0.0, LERP_SPEED)
		playerCharacter.velocity.z = lerp(playerCharacter.velocity.z, 0.0, LERP_SPEED)
	
	animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / air_speed)
