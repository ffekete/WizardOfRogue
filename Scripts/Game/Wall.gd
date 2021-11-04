extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func remove_collision(dir):
	if(dir == "left"):
		$LeftCollisionShape.disabled = true
		
	if(dir == "right"):
		$RightCollisionShape.disabled = true
		
	if(dir == "top"):
		$TopCollisionShape.disabled = true
		
	if(dir == "bottom"):
		$BottomCollisionShape.disabled = true

func set_animation(animation):
	$AnimatedSprite.animation = animation
