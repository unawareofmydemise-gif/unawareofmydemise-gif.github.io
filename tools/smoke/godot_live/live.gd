extends Node3D
## MCP izleme duman testi: açık kalan sahne (küre + ışık + arayüz etiketi).


func _ready() -> void:
	var mesh := MeshInstance3D.new()
	mesh.mesh = SphereMesh.new()
	add_child(mesh)
	var cam := Camera3D.new()
	cam.position = Vector3(0, 0, 3)
	add_child(cam)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-35, 35, 0)
	add_child(sun)
	var ui := CanvasLayer.new()
	add_child(ui)
	var label := Label.new()
	label.name = "Status"
	label.text = "MCP canlı"
	label.position = Vector2(40, 40)
	ui.add_child(label)
