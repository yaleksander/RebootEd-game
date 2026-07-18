extends CharacterBody2D

const audio_move1 = preload("res://sounds/move1 - start.mp3")
const audio_move2 = preload("res://sounds/move2 - loop.mp3")
const audio_move3 = preload("res://sounds/move3 - finish.mp3")

var was_moving = false

@export var speed = 200
@export var _map : TileMapLayer

@onready var _animated_sprite = $PlayerAnimatedSprite
@onready var _audio_player = $PlayerWalkSound

func _ready():
	_audio_player.finished.connect(func(): loop_walk_sound())

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func animate():
	if (abs(velocity.x) > abs(velocity.y)):
		if (velocity.x < 0):
			_animated_sprite.play("walk left")
		else:
			_animated_sprite.play("walk right")
	elif (abs(velocity.x) < abs(velocity.y)):
		if (velocity.y < 0):
			_animated_sprite.play("walk up")
		else:
			_animated_sprite.play("walk down")
	else:
		_animated_sprite.stop()

func get_map_data():
	if (_map.get_cell_tile_data(_map.local_to_map(position)).get_custom_data("dirt")):
		velocity /= 2.0

func loop_walk_sound():
	if (velocity.x != 0 || velocity.y != 0):
		_audio_player.set_stream(audio_move2)
		_audio_player.play()

func walk_sound():
	if (velocity.x != 0 || velocity.y != 0):
		if (!was_moving):
			_audio_player.set_stream(audio_move1)
			_audio_player.play()
		was_moving = true
	elif (was_moving):
		_audio_player.set_stream(audio_move3)
		_audio_player.play()
		was_moving = false

func _physics_process(_delta):
	get_input()
	get_map_data()
	animate()
	walk_sound()
	move_and_slide()
