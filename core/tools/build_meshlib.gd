@tool
extends EditorScript

# PATH TO YOUR FOLDER OF GLB FILES
const GLB_FOLDER = "res://assets/environments/PSX modular house interior pack/geometry/"
const SAVE_PATH = "res://assets/environments/meshlibs/psx_modular_house_interior.meshlib"

# Forces the lowest point of every mesh to sit flat on the grid floor (Y = 0)
const AUTO_GROUND_Y = true

# Keywords in filenames that need hollow/concave collisions (Trimesh)
const HOLLOW_KEYWORDS = ["arch", "door", "window", "frame", "opening", "tunnel"]

func _run() -> void:
	var mesh_lib = MeshLibrary.new()
	var dir = DirAccess.open(GLB_FOLDER)
	
	if not dir:
		print("Folder path invalid!")
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	var item_id = 0
	
	while file_name != "":
		if file_name.ends_with(".glb") or file_name.ends_with(".gltf"):
			var scene = load(GLB_FOLDER + file_name) as PackedScene
			if scene:
				var instance = scene.instantiate()
				var mesh_nodes: Array[MeshInstance3D] = []
				_find_all_mesh_instances(instance, mesh_nodes)
				
				if mesh_nodes.size() > 0:
					var primary_mesh = mesh_nodes[0]
					
					mesh_lib.create_item(item_id)
					mesh_lib.set_item_name(item_id, file_name.get_basename())
					mesh_lib.set_item_mesh(item_id, primary_mesh.mesh)
					
					# 1. Accumulate global transform
					var xform = instance.global_transform.affine_inverse() * primary_mesh.global_transform
					
					# 2. Auto-ground Y
					if AUTO_GROUND_Y:
						var aabb = primary_mesh.mesh.get_aabb()
						var lowest_y = (xform * aabb.position).y
						xform.origin.y -= lowest_y
					
					mesh_lib.set_item_mesh_transform(item_id, xform)
					
					# 3. SMART COLLISION GENERATION (Handles all sub-meshes)
					var lower_name = file_name.to_lower()
					var is_hollow = false
					var is_stair = "stair" in lower_name

					for kw in HOLLOW_KEYWORDS:
						if kw in lower_name:
							is_hollow = true
							break

					var shapes_and_transforms = []

					for m_node in mesh_nodes:
						var m_xform = instance.global_transform.affine_inverse() * m_node.global_transform
						if AUTO_GROUND_Y:
							var aabb = primary_mesh.mesh.get_aabb()
							var lowest_y = (m_xform * aabb.position).y
							m_xform.origin.y -= lowest_y
							
						var shape: Shape3D
						
						if is_stair:
							# --- RAMP FIX: Generate a smooth wedge ramp from the bounding box ---
							shape = _create_ramp_shape_from_aabb(m_node.mesh.get_aabb())
							print("Generated SMOOTH RAMP for stair: ", file_name)
						elif is_hollow:
							# Concave/Trimesh for arches/doorways
							shape = m_node.mesh.create_trimesh_shape()
						else:
							# Convex for flat walls and floors
							shape = m_node.mesh.create_convex_shape()
							
						shapes_and_transforms.append(shape)
						shapes_and_transforms.append(m_xform)

					mesh_lib.set_item_shapes(item_id, shapes_and_transforms)
					print("Added item #", item_id, ": ", file_name, " (Hollow: ", is_hollow, ")")
					item_id += 1
					
				instance.free()
				
		file_name = dir.get_next()
		
	ResourceSaver.save(mesh_lib, SAVE_PATH)
	print("SUCCESS! Re-created MeshLibrary at: ", SAVE_PATH)

func _find_all_mesh_instances(node: Node, result: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D and node.mesh:
		result.append(node)
	for child in node.get_children():
		_find_all_mesh_instances(child, result)
		
func _create_ramp_shape_from_aabb(aabb: AABB) -> ConvexPolygonShape3D:
	var min_p = aabb.position
	var max_p = aabb.position + aabb.size
	
	# Create 6 vertices forming a 3D wedge/ramp
	var points = PackedVector3Array([
		Vector3(min_p.x, min_p.y, min_p.z), # Bottom Front Left
		Vector3(max_p.x, min_p.y, min_p.z), # Bottom Front Right
		Vector3(min_p.x, min_p.y, max_p.z), # Bottom Back Left
		Vector3(max_p.x, min_p.y, max_p.z), # Bottom Back Right
		Vector3(min_p.x, max_p.y, max_p.z), # Top Back Left
		Vector3(max_p.x, max_p.y, max_p.z), # Top Back Right
	])
	
	var ramp = ConvexPolygonShape3D.new()
	ramp.points = points
	return ramp
