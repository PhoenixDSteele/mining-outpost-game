class_name Cable extends Node3D

@export var cable_length : float = 5

var mesh_instance = MeshInstance3D
var immediate_mesh = ImmediateMesh
var material = ORMMaterial3D

func create_cable(pos1: Vector3, pos2: Vector3) -> void:
	mesh_instance = MeshInstance3D.new()
	immediate_mesh = ImmediateMesh.new()
	material = ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP,material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	add_child(mesh_instance)

func update_pos(pos1: Vector3, pos2: Vector3) -> void:
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP,material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
