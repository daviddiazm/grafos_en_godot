extends Node
class_name Init

@export var vertice: Vertice

@onready var graph: GraphSystem = $GraphSystem

@onready var btn_reset: Button = $btnReset

func _ready() -> void:
	if btn_reset:
		btn_reset.pressed.connect(_on_btn_reset_pressed)
	
	
	graph = GraphSystem.new()
	add_child(graph)
	
	#print("Generando grafo automático...")
	#graph.generate_linear_graph(16)
	#graph.print_graph()
	#
	## PRUEBA 2: Conexiones manuales
	#graph.adjacency_list.clear() 
	
	#graph.add_edge(1, 2)
	#graph.add_edge(2, 3)
	#graph.add_edge(1, 4)
	#graph.add_edge(4, 5)
	#graph.add_edge(1, 3)
	#graph.add_edge(1, 5)
	
	
	
	graph.generate_complete_graph(16)
	
	graph.print_graph()


func _on_btn_reset_pressed() -> void:
	graph.clear_visuals()
	graph.generate_complete_graph(16)
	
	graph.print_graph()
