extends Node2D

export (PackedScene) var Bullet
export (PackedScene) var Main

export var attack_speed = 0.5
export var max_ammo = 2
export var reload_speed = 2
export var ammo = 0
export var randomness = 3.0

func _ready():
	pass # Replace with function body.

func _shoot(position, currentDir, parent):
	ammo -= 1
	
	add_bullet(0.1, position, currentDir, parent)
	add_bullet(-0.1, position, currentDir, parent)
	add_bullet(0.2, position, currentDir, parent)
	add_bullet(-0.2, position, currentDir, parent)
	
func add_bullet(spread, position, currentDir, parent):
	
	var bullet = Bullet.instance()
	bullet.position.x = position.x
	bullet.position.y = position.y
	parent.add_child(bullet)
	bullet.set_speed(150)
	
	var direction
	
	if(currentDir == "up"):
		direction = Vector2(0 + randf() / randomness - 1 / randomness / 2.0 + spread, -1)
		bullet.rotation_degrees = 90.0
	
	if(currentDir == "down"):
		direction = Vector2(0 + randf() / randomness - 1 / randomness / 2.0 + spread, 1)
		bullet.rotation_degrees = 270.0
		
	if(currentDir == "right"):
		direction = Vector2(1, 0 + randf() / randomness - 1 / randomness / 2.0 + spread)
		bullet.rotation_degrees = 0.0
	
	if(currentDir == "left"):
		direction = Vector2(-1, 0 + randf() / randomness - 1 / randomness / 2.0 + spread)
		bullet.rotation_degrees = 180.0
	
	bullet.set_direction(direction)
	bullet.set_position(position)
	bullet.start()
	
func reload_finished():
	$AudioStreamPlayer.play()
