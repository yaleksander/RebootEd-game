extends CharacterBody2D

@export var speed = 50
@export var move_distance = 16

var amount_moved = 0

func player_action(_player_node, direction):
	if (amount_moved == 0):
		velocity = Vector2(0, 0)
		if (direction == "down"):
			velocity.y = speed
		elif (direction == "left"):
			velocity.x = -speed
		elif (direction == "right"):
			velocity.x = speed
		elif (direction == "up"):
			velocity.y = -speed
		print("received!")

func _physics_process(_delta):
	amount_moved += velocity.length() * _delta
	if (amount_moved >= move_distance):
		amount_moved = 0
	move_and_slide()
	if (amount_moved == 0):
		velocity = Vector2(0, 0)
