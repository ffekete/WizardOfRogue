extends Area2D

signal hit
signal ammo_changed

var main = load("res://Scenes/Game/Main.tscn")
var laser_rifle = load("res://Scenes/Game/Weapon/LaserRifle.tscn")
var laser_gatling = load("res://Scenes/Game/Weapon/GatlingLaser.tscn")

export var speed = 0.75
export var turn_speed = 0.15

onready var tween = $Tween
onready var ray = $RayCast2D
onready var attack_timer = $AttackTimer
onready var turn_timer = $TurnTimer
onready var reload_timer = $ReloadTimer
onready var reload_anim = $ReloadAnimatedSprite

var tile_size = Global.grid_size
var screen_size
var next_dir
var currentDir

var weapon 

# Called when the node enters the scene tree for the first time.
func _ready():
	
	weapon = laser_gatling.instance()
	
	screen_size = get_viewport_rect().size
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.play()
	attack_timer.one_shot = true
	reload_timer.one_shot = true
	turn_timer.one_shot = true
	currentDir = "right"
	weapon.ammo = weapon.max_ammo
	reload_anim.visible = false

func _process(delta):

	# set up nex direction if already moving to next tile
	if(tween.is_active()):
		if(Input.is_action_pressed("ui_up")):
			next_dir = Vector2.UP
		if(Input.is_action_pressed("ui_down")):
			next_dir = Vector2.DOWN
		if(Input.is_action_pressed("ui_left")):
			next_dir = Vector2.LEFT
		if(Input.is_action_pressed("ui_right")):
			next_dir = Vector2.RIGHT
		return

	# if next direction is already set then position
	if(next_dir != null):
		match(next_dir):
			Vector2.UP:
				_position_up()
			Vector2.DOWN:
				_position_down()
			Vector2.LEFT:
				_position_left()
			_: 
				_position_right()

	# is player firing?
	if(Input.is_action_pressed("ui_fire")):
		if(attack_timer.is_stopped() && reload_timer.is_stopped()):
			
			# there is ammo so shoot
			if(weapon.ammo > 0):
				$AnimatedSprite.animation = "attack"
				var attack_speed = weapon.attack_speed
				attack_timer.start(attack_speed)
				$AnimatedSprite.frames.set_animation_speed("attack", 12)
				$AudioStreamPlayer.play()

				if(next_dir == Vector2.UP):
					_position_up()

				if(next_dir == Vector2.DOWN):
					_position_down()

				if(next_dir == Vector2.LEFT):
					_position_left()

				if(next_dir == Vector2.RIGHT):
					_position_right()

			# no ammo, reload if attack timer is up
			elif(attack_timer.is_stopped()):
				reload_timer.start(weapon.reload_speed)
				weapon.ammo = weapon.max_ammo
				reload_anim.frames.set_animation_speed("default", 5.0 / weapon.reload_speed)
				reload_anim.z_as_relative = false
				reload_anim.z_index = 999
				
				reload_anim.visible = true
				reload_anim.play()
				return
		else:
			if(Input.is_action_pressed("ui_up")):
				next_dir = Vector2.UP
				
			if(Input.is_action_pressed("ui_down")):
				next_dir = Vector2.DOWN
				
			if(Input.is_action_pressed("ui_left")):
				next_dir = Vector2.LEFT
		
			if(Input.is_action_pressed("ui_right")):
				next_dir = Vector2.RIGHT
			
	if((!attack_timer.is_stopped() || !reload_timer.is_stopped()) && Input.is_action_pressed("ui_fire")):
		return
	
	if(Input.is_action_pressed("ui_up")):
		
		if(turn_timer.is_stopped() && currentDir != "up"):
			_position_up()
			turn_timer.start(turn_speed)
			next_dir = Vector2.UP
		else:
			if(turn_timer.is_stopped()):
				$AnimatedSprite.animation = "walk"
				move_with_collision_check(Global.inputs["up"])
				_position_up()
				next_dir = Vector2.UP
		
	elif(Input.is_action_pressed("ui_down")):
		if(turn_timer.is_stopped() && currentDir != "down"):
			_position_down()
			turn_timer.start(turn_speed)
			next_dir = Vector2.DOWN
		else:
			if(turn_timer.is_stopped()):
				$AnimatedSprite.animation = "walk"
				move_with_collision_check(Global.inputs["down"])
				_position_down()
		
	elif(Input.is_action_pressed("ui_left")):
		if(turn_timer.is_stopped() && currentDir != "left"):
			_position_left()
			turn_timer.start(turn_speed)
			next_dir = Vector2.LEFT
		else:
			if(turn_timer.is_stopped()):
				$AnimatedSprite.animation = "walk"
				move_with_collision_check(Global.inputs["left"])
				_position_left()
				next_dir = Vector2.LEFT
		
	elif(Input.is_action_pressed("ui_right")):
		if(turn_timer.is_stopped() && currentDir != "right"):
			_position_right()
			turn_timer.start(turn_speed)
			next_dir = Vector2.RIGHT
		else:
			if(turn_timer.is_stopped()):
				$AnimatedSprite.animation = "walk"
				move_with_collision_check(Global.inputs["right"])
				_position_right()
				next_dir = Vector2.RIGHT
	else:
		if(attack_timer.is_stopped()):
			$AnimatedSprite.animation = "idle"

func move_with_collision_check(dir):
	ray.cast_to = dir * tile_size
	ray.force_raycast_update()
	if(!ray.is_colliding()):
		move(dir)

func move(dir):
	tween.interpolate_property(self, "position", position, position + dir * tile_size, 
		speed)
	tween.start()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func _on_AttackTimer_timeout():
	$AnimatedSprite.animation = "idle"
	
func _position_up():
	$AnimatedSprite.flip_v = true
	$AnimatedSprite.rotation_degrees = 270
	$AnimatedSprite.flip_h = false
	currentDir = "up"
	
func _position_down():
	$AnimatedSprite.rotation_degrees =  90
	$AnimatedSprite.flip_h = false	
	currentDir = "down"
	
func _position_left():
	$AnimatedSprite.rotation_degrees = 0
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.flip_h = true
	currentDir = "left"
	
func _position_right():
	$AnimatedSprite.rotation_degrees = 0
	$AnimatedSprite.flip_v = false
	$AnimatedSprite.flip_h = false
	currentDir = "right"


func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "attack"):
		$AnimatedSprite.animation = "idle"
		_shoot()
		emit_signal("ammo_changed")

func _shoot():
	weapon._shoot(position, currentDir, get_parent())

func _on_ReloadAnimatedSprite_animation_finished():
	reload_anim.visible = false
	reload_anim.stop()
	emit_signal("ammo_changed")
	$ReloadSoundPlayer.play()
