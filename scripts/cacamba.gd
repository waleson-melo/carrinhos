extends Generic6DOFJoint

onready var cacamba = get_parent().get_node("cacamba")
onready var tampa = get_parent().get_node("joint_tampa")
var lower_limite_tampa : float = -96
var joint_slider = self
var pa = 0


func _ready():
	# Fechando a tampa
	tampa.set_param_x(PARAM_ANGULAR_LOWER_LIMIT, 0)


func _process(delta):
	if cacamba.ativo:
		if Input.is_action_just_pressed("track"):
			if tampa.get_param_x(PARAM_ANGULAR_LOWER_LIMIT) != lower_limite_tampa:
				tampa.set_param_x(PARAM_ANGULAR_LOWER_LIMIT, lower_limite_tampa)
			else:
				tampa.set_param_x(PARAM_ANGULAR_LOWER_LIMIT, 0)

		pa = (Input.get_action_strength("pa_up") - Input.get_action_strength("pa_down"))
		
		if pa != 0:
			if pa > 0 and joint_slider.get_param_x(11) < 1.0:
				joint_slider.set_param_x(11, joint_slider.get_param_x(11) + delta)
				joint_slider.set_param_x(10, joint_slider.get_param_x(10) + delta)
			elif  pa < 0 and joint_slider.get_param_x(11) > 0:
				joint_slider.set_param_x(10, joint_slider.get_param_x(10) - delta)
				joint_slider.set_param_x(11, joint_slider.get_param_x(11) - delta)
