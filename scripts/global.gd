extends Node

var veiculos : Array = []
var curent_veiculo : int = 0

func _ready():
	veiculos = get_tree().get_nodes_in_group('veiculos')

func _process(_delta):
	if veiculos.size() != 0:
		veiculos[curent_veiculo].get_children()[0].set_process(true)
