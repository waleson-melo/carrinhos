extends Node

signal veiculo_ativo(veiculo)

var veiculos : Array = []
var curent_veiculo : int = 0
var veiculo_anterior : int = -1

func _ready() -> void:
	_init_veiculos()

func _process(_delta) -> void:
	if veiculos.size() != 0 and curent_veiculo != veiculo_anterior:
		veiculo_anterior = curent_veiculo
		veiculos[curent_veiculo].set_process(true)
		emit_signal('veiculo_ativo', veiculos[curent_veiculo])

func _init_veiculos() -> void:
	var _veiculos : Array = get_tree().get_nodes_in_group('veiculos')
	# Pegando os veiculos de cada no, conectando um sinal nele e adicionando no array de veiculos
	for veiculo in _veiculos:
		# warning-ignore:return_value_discarded
		connect('veiculo_ativo', veiculo.get_children()[0], '_veiculo_ativado')
		veiculos.append(veiculo.get_children()[0])
