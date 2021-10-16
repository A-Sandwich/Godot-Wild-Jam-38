extends CanvasLayer


func _ready():
	pass


func _on_Timer_timeout():
	$AnimationPlayer.play("fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://TitleScreenNode2D.tscn")
