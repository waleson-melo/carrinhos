extends Spatial

onready var junta : ConeTwistJoint = get_node("carroca_trator/junta")
onready var carroca : VehicleBody = get_node("carroca_trator")
var trator : VehicleBody = null
var flag : bool = true


func _input(_event) -> void:
	var vehicle : VehicleBody = Global.veiculos[Global.curent_veiculo].get_children()[0]
	
	if Input.is_action_just_pressed("track") and trator != null:
		if trator.get_instance_id() == vehicle.get_instance_id():
			junta.set_node_b('')
			junta.set_node_a('')
			flag = true


func _on_pino_gancho_body_entered(body) -> void:
	if flag:
		trator = body.get_parent()
		junta.set_node_b(body.get_parent().get_path())
		junta.set_node_a(carroca.get_path())
		flag = false
