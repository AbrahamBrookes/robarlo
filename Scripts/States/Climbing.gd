extends State
class_name Climbing

# This state is entered when the player is close enough to a wall to grab it.
# Grabbing a wall can be done in almost any state

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var climbing_speed = 10
@export var lerp_speed = 0.3

# our wall grab raycast node
@onready var wall_grab_ray : RayCast3D = owner.get_node("PlayerCharacter/WallGrabRayCast3D")


func Enter(extra_data = null):
	stateMachine.travel("Climbing")

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	
	if playerCharacter.is_on_floor():
		# player has hit the ground, transition back to locomote
		Transitioned.emit("Locomote")
		return
	
	check_wall_in_reach()
	
	# if the player presses jump, jump
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit("Jumping")

	do_climb_wall_motion()


	#animTree.set("parameters/StateMachine/Locomote/blend_position", playerCharacter.velocity.length() / air_speed)
func do_climb_wall_motion():
		# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("walk_west", "walk_east", "walk_north", "walk_south")
	
	if input_dir:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, input_dir.x * climbing_speed, lerp_speed)
		playerCharacter.velocity.y = lerp(playerCharacter.velocity.y, input_dir.y * -climbing_speed, lerp_speed)
	else:
		playerCharacter.velocity.x = lerp(playerCharacter.velocity.x, 0.0, lerp_speed)
		playerCharacter.velocity.y = lerp(playerCharacter.velocity.y, 0.0, lerp_speed)

# if the wall is no longer in reach, fall
func check_wall_in_reach():
	# if the WallGrabRayCast3D note intersects with a wall, grab the wall
	if(!wall_grab_ray.is_colliding()):
		Transitioned.emit("Locomote")
