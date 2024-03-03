extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(other):
	# if the player enters the area, we want to hurt() them
	if other is PlayerCharacter:
		other.hurt(1, global_transform.origin)
	
	pass # Replace with function body.
