extends CharacterBody2D

const box_slide_sfx = preload("res://sounds/stone_pushing.ogg")

@export var speed = 50
@export var grid_size = 16.0

@onready var box_slide_player = $AudioStreamPlayer

var amount_moved = 0

func _ready():
	box_slide_player.stream = box_slide_sfx

func player_push(direction):
	if (amount_moved == 0):
		velocity = Vector2.ZERO
		if (direction == "down"):
			velocity.y = speed
		elif (direction == "left"):
			velocity.x = -speed
		elif (direction == "right"):
			velocity.x = speed
		elif (direction == "up"):
			velocity.y = -speed
		
		if velocity != Vector2.ZERO and is_instance_valid(box_slide_player):
			if not box_slide_player.playing:
				box_slide_player.play()

func _physics_process(_delta):
	if (velocity != Vector2.ZERO):
		amount_moved += velocity.length() * _delta
		move_and_slide()
		
		if (velocity.length() == 0 || amount_moved >= grid_size):
			amount_moved = 0
			velocity = Vector2.ZERO
			position.x = (floor(position.x / grid_size) + 0.5) * grid_size
			position.y = (floor(position.y / grid_size) + 0.5) * grid_size
			
			if is_instance_valid(box_slide_player) and box_slide_player.playing:
				box_slide_player.stop()
