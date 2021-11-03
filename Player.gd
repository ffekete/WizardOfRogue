extends Area2D

signal hit

export var speed = 0.75

onready var tween = $Tween
onready var ray = $RayCast2D
onready var attack_timer = $AttackTimer

var tile_size = Global.grid_size
var screen_size
var next_dir

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.play()
	attack_timer.one_shot = true

func _process(delta):

	if(tween.is_active()):
		return


	if(Input.is_action_pressed("ui_fire")):
		if(attack_timer.is_stopped()):
			$AnimatedSprite.animation = "attack"
			attack_timer.start(0.5)
		
			if(next_dir == Vector2.UP):
				$AnimatedSprite.flip_v = true
				$AnimatedSprite.rotation_degrees = 270
				$AnimatedSprite.flip_h = false
				
			if(next_dir == Vector2.DOWN):
				$AnimatedSprite.rotation_degrees =  90
				$AnimatedSprite.flip_h = false	
				
			if(next_dir == Vector2.LEFT):
				$AnimatedSprite.rotation_degrees = 0
				$AnimatedSprite.flip_v = false
				$AnimatedSprite.flip_h = true
		
			if(next_dir == Vector2.RIGHT):
				$AnimatedSprite.rotation_degrees = 0
				$AnimatedSprite.flip_v = false
				$AnimatedSprite.flip_h = false
		else:
			if(Input.is_action_pressed("ui_up")):
				next_dir = Vector2.UP
				
			if(Input.is_action_pressed("ui_down")):
				next_dir = Vector2.DOWN
				
			if(Input.is_action_pressed("ui_left")):
				next_dir = Vector2.LEFT
		
			if(Input.is_action_pressed("ui_right")):
				next_dir = Vector2.RIGHT
			
	if(!attack_timer.is_stopped()):
		return
			
	if(Input.is_action_pressed("ui_up")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["up"])
		$AnimatedSprite.flip_v = true
		$AnimatedSprite.rotation_degrees = 270
		$AnimatedSprite.flip_h = false
		next_dir = Vector2.UP
		
	elif(Input.is_action_pressed("ui_down")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["down"])
		$AnimatedSprite.rotation_degrees =  90
		$AnimatedSprite.flip_h = false
		next_dir = Vector2.DOWN
		
	elif(Input.is_action_pressed("ui_left")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["left"])
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = true
		next_dir = Vector2.LEFT
		
		
	elif(Input.is_action_pressed("ui_right")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["right"])
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false
		next_dir = Vector2.RIGHT
		
		
	elif(Input.is_action_pressed("ui_fire")):
		if(attack_timer.is_stopped()):
			$AnimatedSprite.animation = "attack"
			attack_timer.start(0.5)
		
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
	
