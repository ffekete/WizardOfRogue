extends Area2D

signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 30
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite.flip_h = false
	$AnimatedSprite.offset.x = 16


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite.play()
	var velocity = Vector2()
	
	if(Input.is_action_pressed("ui_up")):
		$AnimatedSprite.animation = "walk"
		velocity.y = -1
	elif(Input.is_action_pressed("ui_down")):
		velocity.y = 1
	elif(Input.is_action_pressed("ui_left")):
		velocity.x -= 1
	elif(Input.is_action_pressed("ui_right")):
		velocity.x += 1
	
	if(velocity.length() > 0):
			velocity = velocity.normalized() * speed
			$AnimatedSprite.animation = "walk"
			$AnimatedSprite.flip_h = velocity.x < 0
			position += velocity * delta
	else:
		$AnimatedSprite.animation = "idle"

