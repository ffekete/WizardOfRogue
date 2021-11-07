extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_AnimatedSprite_animation_finished():
	get_parent().remove_child(self)
