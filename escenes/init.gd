extends Node
class_name Init

@export var vertice: Vertice

@onready var graph: GraphSystem = $GraphSystem

func _ready() -> void:
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
