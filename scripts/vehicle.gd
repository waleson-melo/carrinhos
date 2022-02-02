extends VehicleBody

onready var ativo = get_parent()

var steer_target = 0

export var engine_force_value = 40
export var STEER_SPEED = 1.5
export var STEER_LIMIT = 0.9
export var invert_direction = true

func _ready():
	if !ativo.status_veiculo:
		set_process(false)


func _process(delta):
	var fwd_mps = transform.basis.xform_inv(linear_velocity).x

	if invert_direction:
		steer_target = -Input.get_action_strength("turn_left") + Input.get_action_strength("turn_right")
	else:
		steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")		
	
	steer_target *= STEER_LIMIT

	if Input.is_action_pressed("accelerate") and not Input.is_action_pressed("brake"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed = linear_velocity.length()
		if speed < 5 and speed != 0:
			engine_force = clamp(engine_force_value * 5 / speed, 0, 100)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0

	if Input.is_action_pressed("reverse") and not Input.is_action_pressed("brake"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			var speed = linear_velocity.length()
			if speed < 5 and speed != 0:
				engine_force = -clamp(engine_force_value * 5 / speed, 0, 100)
			else:
				engine_force = -engine_force_value
		else:
			brake = 1
	else:
		brake = 0.0
	
	if Input.is_action_pressed("brake"):
		brake = 2.0

	steering = move_toward(steering, steer_target, STEER_SPEED * delta)
	
