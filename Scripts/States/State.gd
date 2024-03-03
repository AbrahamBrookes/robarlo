extends Node
class_name State

signal Transitioned

@onready var playerCharacter : CharacterBody3D = owner.get_node("PlayerCharacter")
@onready var animTree = owner.get_node("PlayerCharacter/SkinnedMesh/AnimationTree")
@onready var stateMachine = animTree.get("parameters/StateMachine/playback")

func Enter(extra_data = null):
	pass


func Exit():
	pass


func Update(_delta: float):
	pass


func Physics_Update(_delta: float):
	pass 
