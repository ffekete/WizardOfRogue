extends Area2D

signal hit

export var speed = 0.75

onready var tween = $Tween
onready var ray = $RayCast2D
onready var attack_timer = $AttackTimer

var tile_size = Global.grid_size
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.flip_h = false
	start(Vector2(0,0))
	$AnimatedSprite.play()
	attack_timer.one_shot = true

func _process(delta):

	if(tween.is_active() || !attack_timer.is_stopped()):
		return

	if(Input.is_action_pressed("ui_up")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["up"])
		$AnimatedSprite.flip_v = true
		$AnimatedSprite.rotation_degrees = 270
		$AnimatedSprite.flip_h = false
		
	elif(Input.is_action_pressed("ui_down")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["down"])
		$AnimatedSprite.rotation_degrees =  90
		$AnimatedSprite.flip_h = false
		
	elif(Input.is_action_pressed("ui_left")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["left"])
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = true
		
		
	elif(Input.is_action_pressed("ui_right")):
		$AnimatedSprite.animation = "walk"
		move_with_collision_check(Global.inputs["right"])
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = false
		
		
	elif(Input.is_action_pressed("ui_fire")):
		if(attack_timer.is_stopped()):
			$AnimatedSprite.animation = "attack"
			attack_timer.start(0.5)
			print("feuer")
		
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
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	show()
	$CollisionShape2D.disabled = false

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func _on_AttackTimer_timeout():
	$AnimatedSprite.animation = "idle"
	
