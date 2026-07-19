extends CharacterBody2D

@export var speed = 50
@export var grid_size = 16.0

var amount_moved = 0

func player_interact():
	print("interact!")

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

func _physics_process(_delta):
	if (velocity != Vector2.ZERO):
		amount_moved += velocity.length() * _delta
		move_and_slide()
		if (velocity.length() == 0 || amount_moved >= grid_size):
			amount_moved = 0
			velocity = Vector2.ZERO
			position.x = (floor(position.x / grid_size) + 0.5) * grid_size
			position.y = (floor(position.y / grid_size) + 0.5) * grid_size
