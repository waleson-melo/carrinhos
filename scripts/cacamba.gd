extends Generic6DOFJoint

onready var cacamba : VehicleBody = get_parent().get_node("cacamba")
onready var tampa : Generic6DOFJoint = get_parent().get_node("joint_tampa")

var lower_limite_angular_tampa : float = -96
var limite_angular_upper_cacamba : float = 1.0
var limite_angular_lower_cacamba : float = 0
var pa : float = 0


func _ready() -> void:
	# Fechando a tampa
	tampa.set_param_x(PARAM_ANGULAR_LOWER_LIMIT, 0)


func _process(delta) -> void:
	# Pega a flag da cabamba quanto ela esta ativa
	if cacamba.ativo:
		# Liga e Desliga a tranca da tampa da cacamba
		if Input.is_action_just_pressed("track"):
			if tampa.get_param_x(PARAM_ANGULAR_LOWER_LIMIT) != lower_limite_angular_tampa:
				tampa.set_param_x(PARAM_ANGULAR_LOWER_LIMIT, lower_limite_angular_tampa)
			else:
				tampa.set_param_x(PARAM_ANGULAR_LOWER_LIMIT, 0)

		pa = (Input.get_action_strength("pa_up") - Input.get_action_strength("pa_down"))
		
		if pa != 0:
			if pa > 0 and get_param_x(PARAM_ANGULAR_UPPER_LIMIT) < limite_angular_upper_cacamba:
				set_param_x(PARAM_ANGULAR_UPPER_LIMIT, get_param_x(PARAM_ANGULAR_UPPER_LIMIT) + delta)
				set_param_x(PARAM_ANGULAR_LOWER_LIMIT, get_param_x(PARAM_ANGULAR_LOWER_LIMIT) + delta)
			elif  pa < 0 and get_param_x(PARAM_ANGULAR_UPPER_LIMIT) > limite_angular_lower_cacamba:
				set_param_x(PARAM_ANGULAR_LOWER_LIMIT, get_param_x(PARAM_ANGULAR_LOWER_LIMIT) - delta)
				set_param_x(PARAM_ANGULAR_UPPER_LIMIT, get_param_x(PARAM_ANGULAR_UPPER_LIMIT) - delta)
