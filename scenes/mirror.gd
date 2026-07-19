extends CharacterBody2D

@onready var _animated_sprite = $MirrorSprite

var state = true

func player_interact():
	_animated_sprite.play("principal" if state else "secundaria")
	state = !state

func _physics_process(_delta: float) -> void:
	pass
