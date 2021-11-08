extends Node2D

export (PackedScene) var Bullet
export (PackedScene) var Main

export var attack_speed = 0.3
export var max_ammo = 5
export var reload_speed = 1
export var ammo = 0

func _ready():
	pass # Replace with function body.

func _shoot(position, currentDir, parent):
	var bullet = Bullet.instance()
	bullet.position.x = position.x
	bullet.position.y = position.y
	parent.add_child(bullet)
	bullet.set_speed(150)
	ammo -= 1
	
	var direction
	
	if(currentDir == "up"):
		direction = Vector2(0, -1)
		bullet.rotation_degrees = 90.0
	
	if(currentDir == "down"):
		direction = Vector2(0, 1)
		bullet.rotation_degrees = 270.0
		
	if(currentDir == "right"):
		direction = Vector2(1, 0)
		bullet.rotation_degrees = 0.0
	
	if(currentDir == "left"):
		direction = Vector2(-1, 0)
		bullet.rotation_degrees = 180.0
	
	bullet.set_direction(direction)
	bullet.set_position(position)
	bullet.start()
	
func reload_finished():
	$AudioStreamPlayer.play()
