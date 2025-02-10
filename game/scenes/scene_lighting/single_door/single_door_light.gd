class_name SingleDoorLight extends SpotLight3D

@onready var emission_mesh: MeshInstance3D = %EmissionMesh
var material : StandardMaterial3D

func _ready() -> void:
	material = emission_mesh.get_active_material(0)
	powered_off()

func powered_off() ->void:
	self.light_color = Color(0.5,0.5,0.4,1.0)
	self.light_energy = 0.1
	material.emission = Color(0.5,0.5,0.4,1.0)

func powered_on_unlocked() ->void:
	self.light_color = Color(0.1,0.6,0.0,1.0)
	self.light_energy = 0.5
	material.emission = Color(0.1,0.6,0.0,1.0)

func powered_on_locked() ->void:
	self.light_color = Color(0.9,0.15,0.2,1.0)
	self.light_energy = 0.5
	material.emission = Color(0.9,0.15,0.2,1.0)
