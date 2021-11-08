extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var audio_player

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player = $AudioStreamPlayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_audio_player():
	return audio_player
