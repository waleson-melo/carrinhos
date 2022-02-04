extends VehicleBody

signal veiculo_selecionado(veiculo, ativo)

# usado em alguns filhos, como cacamba do caminhao e na pa da empilhadeira
var ativo : bool = false

var steer_target: float = 0

export var engine_force_value : float = 40
export var STEER_SPEED : float = 1.5
export var STEER_LIMIT : float = 0.9
export var invert_direction : bool = true


func _ready() -> void:
	var acessorios : Array = get_tree().get_nodes_in_group('acessorio_veiculo')
	# Conectando o sinao aos acessorios
	for acessorio in acessorios:
		# warning-ignore:return_value_discarded
		connect('veiculo_selecionado', acessorio, '_ativar_acessorio')


func _process(delta) -> void:
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


func _reset_variaveis():
	engine_force = 0
	


# Conectado ao sinal veiculo_ativo que vem de Global
func _veiculo_ativado(veiculo_ativo : VehicleBody) -> void:
	# Se for o veiculo selecionado emite um sinal para seus acessorios sobre seu estado, senao for desativa o process
	if get_instance_id() == veiculo_ativo.get_instance_id():
		emit_signal('veiculo_selecionado', self, true)
	else:
		_reset_variaveis()
		set_process(false)
