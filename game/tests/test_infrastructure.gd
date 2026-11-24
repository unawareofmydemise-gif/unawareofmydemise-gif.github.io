extends GutTest
## Altyapı testleri: eklentiler yüklü ve çalışır durumda mı?

const StateChart := preload("res://addons/godot_state_charts/state_chart.gd")
const CompoundState := preload("res://addons/godot_state_charts/compound_state.gd")
const AtomicState := preload("res://addons/godot_state_charts/atomic_state.gd")
const Transition := preload("res://addons/godot_state_charts/transition.gd")


func test_dialogue_manager_autoload_exists():
	assert_not_null(
		get_tree().root.get_node_or_null("DialogueManager"), "DialogueManager autoload yok"
	)


func test_phantom_camera_manager_autoload_exists():
	var manager := get_tree().root.get_node_or_null("PhantomCameraManager")
	assert_not_null(manager, "PhantomCameraManager autoload yok")


func test_state_chart_switches_state():
	var chart := StateChart.new()
	var battle := CompoundState.new()
	battle.name = "Battle"
	var player_turn := AtomicState.new()
	player_turn.name = "PlayerTurn"
	var enemy_turn := AtomicState.new()
	enemy_turn.name = "EnemyTurn"
	var to_enemy := Transition.new()
	to_enemy.name = "ToEnemy"
	to_enemy.event = &"end_turn"
	player_turn.add_child(to_enemy)
	battle.add_child(player_turn)
	battle.add_child(enemy_turn)
	chart.add_child(battle)
	battle.initial_state = battle.get_path_to(player_turn)
	to_enemy.to = to_enemy.get_path_to(enemy_turn)
	add_child_autofree(chart)
	await wait_process_frames(3)
	chart.send_event(&"end_turn")
	await wait_process_frames(3)
	assert_true(enemy_turn.active, "EnemyTurn durumuna geçilmedi")
