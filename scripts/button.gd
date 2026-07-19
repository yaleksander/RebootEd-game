extends CharacterBody2D

@onready var _detect = $Area2D
@onready var _anim = $AnimatedSprite2D

var state = false

func is_on():
	return state

func _process(delta: float) -> void:
	if (_detect.get_overlapping_bodies().size() > 0):
		_anim.play("on")
		state = true
	else:
		_anim.play("off")
		state = false
