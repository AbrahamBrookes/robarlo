class_name PlayerCameraPivot
extends Node3D

@onready var player = $"../PlayerCharacter"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# lock the pivot location to the players location
	# in the future this can be smoothed or whatever
	transform.origin = player.transform.origin
	pass
