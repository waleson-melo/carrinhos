extends RigidBody

export var lower_distance_limit = -1
onready var joint_slider: Joint = get_parent().get_node("joint_slider")

var pa = 0

func _process(delta):
	pa = (Input.get_action_strength("pa_up") - Input.get_action_strength("pa_down"))
	if pa != 0:
		if joint_slider.get_param(1) < joint_slider.get_param(0) and pa > 0:
			joint_slider.set_param(1, joint_slider.get_param(1) + delta)
		elif joint_slider.get_param(1) > lower_distance_limit and pa < 0:
			joint_slider.set_param(1, joint_slider.get_param(1) - delta)
		
		if joint_slider.get_param(1) > joint_slider.get_param(0):
			joint_slider.set_param(1, joint_slider.get_param(0))
