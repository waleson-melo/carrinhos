extends Spatial

onready var junta = get_node("carroca_trator/junta")
onready var pino_gancho = get_node("carroca_trator")

var flag = true


func _on_pino_gancho_body_entered(body):
	if flag:
#		print(body.get_parent().get_path())
	#	print(pino_gancho.get_path())
		junta.set_node_b(body.get_parent().get_path())
		junta.set_node_a(pino_gancho.get_path())
		flag = false
