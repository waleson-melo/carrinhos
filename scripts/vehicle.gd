extends VehicleBody

# usado em alguns filhos, como cacamba do caminhao e na pa da empilhadeira
var ativo : bool = false

var steer_target: float = 0

export var engine_force_value : float = 40
export var STEER_SPEED : float = 1.5
export var STEER_LIMIT : float = 0.9
export var invert_direction : bool = true


func _process(delta) -> void:
	var vehicle : VehicleBody = Global.veiculos[Global.curent_veiculo].get_children()[0]

	if get_instance_id() != vehicle.get_instance_id():
		ativo = false
		set_process(false)
	else:
		ativo = true
	
	var fwd_mps : float = transform.basis.xform_inv(linear_velocity).x

	if invert_direction:
		steer_target = -Input.get_action_strength("turn_left") + Input.get_action_strength("turn_right")
	else:
		steer_target = Input.get_action_strength("turn_left") - Input.get_action_strength("turn_right")		
	
	steer_target *= STEER_LIMIT

	if Input.is_action_pressed("accelerate") and not Input.is_action_pressed("brake"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		var speed : float = linear_velocity.length()
		if speed < 5 and speed != 0:
			engine_force = clamp(engine_force_value * 5 / speed, 0, 100)
		else:
			engine_force = engine_force_value
	else:
		engine_force = 0

	if Input.is_action_pressed("reverse") and not Input.is_action_pressed("brake"):
		# Increase engine force at low speeds to make the initial acceleration faster.
		if fwd_mps >= -1:
			var speed : float = linear_velocity.length()
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
	
