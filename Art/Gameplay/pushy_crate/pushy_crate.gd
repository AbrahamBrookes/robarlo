extends CharacterBody3D
class_name pushy_crate

var speed = 1
var destination = Vector3.ZERO
var moving = false
var can_be_pushed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# on start, snap location to rounded numbers or pushing won't work
	position = position.round()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	move_and_slide()

	# if we have reached our destination, stop moving
	if position.distance_to(destination) < 0.01:
		velocity = Vector3.ZERO

# get pushed! push_dir is a vector2 (1, -1) that was the input direction
func push(push_dir: Vector2):
	if can_be_pushed and push_dir != Vector2.ZERO and velocity == Vector3.ZERO:
		var push_vector = Vector3(push_dir.x, 0, push_dir.y)
		destination = position + push_vector
		velocity = push_vector.normalized()


