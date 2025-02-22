class_name SpiderHandState extends State
## Idle state for character.
##

@export var spawn_delay : int = 2

var spider_hand : SpiderHand
const SPIDER_HAND = preload("res://game/character/player/handv2/spider_hand.tscn")

func enter() -> void:
	body.player_camera.interaction_ray.target_info.visible = false
	body.hud.visible = false
	body.anim_player.play("activate_spider_hand", 0.5)
	body.player_controller.input_disabled = true
	body.ui_controller.menu_disabled = true
	body.hud.fade_out()
	
	await get_tree().create_timer(spawn_delay).timeout
	body.anim_player.play("hand_out_idle", 0.2)
	
	spider_hand = SPIDER_HAND.instantiate()
	body.spiderhand = spider_hand
	spider_hand.state_ref = self
	get_tree().current_scene.add_child(spider_hand)
	spider_hand.global_position = body.spider_spawn_position.global_position
	spider_hand.player_camera.camera.make_current()
	
	body.hud.fade_in()
	
	
	super.enter()

func return_to_idle():
	body.player_camera.camera.make_current()
	body.hud.visible = true
	body.hud.fade_out()
	await get_tree().create_timer(spawn_delay).timeout
	body.spiderhand.queue_free()
	body.hud.fade_in()
	Transition.emit(self, "idlestate")

@warning_ignore("unused_parameter")
func handle_input(input) -> void:
	pass


func update_process(_delta) -> void:
	pass


func update_physics(_delta) -> void:
	pass


func exit() -> void:
	body.player_controller.input_disabled = false
	body.ui_controller.menu_disabled = false
	body.player_camera.interaction_ray.target_info.visible = true
	body.anim_player.play("idle")
	super.exit()
