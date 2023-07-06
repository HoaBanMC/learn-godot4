extends Node2D

var can_control = true

func _on_control_gui_input(event):
	if event is InputEventMouseButton and can_control:
		if event.is_action_pressed("click"):
			$AnimationPlayer.play('flip')


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "flip":
		if !get_parent().open_cards.has(self):
			can_control = false
			get_parent().open_cards.append(self)
			get_parent().check()

