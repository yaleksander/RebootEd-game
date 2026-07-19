extends Node2D

@onready var b1 = $Button1
@onready var b2 = $Button2
@onready var b3 = $Button3
@onready var b4 = $Button4
@onready var b5 = $Button5
@onready var b6 = $Button6
@onready var led = $LED
@onready var player = $Player

func _ready():
	led.play("on" if GlobalVariables.get_field("box_puzzle_done") else "off")

func _process(_delta):
	if (b1.is_on() && b2.is_on() && b3.is_on() && b4.is_on() && b5.is_on() && b6.is_on()):
		GlobalVariables.set_field("box_puzzle_done", true)
		led.play("on")
